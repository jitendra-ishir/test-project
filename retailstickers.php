<?php error_reporting(0); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Retail Pricing</title>
</head>
<body>
Retail Pricing
<?php 

// Pointers for size tiers in square feet
$tier1 = 10;
$tier2 = 14;
$tier3 = 19;
$tier4 = 24;
$tier5 = 29;
$tier6 = 34;
$tier7 = 39;
$tier8 = 45;
$tier9 = 50;
$tier10 = 63;
$tier11 = 75;
$tier12 = 83;
$tier13 = 100;
$tier14 = 101;

//Pointers for price tears
$p_tier1 = 7.00;
$p_tier2 = 6.30;
$p_tier3 = 5.60;
$p_tier4 = 5.10;
$p_tier5 = 4.55;
$p_tier6 = 4.03;
$p_tier7 = 3.50;
$p_tier8 = 3.32;
$p_tier9 = 3.15;
$p_tier10 = 3.02;
$p_tier11 = 2.80;
$p_tier12 = 2.63;
$p_tier13 = 2.45;
$p_tier14 = 2.10;

if(isset($_POST['submit'])) //Set the price
{
	extract($_POST);
	if(is_numeric($height)) //Make sure all form values are numeric
	{ 
		if(is_numeric($width))
		{
			if(is_numeric($quantity))
			{
				$dimensions = $height * $width;
				$area = $dimensions * $quantity; 
				$square_foot = number_format($area/144, 2, '.', ','); //Calculate total surface area of all stickers
				
				
			
				if($square_foot <= $tier1)		 
					$price = $p_tier1;
				elseif($square_foot <= $tier2)
					$price = $p_tier2;
				elseif($square_foot <= $tier3)
					$price = $p_tier3;
				elseif($square_foot <= $tier4)
					$price = $p_tier4;
				elseif($square_foot <= $tier5)
					$price = $p_tier5;
				elseif($square_foot <= $tier6)
					$price = $p_tier6;
				elseif($square_foot <= $tier7)
					$price = $p_tier7;
				elseif($square_foot <= $tier8)
					$price = $p_tier8;
				elseif($square_foot <= $tier9)
					$price = $p_tier9;
				elseif($square_foot <= $tier10)
					$price = $p_tier10;
				elseif($square_foot <= $tier11)
					$price = $p_tier11;
				elseif($square_foot <= $tier12)
					$price = $p_tier12;
				elseif($square_foot <= $tier13)
					$price = $p_tier13;
				else $price = $p_tier14; 
				
				
				
				$total_cost = $price * $square_foot;
				$pricepersticker = number_format($total_cost/$quantity, 2, '.', ',');
			} 
		}
	}
}
	


function defaultfill($form){
	if(isset($form))
		echo "value=\"" . $form . "\"";
	else echo "";
}



?>



<table width="100%" border="1">
  <tr>
    <td>Height</td>
    <td>Width</td>
    <td>Quantity </td>
    <td>Submit</td>
  </tr>
  <tr>
    <td><form id="form1" name="form1" method="post" action="">
      <label>
        <input type="text" name="height" id="height" <?php defaultfill($height)?> />
      </label>
    </td>
    <td>
      <label>
        <input type="text" name="width" id="width" <?php defaultfill($width)?>/>
      </label>
    </td>
    <td>
      <label>
        <input type="text" name="quantity" id="quantity" <?php defaultfill($quantity)?>/>
      </label>
    </td>
    <td>
        <input type='hidden' name='submit' />
        <input type="submit" name="submit" id="submit" value="Submit" />
      </form>
    </td>
  </tr>
</table>
<table width="100%" border="1">
  <tr>
    <td>Total Square Feet:</td>
    <td><?php echo $square_foot ?></td>
  </tr>
  <tr>
    <td>Price Per Square Foot:</td>
    <td><?php echo "$" . $price ?></td>
  </tr>
  <tr>
    <td>Price Per Sticker: </td>
    <td><?php echo "$" . $pricepersticker ?></td>
  </tr>
  <tr>
    <td>Total Cost:</td>
    <td><?php echo "$" . $total_cost?></td>
  </tr>
</table>
</body>
</html>