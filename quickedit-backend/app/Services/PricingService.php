<?php
declare(strict_types=1);

namespace QuickEdit\Services;

class PricingService {
    public static function calculateQuote(float $basePrice, array $addons = [], float $discount = 0.0): array {
        $addonsTotal = 0.0;
        foreach ($addons as $addon) {
            $addonsTotal += (float)($addon['price'] ?? 0.0);
        }

        $platformFee = 0.0; // Platform fee currently ₹0
        $subtotal = $basePrice + $addonsTotal;
        $tax = round($subtotal * 0.0, 2); // GST handling if applicable
        $total = max(0.0, $subtotal - $discount + $tax);

        return [
            'base_amount' => $basePrice,
            'addons_amount' => $addonsTotal,
            'platform_fee' => $platformFee,
            'discount_amount' => $discount,
            'tax_amount' => $tax,
            'total_amount' => $total,
            'currency' => 'INR',
        ];
    }
}
