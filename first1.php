<?php
session_start();
$rand = rand();
echo "rand-->".$rand;
$_SESSION['security_number'] = $rand;
print_r($_SESSION);
?>
<a href="second.php">Next</a>