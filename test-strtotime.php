<?php
//echo "aaaaaaa->".strtotime("2017-10-10");


$LastUpdateDate = '2017-06-22';
$d1 = new DateTime($LastUpdateDate);
$d2 = new DateTime('2017-07-05');
$MonthsDiff = $d1->diff($d2)->m + ($d1->diff($d2)->y*12);

var_dump($MonthsDiff);


$datetime1 = new DateTime('2017-07-05');
$datetime2 = new DateTime('2017-06-22');
$interval = $datetime1->diff($datetime2);
var_dump($interval);
echo $interval->format('%a days');

$daysToAdd = 94;
$dueDateObj = new DateTime('2017-03-06');
$dueDateObj->add(new DateInterval('P'.$daysToAdd.'D'));
$DueDate = $dueDateObj->format('Y-m-d');
//var_dump($DueDate);
?>