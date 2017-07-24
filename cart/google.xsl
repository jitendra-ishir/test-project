<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" method="html"/>
	
	<xsl:template match="basket">
		<root>
			<xsl:variable name="host">
				<xsl:if test="checkouts/google/@sandbox='yes'">
					<xsl:text>https://sandbox.google.com/checkout/api/checkout/v2/merchantCheckout/Merchant/</xsl:text>
					<xsl:value-of select="//merchant-id"/>
				</xsl:if>
				<xsl:if test="checkouts/google/@sandbox='no'">
					<xsl:text>https://checkout.google.com/api/checkout/v2/merchantCheckout/Merchant/</xsl:text>
					<xsl:value-of select="//merchant-id"/>
				</xsl:if>
			</xsl:variable>
			<host><xsl:value-of select="$host" /></host>
			<merchant-id><xsl:value-of select="//merchant-id"/></merchant-id>
			<merchant-key><xsl:value-of select="//merchant-key"/></merchant-key>
			<checkout-shopping-cart xmlns="http://checkout.google.com/schema/2">
				<shopping-cart>
					<items>
						<!-- Items -->
						<xsl:apply-templates select="items/item"/>
						<!-- End items -->
					</items>
				</shopping-cart>
				<checkout-flow-support>
					<merchant-checkout-flow-support>
						<!-- Postage -->
						<shipping-methods>
							<flat-rate-shipping name="{//shipping-name}">
								<price currency="{//currency}"><xsl:value-of select="items/@postage" /></price>
							</flat-rate-shipping>
						</shipping-methods>
						<!-- End Postage -->
						<!-- Rounding Policy -->
						<rounding-policy>
							<mode>HALF_UP</mode>
							<rule>TOTAL</rule>
						</rounding-policy>
						<!-- End Rounding Policy -->
					</merchant-checkout-flow-support>
				</checkout-flow-support>
			</checkout-shopping-cart>
		</root>
	</xsl:template>
		
	<xsl:template match="items/item">
		<xsl:element name="item" namespace="http://checkout.google.com/schema/2">
		
			<xsl:element name="item-name" namespace="http://checkout.google.com/schema/2">
				<xsl:value-of select="title"/>
			</xsl:element>
			<xsl:element name="item-description" namespace="http://checkout.google.com/schema/2">
				<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
				<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
				<xsl:for-each select="*[@option]">
					<xsl:value-of select="concat(translate(substring(local-name(), 1, 1), $lowercase, $uppercase), substring(local-name(), 2))"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="concat(translate(substring(., 1, 1), $lowercase, $uppercase), substring(., 2))"/>
					<xsl:if test="position()!= last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:element>
			<xsl:element name="quantity" namespace="http://checkout.google.com/schema/2">
				<xsl:value-of select="@quantity" />
			</xsl:element>
			<xsl:element name="unit-price" namespace="http://checkout.google.com/schema/2">
				<xsl:attribute name="currency">
					<xsl:value-of select="//currency"/>
				</xsl:attribute>
				<xsl:value-of select="@unit-price" />
			</xsl:element>
			<xsl:element name="merchant-item-id" namespace="http://checkout.google.com/schema/2">
				<xsl:value-of select="id" />
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
</xsl:transform>