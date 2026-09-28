    <?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

$conn = new mysqli('127.0.0.1', 'root', '', 'puestos', 3306);
if ($conn->connect_errno) {
    echo "DB_CONNECT_ERROR: {$conn->connect_error}\n";
    exit(1);
}
$conn->set_charset('utf8mb4');
$conn->query("ALTER TABLE reserva ADD COLUMN IF NOT EXISTS clave_reserva VARCHAR(255) NOT NULL DEFAULT ''");

$fechaObjeto = new DateTimeImmutable('tomorrow');
while ((int)$fechaObjeto->format('N') >= 6) {
    $fechaObjeto = $fechaObjeto->modify('+1 day');
}
$fecha = $fechaObjeto->format('Y-m-d');
$dias = ['domingo', 'lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado'];
$diaReserva = $dias[(int)date('w', strtotime($fecha))];
$diasCasa = [$diaReserva];

$sql = "SELECT p.codigo_puesto, p.id_puesto, u.nombre, u.dia_casa
        FROM puesto p
        LEFT JOIN usuario u ON u.id_usuario = p.id_usuario
        LEFT JOIN reserva r ON r.id_puesto = p.id_puesto AND r.fecha = ?
        WHERE p.reservable = 1 AND p.estado = 1 AND r.id_reserva IS NULL
                    AND TRIM(LOWER(COALESCE(u.dia_casa, ''))) = ?
        ORDER BY p.codigo_puesto ASC LIMIT 1";
$stmt = $conn->prepare($sql);
$diaCasaUno = $diasCasa[0] ?? '';
$stmt->bind_param('ss', $fecha, $diaCasaUno);
$stmt->execute();
$seat = $stmt->get_result()->fetch_assoc();

if (!$seat) {
    echo "NO_VALID_CANDIDATE\n";
    echo "FECHA={$fecha}\n";
    echo "DIA={$diaReserva}\n";
    exit(0);
}

echo "FECHA={$fecha}\n";
echo "DIA={$diaReserva}\n";
echo "SEAT={$seat['codigo_puesto']}\n";
echo "OWNER={$seat['nombre']}\n";

$payload = json_encode([
    'codigo_puesto' => $seat['codigo_puesto'],
    'nombre' => 'PruebaReal',
    'area' => 'Tecnologia',
    'clave' => 'abcd1234'
]);

$ctx = stream_context_create([
    'http' => [
        'method' => 'POST',
        'header' => "Content-Type: application/json\r\nAccept: application/json\r\n",
        'content' => $payload,
        'ignore_errors' => true,
        'timeout' => 30,
    ]
]);
$response = @file_get_contents('http://localhost/proyecto_vs/Puestos/reservar_puesto.php', false, $ctx);

echo "HTTP_RESPONSE=" . ($response === false ? 'NO_RESPONSE' : $response) . "\n";
