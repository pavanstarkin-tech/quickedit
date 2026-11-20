<?php
declare(strict_types=1);

namespace QuickEdit\Core;

class Response {
    public static function json(mixed $data, int $status = 200, array $meta = []): void {
        http_response_code($status);
        $payload = [
            'success' => $status >= 200 && $status < 300,
            'data' => $data,
        ];
        if (!empty($meta)) {
            $payload['meta'] = $meta;
        }
        echo json_encode($payload, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
        exit;
    }

    public static function error(string $code, string $message, int $status = 400, array $details = []): void {
        http_response_code($status);
        $payload = [
            'success' => false,
            'error' => [
                'code' => $code,
                'message' => $message,
            ]
        ];
        if (!empty($details)) {
            $payload['error']['details'] = $details;
        }
        echo json_encode($payload, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
        exit;
    }
}
