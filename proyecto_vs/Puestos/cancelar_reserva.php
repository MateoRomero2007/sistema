<?php
header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
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
if (strlen($contenido) > 1024) {
    http_response_code(413);
    echo json_encode(['ok'=>false,'mensaje'=>'La solicitud es demasiado grande.'], JSON_UNESCAPED_UNICODE);
    exit;
}
$entrada = json_decode($contenido, true);
$entrada = is_array($entrada) ? $entrada : [];
$codigo = trim((string)($entrada['codigo_puesto'] ?? ''));
$nombre = trim((string)($entrada['nombre'] ?? ''));
$area = trim((string)($entrada['area'] ?? ''));
$clave = (string)($entrada['clave'] ?? '');
$fecha = siguienteDiaLaboral();

if (!preg_match('/^[A-Za-z0-9_-]{1,10}$/', $codigo)
    || !preg_match('/^[\p{L}\p{N} .\'’-]{2,100}$/u', $nombre)
    || !preg_match('/^[\p{L}\p{N} .\'’-]{2,100}$/u', $area)
    || strlen($clave) < 4 || strlen($clave) > 72) {
    http_response_code(400);
    echo json_encode(['ok'=>false,'mensaje'=>'Falta el código del puesto.'], JSON_UNESCAPED_UNICODE);
    exit;
}

$stmt = $conn->prepare("SELECT id_puesto FROM puesto WHERE codigo_puesto = ? LIMIT 1");
$stmt->bind_param('s', $codigo);
$stmt->execute();
$puesto = $stmt->get_result()->fetch_assoc();

if (!$puesto) {
    http_response_code(404);
    echo json_encode(['ok'=>false,'mensaje'=>'El puesto no existe.'], JSON_UNESCAPED_UNICODE);
    exit;
}

$stmt = $conn->prepare("SELECT r.id_reserva, r.clave_reserva
                                                FROM reserva r
                                                INNER JOIN usuario u ON u.id_usuario = r.id_usuario
                                                WHERE r.id_puesto = ?
                                                    AND r.fecha = ?
                                                    AND r.estado = 'reservada'
                                                    AND LOWER(u.nombre) = LOWER(?)
                                                LIMIT 1");
$stmt->bind_param('iss', $puesto['id_puesto'], $fecha, $nombre);
$stmt->execute();
$reserva = $stmt->get_result()->fetch_assoc();

if (!$reserva || !is_string($reserva['clave_reserva']) || !password_verify($clave, $reserva['clave_reserva'])) {
        http_response_code(403);
        echo json_encode(['ok'=>false,'mensaje'=>'No se pudo validar la reserva.'], JSON_UNESCAPED_UNICODE);
        exit;
}

$stmt = $conn->prepare("DELETE FROM reserva WHERE id_reserva = ?");
$stmt->bind_param('i', $reserva['id_reserva']);
$stmt->execute();

echo json_encode([
    'ok' => true,
    'mensaje' => 'Reserva cancelada correctamente.',
    'fecha' => $fecha
], JSON_UNESCAPED_UNICODE);
