<?php
session_start();
include 'db_connect.php';
include 'admin_class.php';
require 'PHPMailer/Exception.php';
require 'PHPMailer/PHPMailer.php';
require 'PHPMailer/SMTP.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

$crud = new Action();
$config = include 'env.php';

function log_debug($msg) {
    file_put_contents('debug.txt', date("Y-m-d H:i:s") . " - " . $msg . "\n", FILE_APPEND);
}

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

if (!$conn) {
    log_debug("DB connect error: " . mysqli_connect_error());
    exit('Database connection failed.');
}

$action = $_GET['action'] ?? '';

if ($action === 'login') {
    $username = $_POST['username'] ?? '';
    $password = md5($_POST['password'] ?? '');

    log_debug("LOGIN - Username: $username");

    $stmt = $conn->prepare("SELECT * FROM users WHERE username = ? AND password = ?");
    $stmt->bind_param("ss", $username, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_array();
        if (($user['type'] == 1 || $user['type'] == 2) && !empty($user['email'])) {
            $code = rand(100000, 999999);
            $expiry = date("Y-m-d H:i:s", strtotime('+5 minutes'));
            $conn->query("UPDATE users SET twofa_code = '$code', twofa_expiry = '$expiry' WHERE id = {$user['id']}");

            $mail = new PHPMailer(true);
            try {
                $mail->isSMTP();
                $mail->Host = 'smtp.gmail.com';
                $mail->SMTPAuth = true;
                $mail->Username = $config['SMTP_USER'];
                $mail->Password = $config['SMTP_PASS'];
                $mail->SMTPSecure = 'tls';
                $mail->Port = 587;
                $mail->setFrom('yourgmail@gmail.com', 'HappyCars System');
                $mail->addAddress($user['email'], $user['name']);
                $mail->Subject = 'Your OTP';
                $mail->Body = "Hello {$user['name']},\n\nYour OTP is: $code\n\nThis code will expire in 5 minutes.";
                $mail->send();
                log_debug("2FA email sent to: {$user['email']}");
            } catch (Exception $e) {
                log_debug("2FA email failed: {$mail->ErrorInfo}");
            }

            $_SESSION['2fa_user_id'] = $user['id'];
            ob_clean(); echo '2FA'; flush(); exit;
        } else {
            $_SESSION['login_id'] = $user['id'];
            ob_clean(); echo '1'; flush(); exit;
        }
    } else {
        ob_clean(); echo '0'; flush(); exit;
    }
}

if ($action === 'verify_2fa') {
    if (!isset($_SESSION['2fa_user_id'])) {
        ob_clean(); echo '0'; flush(); exit;
    }

    $user_id = $_SESSION['2fa_user_id'];
    $code = $_POST['code'] ?? '';
    $now = date("Y-m-d H:i:s");

    $stmt = $conn->prepare("SELECT * FROM users WHERE id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_array();
        if ($user['twofa_code'] === $code && $now <= $user['twofa_expiry']) {
            $_SESSION['login_id'] = $user['id'];
            $_SESSION['login_name'] = $user['name'];
            $_SESSION['login_type'] = $user['type'];
            $conn->query("UPDATE users SET twofa_code = NULL, twofa_expiry = NULL WHERE id = $user_id");
            unset($_SESSION['2fa_user_id']);
            ob_clean(); echo '1'; flush(); exit;
        } else {
            ob_clean(); echo '0'; flush(); exit;
        }
    } else {
        ob_clean(); echo '0'; flush(); exit;
    }
}

if ($action == 'delete_book') {
    $id = $_POST['id'] ?? '';
    if (!is_numeric($id)) {
        echo 0; exit;
    }
    $stmt = $conn->prepare("DELETE FROM books WHERE id = ?");
    $stmt->bind_param("i", $id);
    if ($stmt->execute()) {
        echo 1;
    } else {
        echo 0;
    }
    exit;
}

if ($action === 'save_book') {
    $id = $_POST['id'] ?? '';
    $name = $_POST['name'] ?? '';
    $email = $_POST['email'] ?? '';
    $contact = $_POST['contact'] ?? '';
    $address = $_POST['address'] ?? '';
    $pickup = $_POST['pickup_datetime'] ?? '';
    $dropoff = $_POST['dropoff_datetime'] ?? '';
    $car_id = $_POST['car_id'] ?? '';
    $status = $_POST['status'] ?? 1; // Default to pending
    $valid_id_path = '';

    $upload_dir = 'admin/assets/uploads/valid_ids/';
    if (!is_dir($upload_dir)) {
        mkdir($upload_dir, 0755, true);
    }

    if (!empty($_FILES['valid_id']['tmp_name'])) {
        $filename = time() . '_' . basename($_FILES['valid_id']['name']);
        $target_file = $upload_dir . $filename;
        if (move_uploaded_file($_FILES['valid_id']['tmp_name'], $target_file)) {
            $valid_id_path = $target_file;
        }
    }

    if (!empty($id)) {
        // UPDATE booking
        $update_fields = "car_id = ?, name = ?, email = ?, contact = ?, address = ?, pickup_datetime = ?, dropoff_datetime = ?, status = ?";
        $params = [$car_id, $name, $email, $contact, $address, $pickup, $dropoff, $status];
        $types = "issssssi";

        if (!empty($valid_id_path)) {
            $update_fields .= ", valid_id_path = ?";
            $params[] = $valid_id_path;
            $types .= "s";
        }

        $stmt = $conn->prepare("UPDATE books SET $update_fields WHERE id = ?");
        $params[] = $id;
        $types .= "i";
        $stmt->bind_param($types, ...$params);
        echo $stmt->execute() ? '1' : '0';
    } else {
        // INSERT new booking
        $stmt = $conn->prepare("INSERT INTO books (car_id, name, email, contact, address, pickup_datetime, dropoff_datetime, valid_id_path, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("isssssssi", $car_id, $name, $email, $contact, $address, $pickup, $dropoff, $valid_id_path, $status);
        echo $stmt->execute() ? '1' : '0';
    }
    exit;
}


// Forward to class
$forwarded_actions = [
    'login2', 'logout', 'logout2', 'save_user', 'delete_user', 'signup',
    'update_account', 'save_settings', 'save_category', 'delete_category',
    'save_transmission', 'delete_transmission', 'save_engine', 'delete_engine',
    'save_car', 'delete_car', 'get_booked_details', 'save_movement',
    'delete_movement', 'participate', 'get_venue_report', 'save_art_fs', 'delete_art_fs', 'get_pdetails'
];

if (in_array($action, $forwarded_actions)) {
    echo $crud->$action();
}
