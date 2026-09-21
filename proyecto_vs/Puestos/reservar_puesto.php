<?php
declare(strict_types=1);
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json; charset=utf-8');
require_once 'conexion.php';

function siguienteDiaLaboral(): string
{
    $fecha = new DateTimeImmutable('tomorrow');
    while ((int)$fecha->format('N') >= 6) {
        $fecha = $fecha->modify('+1 day');
    }
    return $fecha->format('Y-m-d');
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    header('Allow: POST');
    echo json_encode(['ok'=>false,'mensaje'=>'Método no permitido.'], JSON_UNESCAPED_UNICODE);
    exit;
}

$contenido = file_get_contents('php://input');
if (strlen($contenido) > 4096) {
    http_response_code(413);
    echo json_encode(['ok'=>false,'mensaje'=>'La solicitud es demasiado grande.'], JSON_UNESCAPED_UNICODE);
    exit;
}
$entrada = json_decode($contenido, true) ?? [];
$codigo = trim((string)($entrada['codigo_puesto'] ?? ''));
$nombre = trim((string)($entrada['nombre'] ?? ''));
$area = trim((string)($entrada['area'] ?? ''));
$clave = (string)($entrada['clave'] ?? '');

if (!preg_match('/^[A-Za-z0-9_-]{1,10}$/', $codigo)
    || !preg_match('/^[\p{L}\p{N} .\'’-]{2,100}$/u', $nombre)
    || !preg_match('/^[\p{L}\p{N} .\'’-]{2,100}$/u', $area)
    || strlen($clave) < 4 || strlen($clave) > 72) {
    http_response_code(400);
    echo json_encode(['ok'=>false,'mensaje'=>'Los datos de la reserva no son válidos.'], JSON_UNESCAPED_UNICODE);
    exit;
}

$fecha = siguienteDiaLaboral();
$dias = ['domingo','lunes','martes','miercoles','jueves','viernes','sabado'];
$diaReserva = $dias[(int)date('w', strtotime($fecha))];

$sql = "SELECT p.id_puesto, p.reservable, p.estado, u.id_usuario AS propietario_id,
               u.dia_casa, p.numero_puesto, p.observacion
        FROM puesto p
        LEFT JOIN usuario u ON u.id_usuario = p.id_usuario
        WHERE p.codigo_puesto = ? LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param('s', $codigo);
$stmt->execute();
$puesto = $stmt->get_result()->fetch_assoc();

if (!$puesto) {
    http_response_code(404);
    echo json_encode(['ok'=>false,'mensaje'=>'El puesto no existe.'], JSON_UNESCAPED_UNICODE);
    exit;
}

if (!(bool)$puesto['reservable'] || !(bool)$puesto['estado']) {
    http_response_code(409);
    echo json_encode(['ok'=>false,'mensaje'=>'Este puesto no se puede reservar.'], JSON_UNESCAPED_UNICODE);
    exit;
}

$diaCasa = trim(strtolower(strtr((string)($puesto['dia_casa'] ?? ''), [
    'á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u', 'ü' => 'u'
])));
if ($diaCasa !== $diaReserva) {
    http_response_code(409);
    echo json_encode(['ok'=>false,'mensaje'=>'Este puesto solo puede reservarse cuando su día desde casa coincide con el siguiente calendario.'], JSON_UNESCAPED_UNICODE);
    exit;
}

$conn->begin_transaction();
try {
    $stmt = $conn->prepare("SELECT id_reserva FROM reserva WHERE id_puesto = ? AND fecha = ? FOR UPDATE");
    $stmt->bind_param('is', $puesto['id_puesto'], $fecha);
    $stmt->execute();
    if ($stmt->get_result()->num_rows > 0) {
        throw new Exception('El puesto ya fue reservado para esa fecha.');
    }

    $stmt = $conn->prepare("SELECT id_usuario FROM usuario WHERE LOWER(nombre) = LOWER(?) LIMIT 1");
    $stmt->bind_param('s', $nombre);
    $stmt->execute();
    $usuario = $stmt->get_result()->fetch_assoc();

    if ($usuario) {
        $idUsuario = (int)$usuario['id_usuario'];
    } else {
        $cargo = 'Reservante';
        $diaCasaUsuario = 'No aplica';
        $horario = 'No aplica';
        $stmt = $conn->prepare("INSERT INTO usuario (nombre, cargo, area, dia_casa, horario, foto, estado) VALUES (?, ?, ?, ?, ?, NULL, 1)");
        $stmt->bind_param('sssss', $nombre, $cargo, $area, $diaCasaUsuario, $horario);
        $stmt->execute();
        $idUsuario = $conn->insert_id;
    }

    $estado = 'reservada';
    $claveHash = password_hash($clave, PASSWORD_DEFAULT);
    $stmt = $conn->prepare("INSERT INTO reserva (id_usuario, id_puesto, fecha, estado, clave_reserva) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param('iisss', $idUsuario, $puesto['id_puesto'], $fecha, $estado, $claveHash);
    $stmt->execute();

    $conn->commit();
    echo json_encode(['ok'=>true,'mensaje'=>'Reserva realizada correctamente.','fecha'=>$fecha], JSON_UNESCAPED_UNICODE);
} catch (Throwable $e) {
    $conn->rollback();
    error_log($e->getMessage());
    http_response_code(409);
    echo json_encode(['ok'=>false,'mensaje'=>'No se pudo completar la reserva: ' . $e->getMessage()], JSON_UNESCAPED_UNICODE);
}
