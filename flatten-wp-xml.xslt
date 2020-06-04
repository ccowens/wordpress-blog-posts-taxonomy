<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                          xmlns:excerpt="http://wordpress.org/export/1.2/excerpt/">
<xsl:output method="xml" indent="yes"/>

<!--
Read selected Wordpress XML elements and organize in an XML that will be easy to convert to a dataframe in R
-->

<xsl:template match="/">
  <posts>
    <xsl:apply-templates/>
  </posts>
</xsl:template>  

<xsl:template match="//item">
    <item>
      <title><xsl:value-of select="title"/></title>
      <summary><xsl:value-of select="excerpt:encoded"/></summary>
      <date><xsl:value-of select="pubDate"/></date>
      <link><xsl:value-of select="link"/></link>
      <!-- For categories and tags use clunky XSLT 1.0 loops for concatenating strings -->
      <category><xsl:for-each select="category[@domain='category']">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each></category>
      <tag><xsl:for-each select="category[@domain='post_tag']">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each></tag>
      <xsl:apply-templates/>
    </item>  
</xsl:template>
  
<xsl:template match="@* | text()"/>
  
</xsl:stylesheet>
