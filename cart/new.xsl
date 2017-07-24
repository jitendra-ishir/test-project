<?xml version="1.0"?>

<!--
###########################################################################
Nigel Alderton
Save Settings
10th May 2011
www.easybasket.co.uk
###########################################################################
-->

<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	extension-element-prefixes="exsl">

	<xsl:output method="xml" omit-xml-declaration="yes"/>

	<!--
	###########################################
	EXTERNAL PARAMETERS
	###########################################
	-->

	<xsl:param name="timestamp"/>
	<xsl:param name="http_form"/>

	<!--
	##########################################
	ROOT TEMPLATE
	##########################################
	-->
	
	<xsl:template match="settings">
	
		<xsl:variable name="_form">
			<xsl:call-template name="tokenize">
				<xsl:with-param name="list" select="$http_form"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="RAW" select="exsl:node-set($_form)"/>
	
		<settings version="1.0" password="{$RAW/new-password}" timestamp="{$timestamp}">
			<checkouts>
				<paypal
				  enable="{substring('yes no', 5 - 4*($RAW/paypal-enable = 'checked'), 3)}"
				  sandbox="{substring('yes no', 5 - 4*($RAW/paypal-sandbox = 'checked'), 3)}"
				  ipn="{substring('yes no', 5 - 4*($RAW/ipn-enable = 'checked'), 3)}">
					<business><xsl:value-of select="$RAW/business"/></business>
					<currency-code><xsl:value-of select="$RAW/currency-code"/></currency-code>
					<ipn-url><xsl:value-of select="$RAW/ipn-url"/></ipn-url>
				</paypal>
				<google
				  enable="{substring('yes no', 5 - 4*($RAW/google-enable = 'checked'), 3)}"		
				  sandbox="{substring('yes no', 5 - 4*($RAW/google-sandbox = 'checked'), 3)}">
					<merchant-id><xsl:value-of select="$RAW/merchant-id"/></merchant-id>
					<merchant-key><xsl:value-of select="$RAW/merchant-key"/></merchant-key>
					<currency><xsl:value-of select="$RAW/currency"/></currency>
					<shipping-name><xsl:value-of select="$RAW/shipping-name"/></shipping-name>
				</google>
			</checkouts>
			<form>
				<maps>
					<title><xsl:value-of select="$RAW/title"/></title>
					<description><xsl:value-of select="$RAW/description"/></description>
					<price><xsl:value-of select="$RAW/price"/></price>
					<image><xsl:value-of select="$RAW/image"/></image>
					<url><xsl:value-of select="$RAW/url"/></url>
				</maps>
				<options>
					<xsl:copy-of select="$RAW/option"/>
				</options>
				<postage>
					<first-item><xsl:value-of select="$RAW/first-item"/></first-item>
					<extra-items><xsl:value-of select="$RAW/extra-items"/></extra-items>
				</postage>
			</form>
		</settings>
	</xsl:template>
	
	
<!--###########################################
	REMOVE COMMENTS
	###########################################-->
	
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="comment()"/>
	
	
<!--###########################################
	TEMPLATE (Recursive)
		Tokenize.
	RESULT
		A result-tree-fragment comprised of <name>value</name> elements. Any input not of the form 'name=value' is ignored.
		Note: In order for the result to be iterable, it must be turned from a 'result-tree-fragment' into an XSLT-1.0 node-set. This is done elsewhere.
	###########################################-->
	<xsl:template name="tokenize">
	
		<xsl:param name="list"/> 
		
		<xsl:variable name="seperator" select="'&amp;'"/>
		
		<xsl:variable name="first" select="substring-before(concat($list, $seperator), $seperator)"/>
		<xsl:variable name="butfirst" select="substring-after($list, $seperator)"/>

		<xsl:variable name="name" select="normalize-space(substring-before($first, '='))"/>
		<xsl:variable name="value" select="normalize-space(substring-after($first, '='))"/>
		
		<xsl:if test="string-length($name)>0 and string-length($value)>0">
			<xsl:element name="{$name}"><xsl:value-of select="$value"/></xsl:element>
		</xsl:if>

		<xsl:if test="$butfirst">
			<xsl:call-template name="tokenize">
				<xsl:with-param name="list" select="$butfirst"/> 
				<xsl:with-param name="seperator" select="$seperator"/> 
			</xsl:call-template>
		</xsl:if>
		
	</xsl:template>
	
	
</xsl:transform>