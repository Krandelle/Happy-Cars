<?php
Class Action {

    private $db;

    public function __construct(){
        ob_start();
        include 'db_connect.php';
        $this->db = $conn;
    }

    function login2(){
        extract($_POST);
        $password = md5($password);
        $qry = $this->db->query("SELECT * FROM users WHERE username = '$username' and password = '$password'");
        if($qry->num_rows > 0){
            $row = $qry->fetch_array();
            foreach($row as $key => $value){
                if(!is_numeric($key))
                    $_SESSION[$key] = $value;
            }
            return 1;
        } else {
            return 3;
        }
    }

    function logout(){
        session_start();
        session_destroy();
        header("location:login.php");
    }

    function logout2(){
        session_start();
        session_destroy();
        header("location:../index.php");
    }

    function save_user(){
        extract($_POST);
        $data = " name = '$name' ";
        $data .= ", username = '$username' ";
        if(!empty($password))
            $data .= ", password = md5('$password') ";
        $data .= ", type = '$type' ";
        $data .= ", email = '$email' ";

        if(empty($id)){
            $chk = $this->db->query("SELECT * FROM users WHERE username = '$username'")->num_rows;
            if($chk > 0){
                return 2;
            }
            $save = $this->db->query("INSERT INTO users set $data");
        } else {
            $chk = $this->db->query("SELECT * FROM users WHERE username = '$username' and id != $id ")->num_rows;
            if($chk > 0){
                return 2;
            }
            $save = $this->db->query("UPDATE users set $data where id = $id");
        }
        if($save)
            return 1;
    }

    function delete_user(){
        extract($_POST);
        $delete = $this->db->query("DELETE FROM users where id = $id");
        if($delete)
            return 1;
    }

    function signup(){
        extract($_POST);
        $data = " name = '$name' ";
        $data .= ", username = '$username' ";
        $data .= ", password = md5('$password') ";
        $data .= ", type = 3 ";
        $chk = $this->db->query("SELECT * FROM users WHERE username = '$username'")->num_rows;
        if($chk > 0){
            return 2;
        }
        $save = $this->db->query("INSERT INTO users set $data");
        if($save)
            return 1;
    }

    function update_account(){
        extract($_POST);
        $data = " name = '$name' ";
        $data .= ", username = '$username' ";
        if(!empty($password))
            $data .= ", password = md5('$password') ";

        $chk = $this->db->query("SELECT * FROM users WHERE username = '$username' and id != {$_SESSION['login_id']}")->num_rows;
        if($chk > 0){
            return 2;
        }
        $save = $this->db->query("UPDATE users set $data where id = {$_SESSION['login_id']}");
        if($save)
            return 1;
    }

    function save_settings(){
        extract($_POST);
        $data = " name = '$name' ";
        $data .= ", email = '$email' ";
        if(isset($_FILES['cover_img']) && $_FILES['cover_img']['tmp_name'] != ''){
            $fname = strtotime(date('y-m-d H:i')) . '_' . $_FILES['cover_img']['name'];
            $move = move_uploaded_file($_FILES['cover_img']['tmp_name'], 'assets/uploads/' . $fname);
            if($move){
                $data .= ", cover_img = '$fname' ";
            }
        }

        $chk = $this->db->query("SELECT * FROM system_settings");
        if($chk->num_rows > 0){
            $save = $this->db->query("UPDATE system_settings set $data");
        } else {
            $save = $this->db->query("INSERT INTO system_settings set $data");
        }

        if($save){
            $query = $this->db->query("SELECT * FROM system_settings limit 1")->fetch_array();
            foreach($query as $key => $value){
                if(!is_numeric($key))
                    $_SESSION['system'][$key] = $value;
            }
            return 1;
        }
    }
}
?>
