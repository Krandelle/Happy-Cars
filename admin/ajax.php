<?php
session_start();
include 'db_connect.php';
include 'admin_class.php';
$crud = new Action();

// Debug logger
function log_debug($msg) {
    file_put_contents('debug.txt', date("Y-m-d H:i:s") . " - " . $msg . "\n", FILE_APPEND);
}

// Error reporting
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Ensure DB works
if (!$conn) {
    log_debug("DB connect error: " . mysqli_connect_error());
    exit('Database connection failed.');
}

$action = $_GET['action'] ?? '';

// === LOGIN ===
if ($action === 'login') {
    $username = $_POST['username'] ?? '';
    $password = md5($_POST['password'] ?? '');

    log_debug("LOGIN - Username: $username");

    $qry = $conn->query("SELECT * FROM users WHERE username = '$username' AND password = '$password'");

    if (!$qry) {
        log_debug("Query failed: " . $conn->error);
        ob_clean(); echo '0'; flush(); exit;
    }

    if ($qry->num_rows > 0) {
        $user = $qry->fetch_array();

        if (($user['type'] == 1 || $user['type'] == 2) && !empty($user['email'])) {
            $code = rand(100000, 999999);
            $expiry = date("Y-m-d H:i:s", strtotime('+5 minutes'));

            $conn->query("UPDATE users SET twofa_code = '$code', twofa_expiry = '$expiry' WHERE id = {$user['id']}");

            $sent = @mail($user['email'], "Your 2FA Code", "Your 2FA code is: $code\n\nExpires in 5 minutes.");

            log_debug("2FA code generated: $code | Email to: {$user['email']} | Sent: " . ($sent ? "Yes" : "No"));

            $_SESSION['2fa_user_id'] = $user['id'];

            ob_clean(); echo '2FA'; flush(); exit;
        } else {
            $_SESSION['login_id'] = $user['id'];
            log_debug("Logged in without 2FA");

            ob_clean(); echo '1'; flush(); exit;
        }
    } else {
        log_debug("Login failed: invalid credentials");
        ob_clean(); echo '0'; flush(); exit;
    }
}

// === VERIFY 2FA ===
if ($action === 'verify_2fa') {
    if (!isset($_SESSION['2fa_user_id'])) {
        log_debug("2FA verify failed: session not set.");
        ob_clean(); echo '0'; flush(); exit;
    }

    $user_id = $_SESSION['2fa_user_id'];
    $code = $_POST['code'] ?? '';
    $now = date("Y-m-d H:i:s");

    $qry = $conn->query("SELECT * FROM users WHERE id = $user_id");

    if ($qry && $qry->num_rows > 0) {
        $user = $qry->fetch_array();
        log_debug("2FA checking: input=$code | db_code={$user['twofa_code']} | expiry={$user['twofa_expiry']} | now=$now");

        if ($user['twofa_code'] === $code && $now <= $user['twofa_expiry']) {
            $_SESSION['login_id'] = $user['id'];
            $_SESSION['login_name'] = $user['name'];
            $_SESSION['login_type'] = $user['type'];

            $conn->query("UPDATE users SET twofa_code = NULL, twofa_expiry = NULL WHERE id = $user_id");
            unset($_SESSION['2fa_user_id']);

            log_debug("2FA verified successfully for user ID: $user_id");
            ob_clean(); echo '1'; flush(); exit;
        } else {
            log_debug("2FA failed: wrong or expired code.");
            ob_clean(); echo '0'; flush(); exit;
        }
    } else {
        log_debug("2FA user fetch failed.");
        ob_clean(); echo '0'; flush(); exit;
    }
}

// === OTHER ACTIONS ===
if ($action == 'login2') echo $crud->login2();
if ($action == 'logout') echo $crud->logout();
if ($action == 'logout2') echo $crud->logout2();
if ($action == 'save_user') echo $crud->save_user();
if ($action == 'delete_user') echo $crud->delete_user();
if ($action == 'signup') echo $crud->signup();
if ($action == 'update_account') echo $crud->update_account();
if ($action == 'save_settings') echo $crud->save_settings();
if ($action == 'save_category') echo $crud->save_category();
if ($action == 'delete_category') echo $crud->delete_category();
if ($action == 'save_transmission') echo $crud->save_transmission();
if ($action == 'delete_transmission') echo $crud->delete_transmission();
if ($action == 'save_engine') echo $crud->save_engine();
if ($action == 'delete_engine') echo $crud->delete_engine();
if ($action == 'save_car') echo $crud->save_car();
if ($action == 'delete_car') echo $crud->delete_car();
if ($action == 'save_book') echo $crud->save_book();
if ($action == 'delete_book') echo $crud->delete_book();
if ($action == 'get_booked_details') echo $crud->get_booked_details();
if ($action == 'save_movement') echo $crud->save_movement();
if ($action == 'delete_movement') echo $crud->delete_movement();
if ($action == 'participate') echo $crud->participate();
if ($action == 'get_venue_report') echo $crud->get_venue_report();
if ($action == 'save_art_fs') echo $crud->save_art_fs();
if ($action == 'delete_art_fs') echo $crud->delete_art_fs();
if ($action == 'get_pdetails') echo $crud->get_pdetails();
