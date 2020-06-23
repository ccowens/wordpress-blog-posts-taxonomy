<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                          xmlns:excerpt="http://wordpress.org/export/1.2/excerpt/"
                          xmlns:wp="http://wordpress.org/export/1.2/"
                          xmlns:dc="http://purl.org/dc/elements/1.1/">
<xsl:output method="xml" indent="yes"/>

<!--
Read selected Wordpress XML elements and organize in an XML that will be easy to convert to a dataframe in R
-->


<!-- Set up an index of authors by the login to lookup the display name for listing as an author -->
<xsl:key name="authors" match="wp:author" use="wp:author_login"/>

<xsl:template match="/">
  <posts>
    <xsl:apply-templates/>
  </posts>
</xsl:template>  

<xsl:template match="//item">
    <item>
      <title><xsl:value-of select="title"/></title>
      <date><xsl:value-of select="pubDate"/></date>
      <author><xsl:value-of select="key('authors',dc:creator)/wp:author_display_name"/></author>
      <link><xsl:value-of select="link"/></link>
      <edit_link><xsl:value-of select="guid"/></edit_link>

       <!-- The meta description could be under a postmeta element (All-in-One) -->
      <aio_metadesc>
        <xsl:value-of select="wp:postmeta/wp:meta_key[text()='_aioseop_description']/following-sibling::node()/text()"/>
		  </aio_metadesc>
		  <!-- The meta description could be under a postmeta element (Yoast) -->
      <yoast_metadesc>
        <xsl:value-of select="wp:postmeta/wp:meta_key[text()='_yoast_wpseo_metadesc']/following-sibling::node()/text()"/>
		  </yoast_metadesc>
		  <!-- This excerpt is not necessarily picked up for the meta description, but if it's there it provides a summary of the post anyway --> 
		  <excerpt><xsl:value-of select="excerpt:encoded"/></excerpt>
		  
      <!-- For categories and tags use clunky XSLT 1.0 loops for concatenating strings -->
      <category><xsl:for-each select="category[@domain='category']">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each></category>
      <tags><xsl:for-each select="category[@domain='post_tag']">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each></tags>
      <xsl:apply-templates/>
    </item>  
</xsl:template>

<xsl:template match="@* | text()"/>
  
</xsl:stylesheet>
