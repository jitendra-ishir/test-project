<?php

$recordId = "361009000000213027";
$url = "https://recruit.zoho.com/recruit/private/xml/Candidates/uploadFile?authtoken=65b001cd4c2f1fbfc873efe0c13a40fc&scope=recruitapi&version=2&type=Resume";
$ch = curl_init();
$cFile = new CURLFile('C:\wamp\www\test-project\dummy.pdf', 'application/pdf', "");
curl_setopt($ch,CURLOPT_HEADER,0);
curl_setopt($ch,CURLOPT_VERBOSE,0);
curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
curl_setopt($ch,CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_POST, true);
//curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
//curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);

$post = array("id" => $recordId, "content" => $cFile);
curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
$response = curl_exec($ch);

if(curl_exec($ch) === false)
{
    echo 'Curl error: ' . curl_error($ch);
}


//echo $response;
//var_dump($ch);
var_dump($response);
?>