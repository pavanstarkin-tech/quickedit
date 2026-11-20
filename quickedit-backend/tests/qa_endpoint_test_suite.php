<?php
declare(strict_types=1);

// QuickEdit Automated End-to-End API QA Test Suite
// Tests every endpoint against the active XAMPP MySQL backend and live HTTP server

$baseUrl = 'http://127.0.0.1:8000';
$testsPassed = 0;
$testsFailed = 0;
$results = [];
$activeJwtToken = '';

function callApi(string $method, string $path, array $data = [], ?string $bearerToken = null): array {
    global $baseUrl, $activeJwtToken;
    $url = $baseUrl . $path;
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($ch, CURLOPT_TIMEOUT, 5);

    $headers = [
        'Content-Type: application/json',
        'Accept: application/json',
    ];

    $tokenToUse = $bearerToken ?? $activeJwtToken;
    if (!empty($tokenToUse)) {
        $headers[] = "Authorization: Bearer {$tokenToUse}";
    }

    if (!empty($data) && in_array($method, ['POST', 'PUT', 'PATCH'])) {
        $json = json_encode($data);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
        $headers[] = 'Content-Length: ' . strlen($json);
    }

    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    $raw = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $err = curl_error($ch);
    curl_close($ch);

    if ($err) {
        return ['status' => 0, 'error' => $err, 'json' => null];
    }

    $json = json_decode($raw ?: '', true);
    return ['status' => $httpCode, 'json' => $json, 'raw' => $raw];
}

function runTest(string $name, string $method, string $path, array $data, int $expectedStatus, ?callable $validate = null, ?string $token = null): void {
    global $testsPassed, $testsFailed, $results;
    
    $res = callApi($method, $path, $data, $token);
    $passed = ($res['status'] === $expectedStatus);

    $validationMsg = 'OK';
    if ($passed && $validate !== null) {
        try {
            $valResult = $validate($res['json']);
            if ($valResult !== true) {
                $passed = false;
                $validationMsg = is_string($valResult) ? $valResult : 'Validation condition failed';
            }
        } catch (\Throwable $e) {
            $passed = false;
            $validationMsg = $e->getMessage();
        }
    } elseif (!$passed) {
        $validationMsg = "Expected HTTP {$expectedStatus}, got {$res['status']}";
    }

    if ($passed) {
        $testsPassed++;
        echo "[PASS] {$name} ({$method} {$path}) -> HTTP {$res['status']}\n";
    } else {
        $testsFailed++;
        echo "[FAIL] {$name} ({$method} {$path}) -> {$validationMsg}\n";
    }

    $results[] = [
        'name' => $name,
        'method' => $method,
        'path' => $path,
        'status' => $res['status'],
        'expected' => $expectedStatus,
        'passed' => $passed,
        'details' => $validationMsg,
        'response_sample' => $res['json'] ? array_slice($res['json'], 0, 3, true) : null,
    ];
}

echo "========================================================================\n";
echo " QUICKEDIT AUTOMATED REST API QA TEST SUITE\n";
echo " Target Server: {$baseUrl}\n";
echo " Database: MySQL 8.0 / MariaDB 10.4 (XAMPP localhost:3306)\n";
echo " Started at: " . date('Y-m-d H:i:s') . "\n";
echo "========================================================================\n\n";

// 1. Health
runTest('API Health & Database Connectivity', 'GET', '/api/v1/health', [], 200, function($j) {
    return isset($j['data']['database']) && $j['data']['database'] === 'connected';
});

// 2. Auth: Login as Client (Maya Patel)
runTest('Auth: Login as Client with JWT Minting', 'POST', '/api/v1/auth/login', [
    'email' => 'maya.patel@quickedit.dev',
    'password' => 'password123',
], 200, function($j) {
    global $activeJwtToken;
    if (isset($j['data']['token']) && !empty($j['data']['token'])) {
        $activeJwtToken = $j['data']['token'];
        return ($j['data']['role'] === 'client');
    }
    return 'Missing JWT token in response';
});

// 3. Auth: Session Validation via JWT (/auth/me)
runTest('Auth: JWT Bearer Token Session Validation (/auth/me)', 'GET', '/api/v1/auth/me', [], 200, function($j) {
    return isset($j['data']['user']['email']) && $j['data']['user']['email'] === 'maya.patel@quickedit.dev';
});

// 4. Auth: Register New Client Account
$randNum = rand(100, 999);
runTest('Auth: Client Self-Registration with Role Assignment', 'POST', '/api/v1/auth/register', [
    'email' => "test.client.{$randNum}@quickedit.dev",
    'password' => 'password123',
    'full_name' => 'Aditi Sharma',
    'role' => 'client',
], 201, function($j) {
    return isset($j['data']['token']) && $j['data']['role'] === 'client';
});

// 5. Auth: Register New Editor Account
runTest('Auth: Video Editor Registration with Role Assignment', 'POST', '/api/v1/auth/register', [
    'email' => "test.editor.{$randNum}@quickedit.dev",
    'password' => 'password123',
    'full_name' => 'Karan Rawat',
    'role' => 'editor',
], 201, function($j) {
    return isset($j['data']['token']) && $j['data']['role'] === 'editor';
});

// 6. Client Home
runTest('Client Home Dashboard (M01)', 'GET', '/api/v1/home/client', [], 200, function($j) {
    return isset($j['data']['top_verified_editors']) && count($j['data']['top_verified_editors']) > 0;
});

// 7. Browse Editors
runTest('Browse & Search Editors (M02)', 'GET', '/api/v1/editors', [], 200, function($j) {
    return isset($j['data']['editors']) && count($j['data']['editors']) >= 1;
});

// 8. Editor Profile
runTest('Editor Profile & Specializations (M03)', 'GET', '/api/v1/editors/detail?id=3', [], 200, function($j) {
    return isset($j['data']['name']) && $j['data']['name'] === 'Rohan Mehta';
});

// 9. Services Catalog
runTest('Services & Add-Ons Catalog', 'GET', '/api/v1/services', [], 200, function($j) {
    return isset($j['data']['services']) && count($j['data']['services']) >= 4;
});

// 10. Pricing Quote
runTest('Server Price Quote Calculation', 'POST', '/api/v1/bookings/quote', [
    'base_price' => 1499.0,
    'addons' => [['price' => 500.0]],
    'discount' => 100.0,
], 200, function($j) {
    return isset($j['data']['total_amount']) && $j['data']['total_amount'] == 1899.0;
});

// 11. Create Booking
runTest('Create Booking Wizard Step 4 (M04)', 'POST', '/api/v1/bookings', [
    'client_id' => 1,
    'editor_id' => 3,
    'service_id' => 2,
    'base_amount' => 1999.0,
    'addons_amount' => 500.0,
    'brief' => 'Dynamic 45-second commercial for wireless headphones',
], 201, function($j) {
    return isset($j['data']['booking_id']) && isset($j['data']['order_code']);
});

// 12. List Bookings
runTest('List Active Bookings', 'GET', '/api/v1/bookings', [], 200, function($j) {
    return isset($j['data']['bookings']) && count($j['data']['bookings']) > 0;
});

// 13. Booking Details
runTest('Order Tracking Details (M06)', 'GET', '/api/v1/bookings/detail?id=1', [], 200, function($j) {
    return isset($j['data']['order_code']) && $j['data']['order_code'] === '#QE2457';
});

// 14. Direct-to-R2 Presign
runTest('Direct-to-R2 Presigned PUT Generator', 'POST', '/api/v1/uploads/presign', [
    'uploader_id' => 1,
    'file_name' => 'raw_broll_clip.mov',
    'mime_type' => 'video/quicktime',
    'size_bytes' => 450000000,
], 201, function($j) {
    return isset($j['data']['presigned_put_url']) && str_contains($j['data']['presigned_put_url'], 'r2.quickedit.com');
});

// 15. Complete Upload
runTest('Finalize & Verify Upload', 'POST', '/api/v1/uploads/complete', [
    'media_id' => 1,
], 200, function($j) {
    return isset($j['data']['status']) && $j['data']['status'] === 'uploaded';
});

// 16. Razorpay Order Creation
runTest('Razorpay Server Order Creation (M05)', 'POST', '/api/v1/payments/razorpay/order', [
    'booking_id' => 1,
], 201, function($j) {
    return isset($j['data']['razorpay_order_id']) && isset($j['data']['amount_paise']);
});

// 17. Razorpay Signature Verification & Ledger Hold
runTest('Razorpay Verification & Ledger Locking (M05)', 'POST', '/api/v1/payments/razorpay/verify', [
    'booking_id' => 1,
    'razorpay_payment_id' => 'pay_test_live_verify_88',
], 200, function($j) {
    return isset($j['data']['status']) && $j['data']['status'] === 'payment_captured';
});

// 18. Razorpay Authoritative Webhook
runTest('Authoritative Webhook Ingestion', 'POST', '/api/v1/webhooks/razorpay', [
    'event_id' => 'evt_qa_test_' . rand(1000, 9999),
    'event' => 'payment.captured',
], 200, function($j) {
    return isset($j['data']['status']) && $j['data']['status'] === 'webhook_processed';
});

// 19. Editor Dashboard KPIs
runTest('Editor Dashboard & Live Metrics (M07)', 'GET', '/api/v1/editor/dashboard?editor_id=3', [], 200, function($j) {
    return isset($j['data']['available_balance']) && isset($j['data']['upcoming_deadlines']);
});

// 20. Editor Job Requests
runTest('Editor Incoming Job Requests (M08)', 'GET', '/api/v1/editor/job-requests', [], 200, function($j) {
    return isset($j['data']['job_requests']);
});

// 21. Atomic Job Acceptance
runTest('Atomic Job Acceptance with Row Lock (M08)', 'POST', '/api/v1/editor/job-requests/accept', [
    'booking_id' => 1,
    'editor_id' => 3,
], 200, function($j) {
    return isset($j['data']['status']) && $j['data']['status'] === 'accepted';
});

// 22. Project Workspace
runTest('Project Workspace Files & Checklist (M09)', 'GET', '/api/v1/projects/workspace?booking_id=1', [], 200, function($j) {
    return isset($j['data']['booking']) && isset($j['data']['checklist']);
});

// 23. Order Approval & Ledger Release
runTest('Order Delivery Approval & Ledger Balance Release (M06)', 'POST', '/api/v1/orders/approve', [
    'booking_id' => 1,
], 200, function($j) {
    return isset($j['data']['status']) && $j['data']['status'] === 'completed';
});

// 24. Editor Earnings & Ledger
runTest('Editor Earnings & Transaction History (M11)', 'GET', '/api/v1/editor/earnings?editor_id=3', [], 200, function($j) {
    return isset($j['data']['available_balance']) && isset($j['data']['transactions']);
});

// 25. Editor Withdrawal Request
runTest('Editor Withdrawal Request & Balance Hold (M11)', 'POST', '/api/v1/editor/withdrawals', [
    'editor_id' => 3,
    'amount' => 5000.0,
], 201, function($j) {
    return isset($j['data']['withdrawal_id']) && $j['data']['status'] === 'pending_approval';
});

// 26. Admin Analytics
runTest('Admin Executive Analytics Overview (M13)', 'GET', '/api/v1/admin/analytics/overview', [], 200, function($j) {
    return isset($j['data']['gmv']) && isset($j['data']['platform_net_revenue']);
});

// 27. Admin Audit Logs
runTest('Admin Immutable Audit Logs (M13)', 'GET', '/api/v1/admin/audit-logs', [], 200, function($j) {
    return isset($j['data']['audit_logs']);
});

// 28. Logout
runTest('Auth: Session Termination & Logout', 'POST', '/api/v1/auth/logout', [], 200, function($j) {
    return isset($j['data']['message']);
});

echo "\n========================================================================\n";
echo " QA TEST SUITE SUMMARY\n";
echo " Total Tests Run: " . ($testsPassed + $testsFailed) . "\n";
echo " Passed: {$testsPassed}\n";
echo " Failed: {$testsFailed}\n";
echo " Success Rate: " . round(($testsPassed / ($testsPassed + $testsFailed)) * 100, 1) . "%\n";
echo "========================================================================\n";
