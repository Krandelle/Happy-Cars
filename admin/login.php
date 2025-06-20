<!DOCTYPE html>
<html lang="en">
<?php 
session_start();
include('./db_connect.php');
ob_start();
if (!isset($_SESSION['system'])) {
    $system = $conn->query("SELECT * FROM system_settings LIMIT 1")->fetch_array();
    foreach ($system as $k => $v) {
        $_SESSION['system'][$k] = $v;
    }
}
ob_end_flush();
?>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><?php echo $_SESSION['system']['name'] ?></title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
  <?php include('./header.php'); ?>
  <?php if (isset($_SESSION['login_id'])) header("Location: index.php?page=home"); ?>
  <style>
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: 'Poppins', sans-serif;
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(to top, #000428, #004e92, #007afd);
    }
    #main {
      display: flex;
      width: 90%;
      max-width: 1100px;
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 20px 50px rgba(0,0,0,0.1);
      overflow: hidden;
    }
    #login-left {
      width: 55%;
      background: url('assets/uploads/<?php echo $_SESSION['system']['cover_img'] ?>') no-repeat center;
      background-size: cover;
      position: relative;
    }
    #login-left::before {
      content: "";
      position: absolute;
      inset: 0;
      background-color: rgba(0, 0, 0, 0.4);
    }
    #login-right {
      width: 45%;
      padding: 3rem 2rem;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      z-index: 1;
      background: rgba(255,255,255,0.95);
    }
    .card {
      width: 100%;
      max-width: 400px;
      background: #ffffffaa;
      border-radius: 12px;
      padding: 2rem;
      box-shadow: 0 8px 20px rgba(0,0,0,0.1);
      backdrop-filter: blur(5px);
    }
    .card h3 {
      text-align: center;
      margin-bottom: 2rem;
      font-weight: 600;
      color: #333;
    }
    .form-group { margin-bottom: 1.5rem; }
    .form-group label {
      font-weight: 500;
      margin-bottom: 0.5rem;
      display: block;
      color: #444;
    }
    .form-control {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 15px;
      transition: 0.3s;
    }
    .form-control:focus {
      outline: none;
      border-color: #74ebd5;
      box-shadow: 0 0 0 3px rgba(116, 235, 213, 0.2);
    }
    .btn-primary {
      width: 100%;
      background: linear-gradient(to right, #0f2027, #203a43, #0000b3);
      border: none;
      color: white;
      padding: 12px;
      font-size: 16px;
      font-weight: bold;
      border-radius: 8px;
      cursor: pointer;
      transition: 0.3s;
    }
    .btn-primary:hover { opacity: 0.9; }
    .alert-danger {
      background: #f8d7da;
      color: #842029;
      padding: 10px;
      border-radius: 6px;
      font-size: 14px;
      margin-bottom: 1rem;
    }
    @media (max-width: 768px) {
      #main { flex-direction: column; width: 90%; margin-top: 1rem; }
      #login-left { width: 100%; height: 200px; }
      #login-right { width: 100%; }
    }
  </style>
</head>
<body>
  <main id="main">
    <div id="login-left"></div>
    <div id="login-right">
      <div class="card">
        <h3>Welcome Back</h3>
        <form id="login-form">
          <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" class="form-control" required>
          </div>
          <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" class="form-control" required>
          </div>
          <div class="form-group d-none" id="code-field">
            <label for="code">An OTP has been sent to your email</label>
            <input type="text" id="code" name="code" class="form-control" autocomplete="one-time-code">
          </div>
          <button type="submit" class="btn btn-primary">Login</button>
        </form>
      </div>
    </div>
  </main>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
  console.log("Login script loaded!");

  let twoFARequired = false;

  $('#login-form').on('submit', function(e){
    e.preventDefault();
    console.log("Form submitted. 2FA?", twoFARequired);
    $('.alert-danger').remove();
    $('.btn-primary').attr('disabled', true).text('Processing...');

    const formData = $(this).serialize();

    $.ajax({
      url: 'ajax.php?action=login',
      method: 'POST',
      data: formData,
      success: function(resp) {
        resp = resp.trim();
        console.log("LOGIN response:", resp);
        if (resp === '2FA') {
          $('#code-field').removeClass('d-none');
          $('#code').attr('required', true);
          $('.btn-primary').removeAttr('disabled').text('Verify');
          twoFARequired = true;
        } else if (resp === '1') {
          window.location.href = 'index.php?page=home';
        } else {
          $('#login-form').prepend('<div class="alert alert-danger">Incorrect username or password.</div>');
          $('.btn-primary').removeAttr('disabled').text('Login');
        }
      },
      error: function(err) {
        console.error("LOGIN AJAX error:", err);
        $('.btn-primary').removeAttr('disabled').text('Login');
      }
    });
  });

  // Attach a click handler for the "Verify" button when 2FA is active
  $(document).on('click', '.btn-primary', function(e) {
    if (!twoFARequired) return; // Let submit handler handle it
    e.preventDefault();

    const code = $('#code').val().trim();
    console.log("Sending 2FA code:", code);
    $('.alert-danger').remove();
    $('.btn-primary').attr('disabled', true).text('Verifying...');

    $.ajax({
      url: 'ajax.php?action=verify_2fa',
      method: 'POST',
      data: { code: code },
      success: function(resp) {
        resp = resp.trim();
        console.log("2FA response:", resp);
        if (resp === '1') {
          window.location.href = 'index.php?page=home';
        } else {
          $('#login-form').prepend('<div class="alert alert-danger">Invalid or expired OTP.</div>');
          $('.btn-primary').removeAttr('disabled').text('Verify');
        }
      },
      error: function(err) {
        console.error("2FA AJAX error:", err);
        $('.btn-primary').removeAttr('disabled').text('Verify');
      }
    });
  });
});
</script>



  </script>
</body>
</html>
