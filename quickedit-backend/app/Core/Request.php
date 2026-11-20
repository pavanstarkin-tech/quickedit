<?php
declare(strict_types=1);

namespace QuickEdit\Core;

class Request {
    private string $method;
    private string $uri;
    private array $headers;
    private ?array $jsonBody;

    public function __construct(string $method, string $uri, array $headers, ?array $jsonBody) {
        $this->method = strtoupper($method);
        $this->uri = parse_url($uri, PHP_URL_PATH) ?? '/';
        $this->headers = $headers;
        $this->jsonBody = $jsonBody;
    }

    public static function capture(): self {
        $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
        $uri = $_SERVER['REQUEST_URI'] ?? '/';
        
        $headers = [];
        if (function_exists('getallheaders')) {
            $headers = getallheaders() ?: [];
        } else {
            foreach ($_SERVER as $key => $value) {
                if (str_starts_with($key, 'HTTP_')) {
                    $header = str_replace(' ', '-', ucwords(str_replace('_', ' ', strtolower(substr($key, 5)))));
                    $headers[$header] = $value;
                }
            }
        }
        
        $raw = file_get_contents('php://input');
        $json = json_decode($raw ?: '', true);

        return new self($method, $uri, $headers, is_array($json) ? $json : null);
    }

    public function getMethod(): string {
        return $this->method;
    }

    public function getUri(): string {
        return $this->uri;
    }

    public function json(): array {
        return $this->jsonBody ?? [];
    }

    public function getBearerToken(): ?string {
        $auth = $this->headers['Authorization'] ?? $this->headers['authorization'] ?? '';
        if (preg_match('/Bearer\s+(.*)$/i', $auth, $matches)) {
            return trim($matches[1]);
        }
        return null;
    }
}
