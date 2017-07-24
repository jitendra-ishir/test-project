<?php
session_start();
$rand = rand(1000, 9999);
//$rand = session_id();
$_SESSION['security_num'] = $rand;
?>