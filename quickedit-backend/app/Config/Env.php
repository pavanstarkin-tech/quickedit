<?php
declare(strict_types=1);

namespace QuickEdit\Config;

class Env {
    private static array $data = [];

    public static function load(string $path): array {
        if (!file_exists($path)) {
            return self::$data = [
                'APP_ENV' => 'local',
                'DB_HOST' => '127.0.0.1',
                'DB_NAME' => 'quickedit',
                'DB_USER' => 'root',
                'DB_PASS' => '',
            ];
        }

        $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (str_starts_with(trim($line), '#')) continue;
            if (strpos($line, '=') !== false) {
                [$k, $v] = explode('=', $line, 2);
                self::$data[trim($k)] = trim($v, " \t\n\r\0\x0B\"'");
            }
        }
        return self::$data;
    }

    public static function get(string $key, mixed $default = null): mixed {
        return self::$data[$key] ?? $default;
    }
}
