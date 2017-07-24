<?xml version="1.0"?>

<!--
###########################################################################
Easybasket Skin
Nigel Alderton
23rd May 2011
www.easybasket.co.uk
###########################################################################
-->

<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" omit-xml-declaration="yes"/>

<!--	###########################################
	ROOT TEMPLATE
	###########################################	-->
    <xsl:template match="items">
		<span class="tab">
			<span class="total">$<xsl:value-of select="format-number(@total, '###,##0.00')"/></span>
			<span class="quantity"><xsl:value-of select="@quantity"/></span>
		</span>
	</xsl:template>	

</xsl:transform>