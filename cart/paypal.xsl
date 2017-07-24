<!--
###########################################################################
Easybasket PayPal XSLT
Nigel Alderton
21st May 2011
www.easybasket.co.uk
###########################################################################
-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="host" select="'https://www.paypal.com/cgi-bin/webscr'"/>

	<!-- ##########################################
	ROOT TEMPLATE
	###########################################	-->
	
	<xsl:template match="basket">
		<xsl:variable name="host">
			<xsl:if test="checkouts/paypal/@sandbox='yes'">
				<xsl:text>https://www.sandbox.paypal.com/cgi-bin/webscr</xsl:text>
			</xsl:if>
			<xsl:if test="checkouts/paypal/@sandbox='no'">
				<xsl:text>https://www.paypal.com/cgi-bin/webscr</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="url">
			<host><xsl:value-of select="$host"/></host>
			<preamble><xsl:call-template name="preamble"/></preamble>
			<xsl:apply-templates select="items/item"/>
		</xsl:variable>
		<url>
			<concat><xsl:value-of select="$url"/></concat>
			<xsl:copy-of select="$url"/>
		</url>
	</xsl:template>
	
	<!-- ##########################################
	PREAMBLE
	###########################################	-->
	
	<xsl:template name="preamble">
		<xsl:text>?cmd=_cart</xsl:text>
		<xsl:if test="checkouts/paypal/@ipn='yes'">
			<xsl:text>&amp;notify_url=</xsl:text>
			<xsl:value-of select="checkouts/paypal/ipn-url"/>
		</xsl:if>
<!--	<xsl:text>&amp;return=http://vostro.uk.to</xsl:text>
		<xsl:text>&amp;cancel_return=http://vostro.uk.to</xsl:text>	-->
		<xsl:text>&amp;upload=1</xsl:text>
		<xsl:text>&amp;business=</xsl:text><xsl:value-of select="checkouts/paypal/business"/>
		<xsl:text>&amp;currency_code=</xsl:text><xsl:value-of select="checkouts/paypal/currency-code"/>
	</xsl:template>

	<!-- ##########################################
	ITEM
	###########################################	-->
	
	<xsl:template match="items/item">
		<item>
			<xsl:apply-templates select="*[@option]" mode="options">
				<xsl:with-param name="i" select="position()"/>
			</xsl:apply-templates>
			<xsl:text>&amp;item_name_</xsl:text>
			<xsl:value-of select="position()"/>
			<xsl:text>=</xsl:text>
			<xsl:value-of select="title"/>
			<xsl:text>&amp;amount_</xsl:text>
			<xsl:value-of select="position()"/>
			<xsl:text>=</xsl:text>
			<xsl:value-of select="@unit-price"/>
			<xsl:text>&amp;quantity_</xsl:text>
			<xsl:value-of select="position()"/>
			<xsl:text>=</xsl:text>
			<xsl:value-of select="@quantity"/>	
			<xsl:text>&amp;handling_</xsl:text>
			<xsl:value-of select="position()"/>
			<xsl:text>=</xsl:text>
			<xsl:value-of select="@postage"/>
		</item>
	</xsl:template>
	
	<!-- ##########################################
	FOOT OF THE BASKET
	###########################################	-->
	
	<xsl:template match="*" mode="options">
		<xsl:param name="i"/>
		<xsl:variable name="me" select="name()"/>
		<xsl:variable name="opt" select="position()-1"/>
		<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
		<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
		
		<xsl:text>&amp;</xsl:text>
		<xsl:text>on</xsl:text>
		<xsl:value-of select="$opt"/>_<xsl:value-of select="$i"/>
		<xsl:text>=</xsl:text>
		<xsl:value-of select="concat(translate(substring($me, 1, 1), $lowercase, $uppercase), substring($me, 2))"/>
		<xsl:text>&amp;</xsl:text>
		<xsl:text>os</xsl:text>
		<xsl:value-of select="$opt"/>_<xsl:value-of select="$i"/>
		<xsl:text>=</xsl:text>
		<xsl:value-of select="concat(translate(substring(., 1, 1), $lowercase, $uppercase), substring(., 2))"/>		
	</xsl:template>

</xsl:transform>