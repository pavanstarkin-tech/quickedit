<?php
declare(strict_types=1);

namespace QuickEdit\Services;

class JwtService {
    private static string $secret = 'quickedit_dev_super_secret_jwt_key_2026_xyz';

    public static function generateToken(array $claims, int $ttlSeconds = 604800): string {
        $header = ['alg' => 'HS256', 'typ' => 'JWT'];
        $issuedAt = time();
        $payload = array_merge($claims, [
            'iat' => $issuedAt,
            'exp' => $issuedAt + $ttlSeconds,
        ]);

        $b64Header = self::base64UrlEncode(json_encode($header));
        $b64Payload = self::base64UrlEncode(json_encode($payload));
        $signature = hash_hmac('sha256', "{$b64Header}.{$b64Payload}", self::$secret, true);
        $b64Signature = self::base64UrlEncode($signature);

        return "{$b64Header}.{$b64Payload}.{$b64Signature}";
    }

    public static function verifyToken(string $token): ?array {
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            return null;
        }

        [$b64Header, $b64Payload, $b64Signature] = $parts;
        $expectedSig = hash_hmac('sha256', "{$b64Header}.{$b64Payload}", self::$secret, true);
        $providedSig = self::base64UrlDecode($b64Signature);

        if (!hash_equals($expectedSig, $providedSig)) {
            return null;
        }

        $payload = json_decode(self::base64UrlDecode($b64Payload), true);
        if (!is_array($payload)) {
            return null;
        }

        if (isset($payload['exp']) && $payload['exp'] < time()) {
            return null; // Expired
        }

        return $payload;
    }

    private static function base64UrlEncode(string $data): string {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    private static function base64UrlDecode(string $data): string {
        return base64_decode(strtr($data, '-_', '+/') . str_repeat('=', 3 - (3 + strlen($data)) % 4));
    }
}
