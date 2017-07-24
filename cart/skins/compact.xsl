<!--
###########################################################################
Easybasket Skin
Tim Dodgson
23rd May 2011
www.easybasket.co.uk
###########################################################################
-->

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
    <xsl:variable name="google" select="/items/@google"/>
	<xsl:variable name="paypal" select="/items/@paypal"/>
  
	<xsl:template match="items">
		<div id="ebskin">
			<table style="width:390px;">
				<xsl:call-template name="header"/>
				<xsl:apply-templates select="item"/>
				<xsl:call-template name="footer"/>
			</table>
		</div>
	</xsl:template>

	<xsl:template name="header">
	    <tr style="color:white;background-color:#5275AA;font-weight:bold">
		    <td colspan="3" valign="middle">
				<form style="display:inline;float:right;margin:0 5px 0 5px;" class="easybasket" method="POST" action="?basket=reset">
					<input type="submit" value="Reset" title="Empty the basket"/>
				</form>
				<xsl:if test="@quantity = 1">
					<span style="float:right;"><xsl:value-of select="@quantity" /> Item</span>
				</xsl:if>	
				<xsl:if test="not(@quantity = 1)">
					<span style="float:right"><xsl:value-of select="@quantity" /> Items</span>
				</xsl:if>	
			</td>
		</tr>
	</xsl:template>	
	
	<xsl:template match="item">
		<tr style="vertical-align:top">	
			<td style="width:6em;text-align:center;background:FloralWhite;">
				<xsl:variable name="i">
					<xsl:if test="image">
						<img src="{image}" style="max-width:6em; max-height:5em; vertical-align:middle"/>
					</xsl:if>
					<xsl:if test="not(image)">
						<span>No picture</span>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="url">
					<a href="{url}"><xsl:copy-of select="$i"/></a>
				</xsl:if>
				<xsl:if test="not(url)">
					<xsl:copy-of select="$i"/>
				</xsl:if>
			</td>
			<td style="background:FloralWhite;">
				<div class="title"><b><a href="{url}"><xsl:value-of select="title"/></a></b></div>
				<xsl:for-each select="*[@option]">
					<div class="option" style="text-transform:capitalize;">
						<xsl:value-of select="local-name()" />: <xsl:value-of select="." />
					</div>
				</xsl:for-each>
			</td>
			<td style="text-align:right; min-width:10em">
				<div>
					<xsl:value-of select="@quantity"/>
					<span> at </span>
					$<xsl:value-of select='format-number(@unit-price, "###,##0.00")'/>
					<span> = </span>
					<b>$<xsl:value-of select='format-number(@subtotal, "###,##0.00")'/></b>
				</div>
				<div>
					Postage <b>$<xsl:value-of select='format-number(@postage, "###,##0.00")'/></b>
				</div>
				<div>
					<form style="display:inline" class="easybasket" method="POST" action="?basket=decrease">
						<xsl:for-each select="*">
							<input type="hidden" name="{name()}" value="{text()}"/>
						</xsl:for-each>
						<input type="submit" value="-" title="One less"/>
					</form>
					<form style="display:inline" class="easybasket" method="POST" action="?basket=increase">
						<xsl:for-each select="*">
							<input type="hidden" name="{name()}" value="{text()}"/>
						</xsl:for-each>
						<input type="submit" value="+" title="One more"/>
					</form>
					<form style="display:inline" class="easybasket" method="POST" action="?basket=remove">
						<xsl:for-each select="*">
							<input type="hidden" name="{name()}" value="{text()}"/>
						</xsl:for-each>
						<input type="submit" value="x" title="Remove from basket"/>
					</form>
				</div>	
			</td>
		</tr>
	</xsl:template>
		
	<xsl:template name="footer">
		<tr>
			<td colspan="2" style="text-align:center;vertical-align:bottom">
				<xsl:if test="$google = 'no'">
					<xsl:if test="item">
						<form style="margin:0;" method="POST" action="?checkout=google">
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
				<xsl:if test="$paypal = 'yes'">
					<xsl:if test="item">
						<form style="margin:0;" method="POST" action="?checkout=paypal">
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
			</td>
			<td style="text-align:right;vertical-align:bottom;">
				<xsl:call-template name="totals"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="totals">
		<div>Total $<xsl:value-of select='format-number(@subtotal, "###,##0.00")'/></div>
		<div>Postage $<xsl:value-of select='format-number(@postage, "###,##0.00")'/></div>
		<div><b>Order total $<xsl:value-of select='format-number(@total, "###,##0.00")'/></b></div>
	</xsl:template>
	
</xsl:transform>