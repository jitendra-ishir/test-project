<?php
session_start();
// captcha width
$captcha_w = 150;
// captcha height
$captcha_h = 50;
// minimum font size; each operation element changes size
$min_font_size = 12;
// maximum font size
$max_font_size = 18;
// rotation angle
$angle = 20;
// background grid size
$bg_size = 13;
// path to font - needed to display the operation elements
$font_path = 'fonts/courbd.ttf';

$img = imagecreate($captcha_w, $captcha_h);
/*
  Some colors. Text is $black, background is $white, grid is $grey
 */
$black = imagecolorallocate($img, 0, 0, 0);
$white = imagecolorallocate($img, 255, 255, 255);
$grey = imagecolorallocate($img, 215, 215, 215);
/*
  make the background white
 */
imagefill($img, 0, 0, $white);
/* the background grid lines - vertical lines */
for ($t = $bg_size; $t < $captcha_w; $t+=$bg_size) {
    imageline($img, $t, 0, $t, $captcha_h, $grey);
}
/* background grid - horizontal lines */
for ($t = $bg_size; $t < $captcha_h; $t+=$bg_size) {
    imageline($img, 0, $t, $captcha_w, $t, $grey);
}

/*
  this determinates the available space for each operation element
  it's used to position each element on the image so that they don't overlap
 */
$item_space = $captcha_w / 3;
$rand = $_SESSION['security_num'];
imagettftext(
        $img, rand(
                $min_font_size, $max_font_size
        ), rand(-$angle, $angle), rand(10, $item_space - 20), rand(25, $captcha_h - 25), $black, $font_path, $rand);

/* image is .jpg */
header("Content-type:image/jpeg");
/* name is secure.jpg */
header("Content-Disposition:inline ; filename=secure.jpg");
/* output image */
imagejpeg($img);
?>