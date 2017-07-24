/*###########################################################################
Easybasket Javascript
21st May 2011
Nigel Alderton & Tim Dodgson
Dependencies: jQuery, jQueryUi
www.easybasket.co.uk
###########################################################################*/

var eBasket = new function() {

	/*##############################################
	eBasket constructor.
	##############################################*/
	
	var location = 'easybasket/';		// The location of the easybasket folder.
	var drag = '.drag';
	var drop = '.easybasket';
	var dragDrop = false;
	var showHideControl = '#showhidecontrol';
	var showHideArea = '.showhidearea';
	var showHide = false;
	var bubbletTimeout = 2000;
	var basketDelay = 3000;

	jQuery(document).ready(function() {
	
		var content = jQuery('head meta[name="easybasket"]').attr('content');
		var arr = content.split(';');
		for (i=0; i<arr.length; i++) {
			var pair = arr[i].split('=');
			switch (pair[0]) {
				case 'location' : location = pair[1] + '/'; break;
				case 'drag' : drag = pair[1]; dragDrop = true; break;
				case 'drop' : drop = pair[1]; dragDrop = true; break;
				case 'dragdrop': dragDrop = true; break;
				case 'showhidearea' : showHideArea = pair[1]; showHide = true; break;
				case 'showhidecontrol' : showHideControl = pair[1]; showHide = true; break;
				case 'showhide' : showHide = true; break;
				case 'bubbletimeout' : bubbleTimeout = pair[1]; break;
				case 'basketdelay' : basketDelay = pair[1]; break;
			}
		}
		bindForms();
		getBaskets();
		if (dragDrop) {initDragDrop()};
		if (showHide) {bindShowHide()};
	});
	
	
	/*##############################################
	Bind the showhide buttons function
	##############################################*/
	function bindShowHide() { 
		
		jQuery(showHideControl).live({
			mouseover: function() {
				jQuery(this).css('cursor', 'hand');
			}
		});
		
		jQuery(showHideControl).live('click',(function(){
			jQuery(showHideArea).slideToggle(100);
			jQuery(showHideControl).text(jQuery(showHideControl).text() == 'Show' ? 'Hide' : 'Show');
		}));
		
	}
	
	/*##############################################
	Init Draggable and Droppable
	##############################################*/
	function initDragDrop() {
	
		var formdata;
		var flg = "?basket=add"
		jQuery(drag).css('cursor', 'move');
		
		// Draggable.
		jQuery(drag).draggable({
			containment: 'document',
			opacity: 0.6,
			revert: 'invalid',
			helper: 'clone',
			start: function(event, ui) { 
				formdata = jQuery(this).find('form.easybasket').serialize();
			}
		});
		  
		//Droppable.
		jQuery(drop).not("form").droppable({ 
			drop: function(event, ui) { 
				jQuery.post(location + '?basket=add', formdata, function(response) {
					getBaskets(flg);		
				});
			} 
		});
	}
	
	/*##############################################
	Fetch all the baskets.
	##############################################*/
	function getBaskets(s) {
	
		jQuery('body .easybasket').not('form').each(function(index) {
			
			var myThis = this;
			var attr = $(this).attr('data-url');
			var url = location + '?' + attr;

			$.get(url, function(response) {
				jQuery(myThis).html(response);
				if(showHide){
					if (!(s)) {
						jQuery(showHideArea).hide();
					} else {
						if (s.indexOf('add') != -1) {
							jQuery(showHideArea).show();
							jQuery(showHideControl).text("Hide");
							setTimeout(function() {
								jQuery(showHideArea).hide(); 
								jQuery(showHideControl).text("Show");
							},basketDelay);
						} else {
							jQuery(showHideControl).text("Hide");
						}
					}
				}
				// Prepend the Easybasket location to all checkout forms action attribute.
				jQuery.each(
					jQuery(myThis).find('form').not('.easybasket'), function(i, val) {
						jQuery(this).attr('action', location + jQuery(this).attr('action'));
				});
			});
			
		});
			
	}

	/*##############################################
	Bind a submit event to all the Easybasket forms.
	##############################################*/
	function bindForms() {
	
		jQuery('form.easybasket').live('submit', function() {

			var attr = jQuery(this).attr("action");			// Get the form action attribute.
			var url = location + attr;
			var fields = jQuery(this).serialize();			// Serialize the form.
			
			if(showHide){ 
				var flg = jQuery(this).attr('action');
			}
			
			// Bubble.
			var bubble = jQuery(this).attr('data-bubble');
			if (bubble) {
				jQuery(this).prepend('<div class="bubble">' + bubble + '</div>');
				setTimeout(function() {
					jQuery('form.easybasket .bubble').remove();
				},bubbletTimeout);
			}

			jQuery.post(url, fields, function(response) {
				$('#report').html(response);
				getBaskets(flg);							// Refresh baskets.
			});
			
			return false;
		
		});
	}
	
}