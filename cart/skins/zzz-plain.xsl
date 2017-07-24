<?xml version="1.0"?>

<!--
###########################################################################
Easybasket Skin
Nigel Alderton
21st May 2011
www.easybasket.co.uk
###########################################################################

#####  #####  #####      ####   #       ###   #####  #   #
   #      #      #       #   #  #      #   #    #    ##  #
  #      #      #   ###  ####   #      #####    #    # # #
 #      #      #         #      #      #   #    #    #  ##
#####  #####  #####      #      #####  #   #  #####  #   #
-->

<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<!--##########################################
	ROOT TEMPLATE
	###########################################-->
    <xsl:template match="items">
		<div>
			<table>
				<xsl:call-template name="headings"/>
				<xsl:apply-templates match="item"/>
				<xsl:call-template name="footer"/>
				<xsl:call-template name="checkouts"/>
			</table>
		</div>
	
	</xsl:template>	
		

	<!--##########################################
	TABLE HEADINGS
	###########################################-->
    <xsl:template name="headings">
		<tr>
			<th style="text-align:left">Item</th>
			<th style="text-align:center">Quantity</th>
			<th style="text-align:right">Total</th>
			<th style="text-align:center"></th>
		</tr>
	</xsl:template>	

	
	<!--##########################################
	BASKET ITEM
	###########################################-->
    <xsl:template match="item">
		<tr>
		
			<td><xsl:value-of select="title"/></td>

			<td style="text-align:center">
				<div>
					<form class="easybasket" style="display:inline" method="POST" action="?basket=decrease">
						<xsl:for-each select="*">
							<input type="hidden" name="{name()}" value="{text()}"/>
						</xsl:for-each>
						<input type="submit" value="-" title="One less"/>
					</form>
					<span class="quantity"><xsl:value-of select="@quantity"/></span>
					<form class="easybasket" style="display:inline" method="POST" action="?basket=increase">
						<xsl:for-each select="*">
							<input type="hidden" name="{name()}" value="{text()}"/>
						</xsl:for-each>
						<input type="submit" value="+" title="One more"/>
					</form>
				</div>
			</td>
			
			<td style="text-align:right">$<xsl:value-of select='format-number(@total, "###,##0.00")'/></td>
			
			<td style="text-align:center">
				<form class="button easybasket" method="POST" action="?basket=remove">
					<xsl:for-each select="*">
						<input type="hidden" name="{local-name()}" value="{text()}"/>
					</xsl:for-each>
					<input type="submit" value="x" title="Remove from basket"/>
				</form>
			</td> 	
		</tr>
	</xsl:template>
	
	
	<!--##########################################
	BASKET FOOTER
	###########################################-->
	<xsl:template name="footer">
		<tr>
			<td colspan="2"></td>
			<td style="text-align:right">$<xsl:value-of select='format-number(@total, "###,##0.00")'/></td>
			<td style="text-align:center">
				<form class="button easybasket" method="POST" action="?basket=reset">
					<input type="submit" value="X" title="Empty the basket"/>
				</form>
			</td>
		</tr>
	</xsl:template>	
	
	
	<!--##########################################
	CHECKOUTS
	###########################################-->
	<xsl:template name="checkouts">
		<tr><td colspan="4" style="text-align:center;">
			<xsl:if test="@paypal='yes'">
				<xsl:if test="item">
					<form style="padding-top:10px; display:inline" method="POST" action="?checkout=paypal">
						<input type="image" name="submit"
						src="https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif"
						alt="PayPal - The safer, easier way to pay online"/>
					</form>
				</xsl:if>
				<xsl:if test="not(item)">
					<img src="https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif"
						alt="PayPal - The safer, easier way to pay online"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="@google='no'">
				<xsl:if test="item">
					<form style="padding-top:10px; display:inline" method="POST" action="?checkout=google">
							<input type="image" name="submit"
							src="https://checkout.google.com/buttons/checkout.gif?w=168&amp;h=44&amp;style=trans&amp;variant=text&amp;loc=en_GB"
							alt="Pay by Google Checkout"/>
						</form>
				</xsl:if>
				<xsl:if test="not(item)">
					<img src="https://checkout.google.com/buttons/checkout.gif?w=168&amp;h=44&amp;style=trans&amp;variant=text&amp;loc=en_GB" 
						alt="Pay by Google Checkout"/>
				</xsl:if>
			</xsl:if>
		</td></tr>
	</xsl:template>

	
</xsl:transform>