/*###########################################################################
Easybasket
Tim Dodgson
21st May 2011
www.easybasket.co.uk
###########################################################################*/

$(document).ready(function(){ 
		
    $(".remove-link").live('click',(function() { 
        $(this).parent().parent().remove();
    })) 
	 
	$(".add-link").live('click',(function() { 
		$('#optiontable').append('<tr><td class="left">Option</td><td class="middle"><input type="text" name="option" value="" size="30"/></td><td><img class="remove-link" src="welcome/del.png" width="24" height="24"/></td></tr>');
    })) 
})

