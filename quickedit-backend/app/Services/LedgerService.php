<?php
declare(strict_types=1);

namespace QuickEdit\Services;

use PDO;

class LedgerService {
    public static function creditPending(PDO $pdo, int $editorId, int $bookingId, float $netAmount, string $description): void {
        $stmt = $pdo->prepare("
            INSERT INTO editor_ledger (editor_id, booking_id, entry_type, amount, balance_after, description)
            VALUES (?, ?, 'pending_credit', ?, 0.00, ?)
        ");
        $stmt->execute([$editorId, $bookingId, $netAmount, $description]);
    }

    public static function releasePendingToAvailable(PDO $pdo, int $editorId, int $bookingId, float $netAmount): void {
        $stmt = $pdo->prepare("
            INSERT INTO editor_ledger (editor_id, booking_id, entry_type, amount, description)
            VALUES (?, ?, 'available_credit', ?, 'Client approved order delivery. Withdrawable balance unlocked.')
        ");
        $stmt->execute([$editorId, $bookingId, $netAmount]);
    }

    public static function getBalances(PDO $pdo, int $editorId): array {
        $stmt = $pdo->prepare("
            SELECT 
                COALESCE(SUM(CASE WHEN entry_type = 'available_credit' THEN amount WHEN entry_type = 'withdrawal_hold' THEN -amount ELSE 0 END), 0) AS available_balance,
                COALESCE(SUM(CASE WHEN entry_type = 'pending_credit' THEN amount ELSE 0 END), 0) AS pending_balance
            FROM editor_ledger
            WHERE editor_id = ?
        ");
        $stmt->execute([$editorId]);
        return $stmt->fetch() ?: ['available_balance' => 0.00, 'pending_balance' => 0.00];
    }
}
