<?php

$username = 'MAMDIWNDRJOTGYNDM5ZW';
$password = 'NzAzZmU2MGI3NzZiZjVjM2NhYzhjMThiNTJjZTE0';
$URL = 'https://api.plivo.com/v1/Account/MAMDIWNDRJOTGYNDM5ZW/Call';

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $URL);
curl_setopt($ch, CURLOPT_USERPWD, "$username:$password");
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
$result = curl_exec($ch);
var_dump($result);
curl_close($ch);
?>