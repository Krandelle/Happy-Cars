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
        $stmt = $this->db->prepare("SELECT * FROM users WHERE username = ? and password = ?");
        $stmt->bind_param("ss", $username, $password);
        $stmt->execute();
        $result = $stmt->get_result();
        if($result->num_rows > 0){
            $row = $result->fetch_array();
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
        $data = " name = '$name', username = '$username', type = '$type', email = '$email' ";
        if(!empty($password)) $data .= ", password = md5('$password') ";

        if(empty($id)){
            $chk = $this->db->query("SELECT * FROM users WHERE username = '$username'")->num_rows;
            if($chk > 0){ return 2; }
            $save = $this->db->query("INSERT INTO users SET $data");
        } else {
            $chk = $this->db->query("SELECT * FROM users WHERE username = '$username' AND id != $id")->num_rows;
            if($chk > 0){ return 2; }
            $save = $this->db->query("UPDATE users SET $data WHERE id = $id");
        }
        return $save ? 1 : 0;
    }

    function delete_user(){
        extract($_POST);
        return $this->db->query("DELETE FROM users WHERE id = $id") ? 1 : 0;
    }

    function signup(){
        extract($_POST);
        $chk = $this->db->query("SELECT * FROM users WHERE username = '$username'")->num_rows;
        if($chk > 0){ return 2; }
        return $this->db->query("INSERT INTO users SET name = '$name', username = '$username', password = md5('$password'), type = 3") ? 1 : 0;
    }

    function update_account(){
        extract($_POST);
        $data = " name = '$name', username = '$username' ";
        if(!empty($password)) $data .= ", password = md5('$password') ";

        $chk = $this->db->query("SELECT * FROM users WHERE username = '$username' AND id != {$_SESSION['login_id']}")->num_rows;
        if($chk > 0){ return 2; }

        return $this->db->query("UPDATE users SET $data WHERE id = {$_SESSION['login_id']}") ? 1 : 0;
    }

    function save_settings(){
        extract($_POST);
        $data = " name = '$name', email = '$email' ";

        if(isset($_FILES['cover_img']) && $_FILES['cover_img']['tmp_name'] != ''){
            $fname = strtotime(date('Y-m-d H:i')) . '_' . $_FILES['cover_img']['name'];
            $move = move_uploaded_file($_FILES['cover_img']['tmp_name'], 'assets/uploads/' . $fname);
            if($move){ $data .= ", cover_img = '$fname' "; }
        }

        $chk = $this->db->query("SELECT * FROM system_settings");
        if($chk->num_rows > 0){
            $save = $this->db->query("UPDATE system_settings SET $data");
        } else {
            $save = $this->db->query("INSERT INTO system_settings SET $data");
        }

        if($save){
            $query = $this->db->query("SELECT * FROM system_settings LIMIT 1")->fetch_array();
            foreach($query as $key => $value){
                if(!is_numeric($key))
                    $_SESSION['system'][$key] = $value;
            }
            return 1;
        }
        return 0;
    }

    function save_category(){
        extract($_POST);
        $data = " name = '$name' ";
        if(empty($id)){
            $save = $this->db->query("INSERT INTO categories SET $data");
        } else {
            $save = $this->db->query("UPDATE categories SET $data WHERE id = $id");
        }
        return $save ? 1 : 0;
    }

    function delete_category(){
        extract($_POST);
        return $this->db->query("DELETE FROM categories WHERE id = $id") ? 1 : 0;
    }

    function save_transmission(){
        extract($_POST);
        $data = " name = '$name' ";
        if(empty($id)){
            $save = $this->db->query("INSERT INTO transmission_types SET $data");
        } else {
            $save = $this->db->query("UPDATE transmission_types SET $data WHERE id = $id");
        }
        return $save ? 1 : 0;
    }

    function delete_transmission(){
        extract($_POST);
        return $this->db->query("DELETE FROM transmission_types WHERE id = $id") ? 1 : 0;
    }

    function save_engine(){
        extract($_POST);
        $data = " name = '$name' ";
        if(empty($id)){
            $save = $this->db->query("INSERT INTO engine_types SET $data");
        } else {
            $save = $this->db->query("UPDATE engine_types SET $data WHERE id = $id");
        }
        return $save ? 1 : 0;
    }

    function delete_engine(){
        extract($_POST);
        return $this->db->query("DELETE FROM engine_types WHERE id = $id") ? 1 : 0;
    }

    function save_car(){
        extract($_POST);
        $data = " category_id = '$category_id', brand = '$brand', model = '$model', transmission_id = '$transmission_id', engine_id = '$engine_id' ";
        if(empty($id)){
            $save = $this->db->query("INSERT INTO cars SET $data");
        } else {
            $save = $this->db->query("UPDATE cars SET $data WHERE id = $id");
        }
        return $save ? 1 : 0;
    }

    function delete_car(){
        extract($_POST);
        return $this->db->query("DELETE FROM cars WHERE id = $id") ? 1 : 0;
    }

    function save_movement(){
        extract($_POST);
        $data = " booked_id = '$book_id', car_id = '$car_id', car_registration_no = '$car_registration_no', car_plate_no = '$car_plate_no' ";
        if(isset($status)){
            $data .= ", status = '$status' ";
        }
        if(empty($id)){
            $save = $this->db->query("INSERT INTO borrowed_cars SET $data");
        } else {
            $save = $this->db->query("UPDATE borrowed_cars SET $data WHERE id = $id");
        }
        return $save ? 1 : 0;
    }

    function delete_movement(){
        extract($_POST);
        return $this->db->query("DELETE FROM borrowed_cars WHERE id = $id") ? 1 : 0;
    }

    function get_booked_details(){
        extract($_POST);
        $qry = $this->db->query("SELECT b.*, c.brand, c.model FROM books b INNER JOIN cars c ON b.car_id = c.id WHERE b.id = $id");
        if($qry->num_rows > 0){
            echo json_encode($qry->fetch_assoc());
        } else {
            echo json_encode([]);
        }
    }
}
