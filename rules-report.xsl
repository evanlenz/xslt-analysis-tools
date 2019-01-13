<!--
  Creates an Excel-friendly CSV file listing a stylesheet's rule attributes.

  If I had Carrot, I'd write this:

    $columns             := document{<mode/><match/><priority/><name/>}/*;
    $header              := `{string-join($columns!('"'||name()||'"'),',')}&#xA;`;
    ^(/)                 := $header, ^row(/*/xsl:template);
    ^row(xsl:template)   := ^cell($columns, .);
    ^cell(*, $context)   := `"{$context/@*[name() eq current()/name()]}"`, ^cell-end(.);
    ^cell-end(*)         := `,`;
    ^cell-end(*[last()]) := `&#xA;`;
-->
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  expand-text="yes">

  <xsl:output method="text" encoding="utf-8"/>

  <xsl:variable name="columns" as="element()+">
    <xsl:variable name="container">
      <mode/>
      <match/>
      <priority/>
      <name/>
    </xsl:variable>
    <xsl:sequence select="$container/*"/>
  </xsl:variable>

  <xsl:variable name="header" as="text()">
    <xsl:text>{string-join($columns!('"'||name()||'"'),',')}&#xA;</xsl:text>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:copy-of select="$header"/>
    <xsl:apply-templates mode="row" select="/*/xsl:template"/>
  </xsl:template>

  <xsl:template mode="row" match="xsl:template">
    <xsl:apply-templates mode="cell" select="$columns">
      <xsl:with-param name="context" select="."/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="cell" match="*">
    <xsl:param name="context"/>
    <xsl:text>"{$context/@*[name() eq current()/name()]}"</xsl:text>
    <xsl:apply-templates mode="cell-end" select="."/>
  </xsl:template>

  <xsl:template mode="cell-end" match="*">,</xsl:template>

  <xsl:template mode="cell-end" match="*[last()]">
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
