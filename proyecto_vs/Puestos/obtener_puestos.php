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

$fecha = $_GET['fecha'] ?? siguienteDiaLaboral();
if (!is_string($fecha) || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $fecha)) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'mensaje' => 'La fecha no es válida.'], JSON_UNESCAPED_UNICODE);
    exit;
}
$fechaObjeto = DateTime::createFromFormat('!Y-m-d', $fecha);
if (!$fechaObjeto || $fechaObjeto->format('Y-m-d') !== $fecha) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'mensaje' => 'La fecha no es válida.'], JSON_UNESCAPED_UNICODE);
    exit;
}
$dias = ['domingo', 'lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado'];
$diaReserva = $dias[(int)date('w', strtotime($fecha))];

$sql = "SELECT p.codigo_puesto, p.numero_puesto, p.ubicacion, p.reservable, p.estado,
               p.observacion, p.motivo, u.id_usuario, u.nombre, u.cargo, u.area,
               u.dia_casa, u.horario, u.foto,
               r.id_reserva, r.fecha AS fecha_reserva, ru.nombre AS nombre_reserva,
               ru.area AS area_reserva
        FROM puesto p
        LEFT JOIN usuario u ON u.id_usuario = p.id_usuario
        LEFT JOIN reserva r ON r.id_puesto = p.id_puesto AND r.fecha = ?
        LEFT JOIN usuario ru ON ru.id_usuario = r.id_usuario
        ORDER BY p.codigo_puesto";

$stmt = $conn->prepare($sql);
$stmt->bind_param('s', $fecha);
$stmt->execute();
$result = $stmt->get_result();

$puestos = [];
while ($fila = $result->fetch_assoc()) {
    $fila['reservable'] = (bool)$fila['reservable'];
    $fila['estado'] = (bool)$fila['estado'];
    $fila['reservado'] = $fila['id_reserva'] !== null;
    $diaCasa = trim(strtolower(strtr((string)($fila['dia_casa'] ?? ''), [
        'á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u', 'ü' => 'u'
    ])));
    $fila['disponible'] = $fila['reservable'] && $fila['estado'] && !$fila['reservado'] && $diaCasa === $diaReserva;
    $fila['variable'] = false;
    $puestos[] = $fila;
}

$sinPuesto = [];
$sqlSin = "SELECT u.id_usuario, u.nombre, u.cargo, u.area, u.dia_casa, u.horario, u.foto
           FROM usuario u
           LEFT JOIN puesto p ON p.id_usuario = u.id_usuario
                     WHERE p.id_usuario IS NULL
                         AND u.estado = 1
                         AND LOWER(COALESCE(u.cargo, '')) NOT LIKE '%líder%'
                                                 AND LOWER(COALESCE(u.cargo, '')) <> 'reservante'
                         AND NOT EXISTS (
                             SELECT 1
                             FROM reserva r2
                                                         WHERE r2.id_usuario = u.id_usuario
                                                             AND r2.estado = 'reservada'
                         )
           ORDER BY u.nombre";
$stmtSin = $conn->prepare($sqlSin);
$stmtSin->execute();
$resSin = $stmtSin->get_result();
if ($resSin) {
    while ($fila = $resSin->fetch_assoc()) {
        $sinPuesto[] = $fila;
    }
}

echo json_encode([
    'ok' => true,
    'fecha' => $fecha,
    'puestos' => $puestos,
    'sin_puesto_fijo' => $sinPuesto
], JSON_UNESCAPED_UNICODE);
