<?php
declare(strict_types=1);

namespace QuickEdit\Config;

use PDO;
use PDOException;

class Database {
    private static ?PDO $instance = null;

    public static function getConnection(): PDO {
        if (self::$instance === null) {
            $host = Env::get('DB_HOST', '127.0.0.1');
            $db = Env::get('DB_NAME', 'quickedit');
            $user = Env::get('DB_USER', 'root');
            $pass = Env::get('DB_PASS', '');
            $port = Env::get('DB_PORT', '3306');

            $dsn = "mysql:host={$host};port={$port};dbname={$db};charset=utf8mb4";
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ];

            try {
                self::$instance = new PDO($dsn, $user, $pass, $options);
            } catch (PDOException $e) {
                throw new \RuntimeException("Database connection failed: " . $e->getMessage());
            }
        }
        return self::$instance;
    }
}
