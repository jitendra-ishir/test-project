<?php
error_reporting(0);
$password = "123abc789d";



/*###########################################################################
Easybasket RESTful API
Nigel Alderton
21st May 2011
www.easybasket.co.uk
#############################################################################

This file exposes a RESTful HTTP interface to the client. It supports the following functionality;

HTTP Method: GET	Example				Response
=================	===============		==================================================================
					/					The Welcome page HTML.
skin=<str>			/?skin=test.xsl		The basket rendered as HTML using the specified skin file.
debug=<str>			/?debug=basic		The basket as raw XML instead of rendered using a skin. (basic | advanced)
											(This setting overrides the skin=<str> field.)

HTTP Method: POST	Action
=================	==============
basket=add			Add an item to the basket. Increase the item quantity by either 1 or the value of the form quantity field if present.
basket=remove		Remove an item from the basket.
basket=increase		Increase the quantity of an item in the basket by 1.
basket=decrease		Decrease the quantity of an item in the basket by 1.
basket=reset		Empty the basket. Remove all items from the basket.
checkout=paypal		Invoke the Paypal checkout.
checkout=google		Invoke the Google checkout.
system=login		Login
system=logout		Logout
system=save			Save settings.

*/

session_start();

define('PASSWORD', 'foo');			// User login password.
define('PASS_SESS', 'pass');		// The name of the session variable used to persist the password.
define('SETTINGS', 'settings.php');	// The settings filename.
define('NEW_SETTINGS', 'new.xsl');	// The stylesheet that builds a new settings XML.
define('WELCOME', 'welcome.xsl');	// The Welcome pages stylesheet.
define('BASKET', 'basket');			// The name of the session variable used to persist the basket.
define('CORE', 'core.xsl');			// The Easybasket core processor - used when editing the basket.
define('PAYPAL', 'paypal.xsl');		// The stylesheet that generates the URL for the PayPal checkout.
define('GOOGLE', 'google.xsl');		// The stylesheet that generates the XML for the Google checkout.
define('LOGS_DIR', 'logs'.DIRECTORY_SEPARATOR);			// The logs directory.
define('WELCOME_DIR', 'welcome'.DIRECTORY_SEPARATOR);	// The welcome directory.
define('SKINS', 'skins'.DIRECTORY_SEPARATOR);			// The skins directory.
define('DEBUG_MSG', 'You must be logged in to see advanced debug information.');

define('LOG_PERIOD', 3);									// 1=daily, 2=weekly, 3=monthly, 4=yearly, 0=continuous.
define('ERR_FILE', 'ipn-failed.xml');						// The file containing transactions that failed IPN verification.
define('FILENAME_PREFIX', 'eb-');							// This prefix is prepended to all the filenames except the ERR_FILE.

$file_list ='';
$file_contents = '';

validate_basket();		// Create a new empty basket if necessary.

$GLOBALS['pwd'] = new password(PASS_SESS, PASSWORD);	// The password class persists user login state.
$GLOBALS['BASKET'] = simplexml_load_string($_SESSION[BASKET]);	// The basket as a simpleXML object.

if(!isset($_SESSION['pwdx'])){
    if (isset($_GET["password"]) && ($_GET["password"]=="$password")) {
        $_SESSION['pwdx'] = $_GET["password"];
    }
}
if (isset($_SESSION['pwdx'])) {
    // Invoke the appropriate handler: GET or POST.
    switch ($_SERVER['REQUEST_METHOD']) {
            case 'GET' : handle_get(); break;
            case 'POST' : handle_post(); break;
    }
}
else
{
// Wrong password or no password entered display this message
if (isset($_GET['password']) || $password == "") {
  echo "<p align=\"center\"><font color=\"red\"><b>Incorrect Password</b><br>Please enter the correct password</font></p>";}
  echo "<form method=\"get\"><p align=\"center\">Please enter your password for access<br>";
  echo "<input name=\"password\" type=\"password\" size=\"25\" maxlength=\"10\"><input value=\"Login\" type=\"submit\"></p></form>";
}

// Handle an HTTP GET request.
function handle_get() {

	switch (TRUE) {
	
		// Return the basket as HTML - rendered using the specified skin.
		case isset($_GET['skin']) :
			echo transform($GLOBALS['BASKET']->items->asXML(), SKINS.$_GET['skin'], new XSLTProcessor());
			break;
		
		// Return the debug information as XML.
		case isset($_GET['debug']) :
			if ($_GET['debug']=='basic') $xml = pretty($GLOBALS['BASKET']->items->asXML());
			if ($_GET['debug']=='advanced')
				$xml = $GLOBALS['pwd']->isAuthentic() ? $_SESSION[BASKET] : DEBUG_MSG;
			echo str_replace('<', '&lt;', str_replace('&', '&amp;', $xml));
			break;
		
		// Return the Welcome pages as HTML.
		default :
			switch ($page = isset($_GET['page']) ? $_GET['page'] : 'welcome') {
				case 'welcome' : $xml = '<welcome/>'; break;		
				case 'settings' : $xml = get_file(SETTINGS); break;
				case 'logs' : $xml = get_logs(); break;
				case 'host' : $xml = get_host(); break;
			}
			$proc = new XSLTProcessor();
			$proc->setParameter('', 'auth', $GLOBALS['pwd']->isAuthentic());
			$proc->setParameter('', 'auth-fail', $GLOBALS['pwd']->isFail());
			if (!$GLOBALS['pwd']->isAuthentic()) $GLOBALS['pwd']->clear();
			echo transform("<root>$xml</root>", WELCOME_DIR.WELCOME, $proc);
	}
}


// Handle an HTTP POST request.
function handle_post() {

	switch (TRUE) {

		// Handle actions that modify the basket; add, remove, increase, decrease, reset.
		case (isset($_GET['basket'])) :
			$proc = new XSLTProcessor();
			$proc->setParameter('', 'timestamp', date('c'));
			$proc->setParameter('', 'http_query', $_SERVER["QUERY_STRING"]);
			$proc->setParameter('', 'http_form', urldecode(file_get_contents("php://input")));
			$proc->setParameter('', 'settings', str_replace('\\', '/', realpath(SETTINGS)));
			$_SESSION[BASKET] = transform($_SESSION[BASKET], CORE, $proc);
			break;
			
		// Handle system actions; system=save, system=login, system=logout.
		case (isset($_GET['system'])) :
			if ($_GET['system'] == 'save') handle_save(); 
			if ($_GET['system'] == 'login') $GLOBALS['pwd']->save($_POST['password']);
			if ($_GET['system'] == 'logout') $GLOBALS['pwd']->clear();
			$redirect = isset($_GET['page']) ? '?page='.$_GET['page'] : '.';
			header("Location: $redirect");
			break;
			
		// Handle the 'checkout' actions; checkout=google, checkout=paypal.
		case (isset($_GET['checkout'])) :
			handle_checkout($_GET['checkout']);
			break;
			
		// Handle Paypal IPN
		default :
			handle_ipn();
	}
}


// Save a new settings file.
function handle_save() {
	if (!$GLOBALS['pwd']->isAuthentic()) die(DEBUG_MSG);
	$proc = new XSLTProcessor();
	$proc->setParameter('', 'timestamp', date('c'));
	$proc->setParameter('', 'http_form', urldecode(file_get_contents("php://input")));
	$xml = transform(get_file(SETTINGS), NEW_SETTINGS, $proc);
	$x = "<?php die('No') ?>";
	$flg = file_put_contents(SETTINGS, $x.$xml);
}


// Handle the PayPal and Google checkouts.
function handle_checkout($strCheckout) {

	switch ($strCheckout) {
	
		case "paypal" :
			$xml = transform($_SESSION[BASKET], PAYPAL, new XSLTProcessor());
			$element = new simpleXMLElement($xml);
			header("Location: ".$element->concat);
			break;
		
		case "google" :
			$xml = transform($_SESSION[BASKET], GOOGLE, new XSLTProcessor());
			$element = new simpleXMLElement($xml);
			$googlexml = $element->{'checkout-shopping-cart'}->asXML();
			$url = $element->host;
			$response = google_checkout($url, $googlexml, $element->{'merchant-id'}, $element->{'merchant-key'});
			
			$element = new simpleXMLElement($response);
			header("Location: ".$element->children());
			break;
	}
}


// ================================================================================
// Google Checkout server-to-server call.
// ================================================================================
function google_checkout($url, $xml, $id, $key) {
	
	$headers = array();
	$headers[] = "Authorization: Basic ".base64_encode($id.':'.$key);
	$headers[] = "Content-Type: application/xml; charset=UTF-8";
	$headers[] = "Accept: application/xml; charset=UTF-8";

	$session = curl_init($url);
	  
	curl_setopt($session, CURLOPT_POST, true);
	curl_setopt($session, CURLOPT_HTTPHEADER, $headers);
	curl_setopt($session, CURLOPT_POSTFIELDS, $xml);
	curl_setopt($session, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($session, CURLOPT_SSL_VERIFYPEER, false);
	
	$response = curl_exec($session);
	curl_close($session);
      
	return $response;
}


// Create the XML for the "Logs" page.
function get_logs() {
	$files = get_file_list(LOGS_DIR);
	$filename = isset($_GET['file']) ? $_GET['file'] : '';
	$log = isset($_GET['file']) ? get_file(LOGS_DIR.$_GET['file']) : '';
	return "<logs><files>$files</files><log filename='$filename'>$log</log></logs>";
}


// Create the XML for the "Host Info" page.
function get_host() {
	
	$good = "pass";
	$bad = "fail";

	// PHP.
	$phpRequired = "5.2.8";
	$phpRunning = PHP_VERSION;
	$phpStatus = version_compare(PHP_VERSION, $phpRequired) < 0 ? $bad : $good;

	// LIBXML
	$libxmlRequired = "2.6.32";
	$libxmlRunning = defined('LIBXML_DOTTED_VERSION') ? LIBXML_DOTTED_VERSION : "-";
	$libxmlStatus = version_compare($libxmlRunning, $libxmlRequired) < 0 ? $bad : $good;

	// LIBCURL.
	$libcurlRequired = "7.16.0";
	$libcurl = (function_exists("curl_version")) ? curl_version() : false;
	$libcurlRunning = ($libcurl) ? $libcurl["version"] : "-";
	$libcurlStatus = version_compare($libcurlRunning, $libcurlRequired) < 0 ? $bad : $good;
	
	return "
		<host>
			<php running='$phpRunning' required='$phpRequired' status='$phpStatus'/>
			<libxml running='$libxmlRunning' required='$libxmlRequired' status='$libxmlStatus'/>
			<libcurl running='$libcurlRunning' required='$libcurlRequired' status='$libcurlStatus'/>
		</host>";
}


// Create an XML sequence of the *.xml files in the specified directory, Eg.;
//		<file>foo.xml</file><file>bar.xml</file>
function get_file_list($dir) {

	if ($handle = opendir($dir)) {
		$files = '';
		while (false !== ($file = readdir($handle))) {
			if ($file != "." && $file != ".." && substr($file, -4) == '.xml') {
				$files .= "<file>$file</file>";
			}
		}
		closedir($handle);
		return $files;
	}
}


// Create a new empty basket if necessary.
function validate_basket() {

	// Determine whether the session variable contains a valid basket.
	if (isset($_SESSION[BASKET])) {
		$doc = new DOMDocument();
		if ($doc->loadXML($_SESSION[BASKET])) {
			if ($doc->documentElement->nodeName == 'basket') {
				$flgBasketValid = TRUE;	
			}
		}
	}

	// If necessary, create an empty basket.
	if (!isset($flgBasketValid)) {
		$proc = new XSLTProcessor();
		$proc->setParameter('', 'http_query', 'reset=yes');
		$proc->setParameter('', 'timestamp', date('c'));
		$proc->setParameter('', 'settings', str_replace('\\', '/', realpath(SETTINGS)));
		$_SESSION[BASKET] = transform('<basket/>', CORE, $proc);
	}
}


// Apply a transform file to an XML document.
function transform($strXml, $filename, &$proc) {

	// Create the input document.
	$input = new DOMDocument();
	$input->loadXML($strXml);

	// Create the transform document.
	$trans = new DOMDocument();
	$t = file_get_contents($filename) or die('cwd='.getcwd());
	$trans->loadXML($t);

	$proc->importStylesheet($trans);
	$strResult = $proc->transformToXML($input);

	// Pretty-print.
	return pretty($strResult);
}


// Load a text file, or Die if it doesn't exist.
function get_file($file) {
	$t = file_get_contents($file) or die('cwd='.getcwd());
	return $t;
}


// Pretty print.
// Return an xml string as a pretty xml string, without the xml declaration.
function pretty($strXml) {
	$pretty = new DOMDocument();
	$pretty->preserveWhiteSpace = false;
	$pretty->formatOutput = true;
	$pretty->loadXML($strXml);
	return $pretty->saveXML($pretty->documentElement);
}


/*================================================================================
Handle an HTTP IPN POST request.
Verfify the IPN and append it to the appropriate log file.
================================================================================*/
function handle_ipn() {
	foreach ($_POST as $key => $value) {
		$xml .= "    <$key>$value</$key>".PHP_EOL;
	}
	$status = verify();				// The verification status: VERIFIED | INVALID | HTTP_ERROR | UNKNWOWN
	$timestamp = date('c');			// ISO-8601 date format eg. 2004-02-12T15:19:21+00:00
	$filename = ($status == 'VERIFIED') ? get_log_filename(LOG_PERIOD) : ERR_FILE;
	$str = "  <ipn status='$status' timestamp='$timestamp'>".PHP_EOL.$xml."  </ipn>".PHP_EOL;
	append(LOGS_DIR.FILENAME_PREFIX.$filename, $str);
}

/*================================================================================
Append a string to a file.
If the file doesn't exist, create it.
================================================================================*/
function append($filename, $str) {
	$fp = fopen($filename, 'a');
	fwrite($fp, $str);
	fclose($fp);
}

/* ================================================================================
Return the filename of the log file.
	$param1	<int>:	The format of the filename; 1=daily, 2=weekly, 3=monthly, 4=yearly, 0=continuous.
================================================================================ */
function get_log_filename($period) {
	switch ($period) {
		case 1 : $str = date('Y-m-d'); break;				// Daily eg. 2011-05-09
		case 2 : $str = date('Y-').'wk'.date('W'); break;	// Weekly eg. 2011-week05
		case 3 : $str = date('Y-m'); break;					// Monthly eg. 2011-month03
		case 4 : $str = date('Y'); break;					// Yearly eg. 2011
		default : $str = 'ok';
	}
	return "$str.xml";
}

/*================================================================================
Verify a PayPal IPN.
Returns	<str>:	The verification status: VERIFIED | INVALID | HTTP_ERROR | UNKNWOWN
================================================================================*/
function verify() {

	$req = 'cmd=_notify-validate';

	foreach ($_POST as $key => $value) {
		$value = urlencode(stripslashes($value));
		$req .= "&$key=$value";
	}

	$header .= "POST /cgi-bin/webscr HTTP/1.0\r\n";
	$header .= "Content-Type: application/x-www-form-urlencoded\r\n";
	$header .= "Content-Length: " . strlen($req) . "\r\n\r\n";

	$retval = "UNKNOWN";
	$fp = fsockopen ('ssl://www.paypal.com', 443, $errno, $errstr, 30);

	if (!$fp) {
		$retval = "HTTP_ERROR";
	} else {
		fputs ($fp, $header . $req);
		while (!feof($fp)) {
			$res = fgets ($fp, 1024);
			if (strcmp ($res, "VERIFIED") == 0) {
				$retval = "VERIFIED";
			} else if (strcmp ($res, "INVALID") == 0) {
				$retval = "INVALID";
			}
		}
		fclose ($fp);
	}
	return $retval;
}


/*================================================================================
Class: password
The password class persists state for user authentication, ie. whether the user is
logged in or not. It is also used to determine whether a login attempt has just failed.
================================================================================*/
class password {

	private $session;
	private $password;
	
	public function __construct($session, $password) {
		$this->session = $session;
		$this->password = $password;
	}
	
	public function save($password) {
		$_SESSION[$this->session] = $password;
	}
	
	public function isAuthentic() {
		if (isset($_SESSION[$this->session])) {
			return ($_SESSION[$this->session] == $this->password);
		}
	}

	public function isFail() {
		if (isset($_SESSION[$this->session])) {
			return ($_SESSION[$this->session] !== $this->password);
		}
	}
	
	public function clear() {
		unset($_SESSION[$this->session]);
	}
}
?>