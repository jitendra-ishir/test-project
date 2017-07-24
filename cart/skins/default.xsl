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
		<div id="eb">
			<div id="ebfooter">
				<p id="total">
				<span id="showhidecontrol">Show</span>
				<xsl:if test="item">
					<xsl:choose>
						<xsl:when test="@quantity &#61; 1">
							| <xsl:value-of select="@quantity" /> Item |
						</xsl:when>
						<xsl:otherwise>
							| <xsl:value-of select="@quantity" /> Items |
						</xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="total"/>
				</xsl:if>	
				</p>
			</div>
			<div id="ebbasket" class="showhidearea">
				<xsl:apply-templates select="item"/>
				<xsl:call-template name="totals"/>
				<div id="checkouts">
				<div id="google">
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
				</div>
				<div id="paypal">
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
				</div>
			</div>
			</div>			
		</div>
	</xsl:template>
	
	<xsl:template match="item">		
			<div class="item">
				<a href="{url}"><img title="{title}" src="{image}"/></a>
				<p class="title"><xsl:value-of select="title"/></p>
				<xsl:for-each select="*[@option]">
					<p class="option" style="text-transform:capitalize;">
						<xsl:value-of select="local-name()" />: <xsl:value-of select="." />
					</p>
				</xsl:for-each>
				<p class="price">$<xsl:value-of select='format-number(@unit-price, "###,###.00")'/></p>
				<p class="quantity">Qty <xsl:value-of select="@quantity"/></p> 
				<div class="itemnav">
					<table>
						<tr>
							<td>
								<form class="easybasket" method="POST" action="?basket=decrease">
									<xsl:for-each select="*">
										<input type="hidden" name="{name()}" value="{text()}"/>
									</xsl:for-each>
									<input type="image" name="submit"
									src="easybasket/skins/images/sub.png"/>
								</form>
							</td>
							<td>
								<form class="easybasket" method="POST" action="?basket=increase">
									<xsl:for-each select="*">
										<input type="hidden" name="{name()}" value="{text()}"/>
									</xsl:for-each>
									<input type="image" name="submit"
									src="easybasket/skins/images/plus.png"/>
								</form>
							</td>
							<td>
								<form class="easybasket" method="POST" action="?basket=remove">
									<xsl:for-each select="*">
										<input type="hidden" name="{name()}" value="{text()}"/>
									</xsl:for-each>
									<input type="image" name="submit"
									src="easybasket/skins/images/del.png"/>
								</form>
							</td>
						</tr>
					</table>
				</div>
			</div>
	</xsl:template>  
	
	<xsl:template name="totals">
		<div id="totalinner">
			<p>Total: $<xsl:value-of select='format-number(@subtotal, "###,##0.00")'/></p>
			<p>Postage: $<xsl:value-of select='format-number(@postage, "###,##0.00")'/></p>
			<p>Total Inc Postage: $<xsl:value-of select='format-number(@total, "###,##0.00")'/></p>
		</div>
	</xsl:template>
	
	<xsl:template name="total">
		$<xsl:value-of select='format-number(@total, "###,##0.00")'/>
	</xsl:template>
	
</xsl:transform>