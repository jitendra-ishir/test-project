<?xml version="1.0"?>

<!--
###########################################################################
Easybasket Core XSLT
Tim dodgson & Nigel Alderton
22nd May 2011
www.easybasket.co.uk
###########################################################################
-->

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="exsl">

	<xsl:output version="1.0"
	  method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

<!--###########################################
	EXTERNAL PARAMETERS
	###########################################-->

	<xsl:param name="auth"/>
	<xsl:param name="auth-fail"/>
	
<!--###########################################
	CONSTANTS
	###########################################-->
	
	<xsl:variable name="folder" select="'welcome/'"/>
	
	
<!--###########################################
	ROOT TEMPLATE
	###########################################-->
	
	<xsl:template match="root">
		<html>
			<head>
				<meta name="easybasket" content="location=.;dragdrop=yes;showhide=yes"/>

				<link rel="stylesheet" href="{$folder}welcome.css" type="text/css"/>
				<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.0/jquery.js"></script>
				<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js"></script>
				<script type="text/javascript" src="easybasket.js"></script>
				<script type="text/javascript" src="{$folder}welcome.js"></script>
			</head>
			<body>
				<div id="outerWrapper">
				<a href="?page=settings">Settings</a><span> | </span>
								<xsl:apply-templates/>
				</div>
			</body>
		</html>
	</xsl:template>

	
<!--###########################################
	LOGIN
	###########################################	-->
	
	<xsl:template name="login">
		<form method="post" action="?page={local-name()}&amp;system=login">
			<fieldset>
				<legend>Password</legend>
				<input type="password" name="password"/>
			</fieldset>
			<input type="submit" class="submit" value="Log In"/>
		</form>
		<xsl:if test="$auth-fail">
			<h3 class="fail">Password incorrect</h3>
		</xsl:if>
	</xsl:template>

	
<!--###########################################
	LOGOUT
	###########################################	-->
	
	<xsl:template name="logout">
		<form method="post" action="?page={local-name()}&amp;system=logout">
			<input type="submit" class="submit" value="Log Out"/>
		</form>
	</xsl:template>

	
<!--###########################################
	DEMONSTRATION
	###########################################-->
	
	<xsl:template match="welcome">
		
<head>
<style type="text/css">
.style1 {
	font-size: 12px;
}
.style2 {
	font-family: serif;
}
</style>
</head>

<h1><span class="logo">Wood King</span> Products</h1>
		
		<div style="margin:30px auto 50px auto; width:980px; border:solid 1px #ccc; padding:30px; background:#efefef; height:500px">
			<div class="drag" style="float:left;margin-right:1em;"> 
				<form style="background:#fff;border:1px solid #ccc;padding:1em;width:226px;margin:0;" class="easybasket" method="post" action="?basket=add" data-bubble="Added to Basket">   
					<table style="width: 222px"> 
						<tr>
							<td style="color:#2D4262 ; font-weight:bold; font-size:14px">Dark Walnut<br><img alt="" src="http://www.woodking.net/image/cache/catalog/dark-walnutfw-126x175.fw-126x168.png" width="126" height="168" style="float: left" /></br>
							</td>
						</tr>
						<tr>
							<td style="font-size:12px; width: 226px;"><br>A Walnut Additive for any type Wood Floor Sealer. Add a small amount for a light tone. Add a large amount for a heavy walnut tone.

Highly Concentrated Makes over 8 gallons of sealer</br><br>Price $24.95</br></td>
						</tr>
						<tr>
							<td style="width: 226px">
																<span class="style1">Quanty:</span><span class="style2"><span class="style1"><input type='text' name='quantity' value='1' size='1' /></span></span><span class="style1">
																</span>
							</td>
						</tr> 
						<tr> 
							<td style="width: 226px"> 
								<span class="style2"><span class="style1"> 
								<input type='hidden' name='title' value='Wood King Dark Walnut' /> 
								<input type='hidden' name='description' value='0011w346' /> 
								<input type='hidden' name='price' value='24.95' /> 
								</span></span><span class="style1">Fed-Ex:</span><span class="style2"><span class="style1"><input type='text' name='postage' value='0.01' style="width: 72px" /></span></span>
								<span class="style2"><span class="style1">
								<input type='hidden' name='postage2' value='0.00' />	
								<input style="padding:.5em;width:120px;" type="submit" value="Add To Basket"/></span></span><span class="style1">
								</span> 
							</td> 
						</tr>
					</table> 
				</form> 
			</div>
			<div class="drag" style="float:left;background:#fff;"> 
				<form style="border:1px solid #ccc;padding:1em;width:226px;margin:0;" class="easybasket" method="post" action="?basket=add">   
					<table> 
						<tr>
							<td style="color:#2D4262 ; font-weight:bold; font-size:14px">Drop Dead Amber<br><img alt="" src="http://www.woodking.net/image/cache/catalog/IMG_1636.1.fw-126x175.png" width="126" height="168" style="float: left" /></br>
							</td>
						</tr>
						<tr>
							<td style="font-size:12px; width: 226px;"><br>An Amber Additive for any type Wood Floor Sealer. Add a small amount for a light amber tone. Add a large amount for a heavy amber tone.

Highly Concentrated Makes over 4 gallons of sealer</br><br>Price $24.95</br></td>
						</tr>
						<tr>
							<td style="width: 226px" class="style1">
																<span class="style1">Quanty:</span><span class="style2"><span class="style1"><input type='text' name='quantity' value='1' size='1' /></span></span><span class="style1">
																</span>
							</td>
						</tr> 
						<tr> 
							<td> 
								<span class="style2"><span class="style1"> 
								<input type='hidden' name='title' value='Wood King Drop Dead Amber' /> 
								<input type='hidden' name='description' value='0011005' /> 
								<input type='hidden' name='price' value='24.95' /> 
								</span></span><span class="style1">Fed-Ex:</span><span class="style2"><span class="style1"><input type='text' name='postage' value='1.00' style="width: 72px" /></span></span>
								<span class="style2"><span class="style1">
								<input type='hidden' name='postage2' value='0.00' />	 
								<input style="padding:.5em;width:120px;" type="submit" value="Add To Basket"/></span></span><span class="style1">
								</span> 
							</td> 
						</tr>
					</table> 
				</form> 
			</div>
			<div style="float:right;" data-url="skin=demo.xsl">Show the basket to use the Drag and Drop feature.</div>
			<div class="easybasket" style="float:right;" data-url="skin=demo.xsl"></div>
		</div>
		
		
		
		
	</xsl:template>


<!--###########################################
	SETTINGS
	###########################################-->
	
	<xsl:template match="settings">
		<h1><span class="logo">&lt;easybasket/&gt;</span> Settings</h1>
		<xsl:if test="not($auth)">
			<xsl:call-template name="login"/>
		</xsl:if>
		<xsl:if test="$auth">
			<xsl:call-template name="settings-auth"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="settings-auth">
		<xsl:call-template name="logout"/>
		<div id="panel">
			<form method="post" action="?page=settings&amp;system=save">
				<div>
					<xsl:apply-templates select="checkouts"/>
					<xsl:apply-templates select="form"/>
				</div>
				<div id="footer">
					<input type="submit" class="submit" value="Save settings"/>
				</div>
			</form>
		</div>
	</xsl:template>
	
	<xsl:template match="paypal">
		<div id="paypal">
			<xsl:variable name="currency-code">
				<cc>USD</cc><cc>AUD</cc><cc>CAD</cc><cc>CHF</cc><cc>CZK</cc><cc>DKK</cc><cc>EUR</cc>
				<cc>HKD</cc><cc>HUF</cc><cc>ILS</cc><cc>JPY</cc><cc>MXN</cc><cc>NOK</cc><cc>NZD</cc>
				<cc>PLN</cc><cc>SEK</cc><cc>SGD</cc><cc>GBP</cc>
			</xsl:variable>
			<fieldset id="fieldset">
				<legend><a href="https://www.paypal.com" alt="Paypal"><img src="{$folder}pp.png"/></a></legend>
				<table>
					<tr>
						<td class="left">Enable</td>
						<td class="middle">
							<input type="checkbox" name="paypal-enable" value="checked">
								<xsl:if test="@enable = 'yes'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
						</td>
						<td class="help">Enable Paypal Checkout.</td>
					</tr>
					<tr>
						<td class="left">Sandbox</td>
						<td class="middle">
							<input type="checkbox" name="paypal-sandbox" value="checked">
								<xsl:if test="@sandbox = 'yes'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
						</td>
						<td class="help">Enable if you are using the Sandbox testing enviroment.</td>
					</tr>
					<tr>
						<td class="left">Business Email</td>
						<td class="middle"><input type="text" name="business" value="{business}" size="30"/></td>
						<td class="help">Add your Paypal email address.</td>
					</tr>
					<tr>
						<td class="left">Currency Code</td> 
						<td class="middle">
							<select name="currency-code">
								<xsl:variable name="currency" select="currency-code"/>
								<xsl:for-each select="exsl:node-set($currency-code)/*">
									<option>
										<xsl:if test=". = $currency">
											<xsl:attribute name="selected">
												<xsl:value-of select="$currency"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="."/>
									</option>
								</xsl:for-each>
							</select>
						</td>
						<td class="help">Select your Currency Code.</td>
					</tr>
					<tr>
						<td class="left">Enable IPN</td>
						<td class="middle">
							<input type="checkbox" name="ipn-enable" value="checked">
								<xsl:if test="@ipn = 'yes'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
						</td>
						<td class="help">Enable Paypal Instant Payment Notification.</td>
					</tr>
					<tr>
						<td class="left">IPN URL</td>
						<td class="middle"><input type="text" name="ipn-url" value="{ipn-url}" size="30"/></td>
						<td class="help">Add your Paypal IPN address, eg. http://www.abc.com/easybasket/</td>
					</tr>
				</table>
			</fieldset>
		</div>
	</xsl:template>
	
	<xsl:template match="google">
		<xsl:variable name="currency-code">
			<cc>USD</cc><cc>GBP</cc>
		</xsl:variable>
		<fieldset>
			<legend><a href="http://checkout.google.com" alt="Google Checkout"><img src="{$folder}gc.png"/></a></legend>
			<table>	
				<tr>
					<td class="left">Enable</td>
					<td class="middle">
						<input name="google-enable" value="checked" type="checkbox">
							<xsl:if test="@enable = 'yes'">
								<xsl:attribute name="checked">yes</xsl:attribute>
							</xsl:if>
						</input>
					</td>
					<td class="help">Enable Google Checkout.</td>
				</tr>
				<tr>
					<td class="left">Sandbox</td>
					<td class="middle">
						<input name="google-sandbox" value="checked" type="checkbox">
							<xsl:if test="@sandbox = 'yes'">
								<xsl:attribute name="checked">yes</xsl:attribute>
							</xsl:if>
						</input>
					</td>
					<td class="help">Enable if you are using the Sandbox testing enviroment.</td>
				</tr>
				<tr>
					<td class="left">Merchant-ID</td> 
					<td class="middle"><input type="text" name="merchant-id" value="{merchant-id}" size="30"/></td>
					<td class="help">Add your Merchant ID.</td>
				</tr>
				<tr>
					<td class="left">Merchant-Key</td> 	
					<td class="middle"><input type="text" name="merchant-key" value="{merchant-key}" size="30"/></td>
					<td class="help">Add your Merchant Key.</td>
				</tr>
				<tr>
					<td class="left">Mail Method</td> 
					<td class="middle"><input type="text" name="shipping-name" value="{shipping-name}" size="30"/></td>
					<td class="help">Set your mail method (i.e Royal Mail, UPS).</td>
				</tr>
				<tr>
					<td class="left">Currency Code</td> 
					<td class="middle">
						<select name="currency">
							<xsl:variable name="currency" select="currency"/>
							<xsl:for-each select="exsl:node-set($currency-code)/*">
								<option>
									<xsl:if test=". = $currency">
										<xsl:attribute name="selected">
											<xsl:value-of select="$currency"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="."/>
								</option>
							</xsl:for-each>
						</select>
					</td>
					<td class="help">Select your Currency Code.</td>
				</tr>
			</table>
		</fieldset>
	</xsl:template>

	<xsl:template match="form">
		<fieldset>
			<legend><h2>Form Names</h2></legend>
			<table>
				<tr>
					<td class="left">Title</td> 	
					<td class="middle"><input type="text" name="title" value="{maps/title}" size="30"/></td>
					<td class="help" colspan="2">Map your alias here, or use the default value "title"</td>
				</tr>
				<tr>
					<td class="left">Description</td> 	
					<td class="middle"><input type="text" name="description" value="{maps/description}" size="30"/></td>
					<td class="help" colspan="2">Map your alias here, or use the default value "description"</td>
				</tr>
				<tr>
					<td class="left">Price</td> 	
					<td class="middle"><input type="text" name="price" value="{maps/price}" size="30"/></td>
					<td class="help" colspan="2">Map your alias here, or use the default value "price"</td>
				</tr>
				<tr>
					<td class="left">Image</td> 	
					<td class="middle"><input type="text" name="image" value="{maps/image}" size="30"/></td>
					<td class="help" colspan="2">Map your alias here, or use the default value "image"</td>
				</tr>
				<tr>
					<td class="left">URL</td> 	
					<td class="middle"><input type="text" name="url" value="{maps/url}" size="30"/></td>
					<td class="help" colspan="2">Map your alias here, or use the default value "url"</td>
				</tr>
			</table>
		</fieldset>
		<fieldset>
			<legend><img width="150px" height="80px" src="{$folder}postage.png"/></legend>
			<table>
				<tr>
					<td class="left">First Item Cost</td> 	
					<td class="middle"><input type="text" name="first-item" value="{postage/first-item}" size="30"/></td>
					<td class="help" colspan="2">Postage cost for first item added to basket.</td>
				</tr>
				<tr>
					<td class="left">Additional Items Cost</td> 
					<td class="middle"><input type="text" name="extra-items" value="{postage/extra-items}" size="30"/></td>
					<td class="help" colspan="2">Postage cost for each additional item added to basket.</td>
				</tr>
			</table>
		</fieldset>
		<fieldset>
			<legend><h2>Options</h2></legend>
			<table id="optiontable">
				<xsl:apply-templates select="options"/>	
			</table>
			<table id="add">
				<tr><td class="left"></td><td class="middle">Add Option</td><td><img class="add-link" src="{$folder}plus.png" width="24" height="24"/></td></tr>
			</table>
		</fieldset>
	</xsl:template>

	<xsl:template match="option">
		<tr>
			<td class="left"><xsl:value-of select="local-name()"/></td> 
			<td class="middle">
				<input type="text" name="option" value="{.}" size="30"/>
			</td>
			<td>
				<img class="remove-link" src="{$folder}del.png" width="24" height="24"/>
			</td>
			<td></td>
		</tr>
	</xsl:template>
	
<!--###########################################
	LOGS
	###########################################-->
	
	<xsl:template match="logs">
		<h1><span class="logo">&lt;easybasket/&gt;</span> Log Files</h1>
		<xsl:if test="not($auth)">
			<xsl:call-template name="login"/>
		</xsl:if>
		<xsl:if test="$auth">
			<xsl:call-template name="logout"/>
			<table class="log" style="border-top:1px solid #ccc;">
				<tr>
					<td class="files" style="width:170px"><xsl:apply-templates select="files"/></td>
					<td style="border-left:1px solid #ccc;padding:1em;"><xsl:apply-templates select="log"/></td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="files">
		<h2>Logs</h2>
		<xsl:apply-templates select="file"/>
	</xsl:template>
	
	<xsl:template match="file">
		<a href="?page=logs&amp;file={.}"><xsl:value-of select="."/></a>
	</xsl:template>

	<xsl:template match="log">
		<h2><xsl:value-of select="@filename"/></h2>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="ipn">
		<h4 style="margin-bottom:1em;">Customer Invoice</h4>
		<table style="margin:0;padding:1em;">
			<tr>
				<td colspan="2" style="width:500px;color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;">
					Date, <xsl:value-of select="payment_date"/><br/>
					Payment Status, <xsl:value-of select="payment_status"/>
				</td>
				<td colspan="2" style="color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;text-align:right;">
					<xsl:value-of select="address_name"/><br/>
					<xsl:value-of select="address_street"/><br/>
					<xsl:value-of select="address_city"/><br/>
					<xsl:value-of select="address_state"/><br/>
					<xsl:value-of select="address_zip"/><br/>
					<xsl:value-of select="address_country"/><br/>
					<xsl:value-of select="payer_email"/>
				</td>
			</tr>
			<tr>
				<td style="width:92px;background:#2D4262;color:#fff;font-size:14px;padding:.5em;border:1px solid #ccc;">
					<b>Quantity</b>
				</td>
				<td style="width:400px;background:#2D4262;color:#fff;font-size:14px;padding:.5em;border:1px solid #ccc;">
					<b>Description</b>
				</td>
				<td style="width:92px;background:#2D4262;color:#fff;font-size:14px;padding:.5em;border:1px solid #ccc;">
					<b>Unit Cost</b>
				</td>
				<td style="background:#2D4262;color:#fff;font-size:14px;padding:.5em;border:1px solid #ccc;">
					<b>Total</b>
				</td>
			</tr>
			<xsl:call-template name="items">
				<xsl:with-param name="max" select="num_cart_items"/>
			</xsl:call-template>
			<tr>
				<td style="width:92px;"></td>
				<td style="width:400px;"></td>
				<td style="width:92px;color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;">
					Postage
				</td>
				<td style="color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;">
					<xsl:value-of select="mc_handling"/>
				</td>
			</tr>
			<tr>
				<td style="width:92px;"></td>
				<td style="width:400px;"></td>
				<td style="width:92px;color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;">
					<b>Total</b>
				</td>
				<td style="color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;">
					<b><xsl:value-of select="mc_gross"/></b>
				</td>
			</tr>
		</table>	
		
		
		
	</xsl:template>
	
	<!-- Recursive -->
	<xsl:template name="items">
		<xsl:param name="max"/>
		<xsl:param name="count" select="1"/>
		<xsl:variable name="name" select="concat('item_name',$count)"/>
		<xsl:variable name="quantity" select="concat('quantity',$count)"/>
		<xsl:variable name="unit-cost" select="concat('mc_gross_',$count)"/>
		<tr>
			<td style="width:92px;color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;">
				<xsl:value-of select="./*[local-name()=$quantity]"/>
			</td>
			<td style="width:400px;color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;">
				<xsl:value-of select="./*[local-name()=$name]"/>
			</td>
			<td style="width:92px;color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;">
				<xsl:value-of select="./*[local-name()=$unit-cost]"/>
			</td>
			<td style="color:#2D4262;font-size:14px;padding:1em;border:1px solid #ccc;">
				<xsl:value-of select="./*[local-name()=$quantity] * ./*[local-name()=$unit-cost]"/>
			</td>
		</tr>
		<xsl:if test="$count &lt; $max">
			<xsl:call-template name="items">
				<xsl:with-param name="max" select="$max"/>
				<xsl:with-param name="count" select="$count + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
<!--###########################################
	HOST INFO
	###########################################-->
	
	<xsl:template match="host">
		<h1><span class="logo">&lt;easybasket/&gt;</span> Host Information</h1>
		<xsl:if test="not($auth)">
			<xsl:call-template name="login"/>
		</xsl:if>
		<xsl:if test="$auth">
			<xsl:call-template name="logout"/>
		<p style="border-top:1px solid #ccc;margin:0;"></p>	
		<p>Most hosts will run Easybasket PHP without any problems, however some may not if they don't meet the minimum 
		requirements.</p>
		<p>The table below shows the suitability of this host for running Easybasket. To test <em>your</em> host
		for Easybasket suitability, download this <a href="info.zip">file</a> then upload it to your host and open it from a browser.</p>
	
		<table>
			<tr>
				<th>Module</th>
				<th>Minimum Version</th>
				<th>Notes</th>
				<th>Running</th>
				<th>Host Suitability</th>
			</tr>
			<tr>
				<td style="border:1px solid #ccc;">PHP</td>
				<td style="border:1px solid #ccc;"><xsl:value-of select="php/@running"/></td>
				<td style="border:1px solid #ccc;">Easybasket has been tested on PHP</td>
				<td class="mono" style="border:1px solid #ccc;"><xsl:value-of select="php/@required"/></td>
				<td class="{php/@status}" style="border:1px solid #ccc;"><xsl:value-of select="php/@status"/></td>
			</tr>
			<tr>
				<td style="border:1px solid #ccc;">libxml</td>
				<td style="border:1px solid #ccc;"><xsl:value-of select="libxml/@running"/></td>
				<td style="border:1px solid #ccc;">Easybasket makes extensive use of XSL transformations. In PHP, XSL transformation functions
				are provided by a library called <em>libxml</em>. If an apprpriate version of libxml is installed
				and enabled on this	system, the <em>Host suitability</em> column will indicate "Good".</td>
				<td class="mono" style="border:1px solid #ccc;"><xsl:value-of select="libxml/@required"/></td>
				<td class="{libxml/@status}" style="border:1px solid #ccc;"><xsl:value-of select="libxml/@status"/></td>
			</tr>
			<tr>
				<td style="border:1px solid #ccc;">libcurl</td>
				<td style="border:1px solid #ccc;"><xsl:value-of select="libcurl/@running"/></td>
				<td style="border:1px solid #ccc;"><em>libcurl</em> is only required for the Google Checkout. If you have not enabled the Google Checkout then
				the libcurl version doesn't matter to you. However if you are using the Google checkout, then the 
				host must have an appropriate version of libcurl running.</td>
				<td class="mono" style="border:1px solid #ccc;"><xsl:value-of select="libcurl/@required"/></td>
				<td class="{libcurl/@status}" style="border:1px solid #ccc;"><xsl:value-of select="libcurl/@status"/></td>
			</tr>
			
		</table>
		
		<h3>Enable XSLT on a Windows Host</h3>
		<p>When PHP is installed on a Windows host, the XSLT processor (libxml) is installed but not enabled 
		by default. To enable it, the PHP configuration file (usually c:\windows\php.ini) should be edited to
		uncomment (i.e. remove the semi-colon from) the following line;</p>
		<code>;extension=php_xsl.dll</code>
		<p>For this change to take effect, the web server will need to be restarted. However, most hosts will
		have already made this change and enabled XSLT for you.</p>
		<p>More <a target="_blank" href="http://www.php.net/manual/en/book.xsl.php#65277">information</a> 
		regarding this issue can be found in the PHP documentation.</p>
		</xsl:if>
	</xsl:template>
	
</xsl:transform>