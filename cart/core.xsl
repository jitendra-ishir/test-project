<?xml version="1.0"?>

<!--
###########################################################################
Easybasket Core XSLT
Nigel Alderton
21st May 2011
www.easybasket.co.uk
###########################################################################

Inputs							Type	Notes
======							=====	======================================================
The current basket.				XML		<basket/>
<xsl:param name="http_query"/>	String	The action to perform eg. "basket=add". Detailed below.
<xsl:param name="http_form"/>	String	An item eg. "title=Belt&colour=red&price=10".

Result
======
A new <basket/>.


http_query				Notes
=========				========
basket=add				Add an item to the basket. If it is already in the basket, increase the quantity.
basket=remove			Remove an item from the basket. If it isn't in the basket, do nothing.
basket=increase			Increase the quantity of an item in the basket by 1. If it isn't in the basket, do nothing.
basket=decrease			Decrease the quantity of an item in the basket by 1. If it isn't in the basket, do nothing.
basket=reset			Remove all items from the basket.


API Changes
===========
2011-05-21 Now using 'basket=add|remove|increase|decrease|reset'.
2011-03-29 Added 'reset=<str>' to the core.xsl API.
2011-03-15 Added item postage, postage1 and postage2.
2011-03-14 Added 'price' as an attribute of item. Look in settings.xml to determine the price fieldname.
2011-03-07 Rewritten to new API.
2011-03-02 Started.

"A result tree fragment could have been the same as a node set (and is in xslt2 drafts) but in xslt 1 there
 is a restriction that stops you making queries, further transforms on the result of a transformation. If
 you use a variable binding element (xsl:variable xsl:param or xsl:with-param with content rather than a
 select expression teh result of executing the content is stored in the variable as a result tree fragment,
 the only thing you can do with that is copy it to the final result using xsl:copy-of or convert it to a
 string (just about any other operation on it) in partiular you can not use an Xpath / step to go $x/a/b/c
 to extract the element nodes out of the variable."
 
 "If you now think the distinction between a node set and a RTF is silly, then you may have a point. The
 spec authors thought treating RTFs the same as source trees might prove difficult and/or prevent
 optimizations, and they decided to play safe: A RTF can only be copied into the result tree or used via
 string conversion in an XPath expression, which means you can't select nodes from them."

	- David Carlisle - http://www.dpawson.co.uk/xsl/sect2/nodeset.html

-->

<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	extension-element-prefixes="exsl">

	<xsl:output method="xml" omit-xml-declaration="yes"/>

<!--###########################################
	EXTERNAL PARAMETERS
	###########################################-->

	<xsl:param name="timestamp"/>
	<xsl:param name="http_query"/>
	<xsl:param name="http_form"/>
	<xsl:param name="settings"/>		<!-- Path to the settings.xml file eg. "c:/foo/settings.xml" -->
	
<!--###########################################
	GLOBAL VARIABLES
	###########################################-->
	
	<xsl:variable name="SETTINGS" select="document(concat('file:///',$settings))/settings"/>

	<xsl:variable name="_form">
		<xsl:call-template name="tokenize">
			<xsl:with-param name="list" select="$http_form"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="RAW" select="exsl:node-set($_form)"/>

	<xsl:variable name="_mapped">
		<xsl:call-template name="map">
			<xsl:with-param name="form" select="$RAW/*"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="CMD" select="normalize-space(substring-after($http_query, '='))"/>
	<xsl:variable name="FORM" select="exsl:node-set($_mapped)/*"/>
	
<!--##########################################
	BASKET ROOT TEMPLATE
	##########################################-->

	<xsl:template match="basket">

		<xsl:variable name="_items">
			<xsl:if test="not($CMD='reset')">
				<xsl:call-template name="parse"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="items" select="exsl:node-set($_items)/item"/>

		<basket version="1.0" timestamp="{$timestamp}">
			<items
			  count = "{count($items)}"
			  quantity = "{sum($items/@quantity)}"
			  subtotal = "{sum($items/@subtotal)}"
			  postage = "{sum($items/@postage)}"
			  total = "{sum($items/@total)}"
			  paypal = "{$SETTINGS/checkouts/paypal/@enable}"
			  google = "{$SETTINGS/checkouts/google/@enable}">
				<xsl:copy-of select="$items"/>
			</items>
			<checkouts>
				<xsl:apply-templates select="$SETTINGS/checkouts/*[@enable='yes']"/>
			</checkouts>
		</basket>
		
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
	PARSE THE INPUTS
	###########################################-->

	<xsl:template name="parse">
	
		<xsl:choose>
		
			<xsl:when test="$CMD='remove' or $CMD='increase' or $CMD='decrease'">
				<xsl:call-template name="edit">
					<xsl:with-param name="form" select="$FORM"/>
				</xsl:call-template>
			</xsl:when>

			<xsl:when test="$CMD='add'">
				<xsl:variable name="matching" select="$FORM[name(.)='quantity']"/>
				<xsl:if test="count($matching)=0">
					<xsl:call-template name="edit">
						<xsl:with-param name="quantity" select="1"/>
						<xsl:with-param name="form" select="$FORM"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="count($matching)=1">
					<xsl:if test="string(number($matching))!='NaN'">		<!-- is-numeric -->
						<xsl:call-template name="edit">
							<xsl:with-param name="quantity" select="$matching"/>
							<xsl:with-param name="form" select="$FORM[name(.)!='quantity']"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="string(number($matching))='NaN'">		<!-- not-numeric -->
						<xsl:copy-of select="items/*"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="count($matching) &gt; 1">
					<xsl:copy-of select="items/*"/>
				</xsl:if>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:copy-of select="items/*"/>
			</xsl:otherwise>
					
		</xsl:choose>
	
	</xsl:template>
					

	<!--###########################################
	EDIT THE BASKET
	###########################################	-->
	
	<xsl:template name="edit">
	
		<xsl:param name="quantity"/>
		<xsl:param name="form"/>
		
		<xsl:variable name="index">					<!-- Index of the first matching item in the basket, or zero if there was no match. -->
			<xsl:call-template name="first_match">
				<xsl:with-param name="needle" select="$form"/>
				<xsl:with-param name="haystack" select="items/*"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="in-basket">				<!-- Quantity of the matching item in the basket, or zero if there was no match. -->
			<xsl:choose>
				<xsl:when test="$index=0">0</xsl:when>
				<xsl:otherwise><xsl:value-of select="items/*[position()=$index]/@quantity"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="qty">
			<xsl:choose>
				<xsl:when test="$CMD='add'"><xsl:value-of select="$in-basket + $quantity"/></xsl:when>
				<xsl:when test="$CMD='remove'"><xsl:value-of select="0"/></xsl:when>
				<xsl:when test="$CMD='increase'"><xsl:value-of select="$in-basket + 1"/></xsl:when>
				<xsl:when test="$CMD='decrease'"><xsl:value-of select="$in-basket - 1"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="postage">
			<xsl:variable name="post" select="$SETTINGS/form/postage"/>
			<xsl:variable name="each">
				<xsl:call-template name="zero">
					<xsl:with-param name="field" select="$form[local-name()=$post/per-item]"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="first">
				<xsl:call-template name="zero">										
					<xsl:with-param name="field" select="$form[local-name()=$post/first-item]"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="extra">
				<xsl:call-template name="zero">
					<xsl:with-param name="field" select="$form[local-name()=$post/extra-items]"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="($each * $qty) + ($first) + ($extra * ($qty - 1))"/>
		</xsl:variable>
		
		<xsl:variable name="price" select="$form[local-name()='price']"/>
	
		<xsl:variable name="item">
			<item
			  unit-price="{$price}"
			  quantity="{$qty}"
			  subtotal="{$price * $qty}"
			  postage="{$postage}"
			  total="{$postage + ($price * $qty)}">
				<xsl:copy-of select="$form"/>
			</item>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$qty &lt;= 0 and $index=0">
				<xsl:copy-of select="items/*"/>
			</xsl:when>
			<xsl:when test="$qty &lt;= 0 and $index!=0">
				<xsl:copy-of select="items/*[position()!=$index]"/>
			</xsl:when>
			<xsl:when test="$qty &gt; 0 and $index=0">
				
					<xsl:copy-of select="items/*"/>
					<xsl:copy-of select="$item"/>
				
			</xsl:when>
			<xsl:when test="$qty &gt; 0 and $index!=0">
				
					<xsl:copy-of select="items/*[position() &lt; $index]"/>
					<xsl:copy-of select="$item"/>
					<xsl:copy-of select="items/*[position() &gt; $index]"/>
				
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>

<!--	###########################################
	###########################################	-->
	
	<xsl:template name="zero">
	
		<xsl:param name="field"/>
		
		<xsl:if test="$field">
			<xsl:value-of select="$field"/>
		</xsl:if>
		
		<xsl:if test="not($field)">
			<xsl:value-of select="'0'"/>
		</xsl:if>
		
	</xsl:template>

	
<!--	###########################################
	TEMPLATE (Recursive)
		Find the first element in $haystack which has children that are the same as the elements of $needle.
	RESULT
		<int>	The index of the matching element in $haystack. Zero means not found.
	###########################################	-->
	
	<xsl:template name="first_match">
	
		<xsl:param name="position" select="1"/>
		<xsl:param name="needle"/>
		<xsl:param name="haystack"/>

		<xsl:choose>
		
			<xsl:when test="count($haystack)=0">
				<xsl:value-of select="0"/>
			</xsl:when>
			
			<xsl:otherwise>
			
				<xsl:variable name="flg">
					<xsl:call-template name="is_equal">
						<xsl:with-param name="set1" select="$needle"/>
						<xsl:with-param name="set2" select="$haystack[1]/*"/>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$flg=1">
						<xsl:value-of select="$position"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="first_match">
							<xsl:with-param name="position" select="$position + 1"/>
							<xsl:with-param name="needle" select="$needle"/>
							<xsl:with-param name="haystack" select="$haystack[position() > 1]"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	
<!--###########################################
	MAP THE FORM FIELDS
	###########################################-->

	<xsl:template name="map">
	
		<xsl:param name="form"/>
		
		<xsl:for-each select="$form">
		
			<xsl:variable name="t" select="name(.)"/>
			<xsl:variable name="x" select="$SETTINGS/form/maps/*[text()=$t]"/>
			
			<xsl:variable name="tagname">
				<xsl:if test="$x">
					<xsl:value-of select="local-name($x)"/>
				</xsl:if>
				<xsl:if test="not($x)">
					<xsl:value-of select="local-name()"/>
				</xsl:if>
			</xsl:variable>
			
			<xsl:element name="{$tagname}">
				<xsl:if test="$SETTINGS/form/options/*[text() = $t]">
					<xsl:attribute name="option">yes</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="."/>
			</xsl:element>
		
		</xsl:for-each>

	</xsl:template>
	
<!--	###########################################
	TEMPLATE
		Are two node-sets the same?
	RESULT
		1	Yes
		0	No
	###########################################	-->
	
	<xsl:template name="is_equal">

		<xsl:param name="set1"/>
		<xsl:param name="set2"/>

		<xsl:variable name="_matching">
			<xsl:for-each select="$set1">
				<xsl:variable name="name" select="local-name()"/>
				<xsl:variable name="value" select="current()"/>
				<xsl:for-each select="$set2">
					<xsl:if test=". = $value and local-name() = $name">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:variable name="matching" select="exsl:node-set($_matching)/*"/>
		
		<xsl:choose>
			<xsl:when test="count($matching)=count($set1) and count($set1)=count($set2)">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
<!--	###########################################
	TEMPLATE (Recursive)
		Tokenize.
	RESULT
		A result-tree-fragment comprised of <name>value</name> elements. Any input not of the form 'name=value' is ignored.
		Note: In order for the result to be iterable, it must be turned from a 'result-tree-fragment' into an XSLT-1.0 node-set. This is done elsewhere.
	###########################################	-->
	
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