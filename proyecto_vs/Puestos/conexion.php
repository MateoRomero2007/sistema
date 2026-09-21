<?php
declare(strict_types=1);

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: SAMEORIGIN');
header('Referrer-Policy: same-origin');

function variableEntorno(string $nombre, string $predeterminado): string
{
    $valor = getenv($nombre);
    return $valor === false || $valor === '' ? $predeterminado : $valor;
}

$host = variableEntorno('PUESTOS_DB_HOST', '127.0.0.1');
$port = (int)variableEntorno('PUESTOS_DB_PORT', '3306');
$usuario = variableEntorno('PUESTOS_DB_USER', 'root');
$contrasena = getenv('PUESTOS_DB_PASSWORD') ?: '';
$baseDatos = variableEntorno('PUESTOS_DB_NAME', 'puestos');

try {
    $conn = new mysqli($host, $usuario, $contrasena, $baseDatos, $port);
    $conn->set_charset('utf8mb4');

    $resultado = $conn->query("SHOW COLUMNS FROM reserva LIKE 'clave_reserva'");
    if ($resultado && $resultado->num_rows === 0) {
        $conn->query("ALTER TABLE reserva ADD COLUMN clave_reserva VARCHAR(255) NOT NULL DEFAULT ''");
    }
} catch (mysqli_sql_exception $error) {
    error_log($error->getMessage());
    http_response_code(500);
    die('No se pudo conectar con la base de datos.');
}
?>
