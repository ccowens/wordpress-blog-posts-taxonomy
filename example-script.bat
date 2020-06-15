java -cp "C:\Program Files\Saxon\saxon9he.jar"  net.sf.saxon.Transform -t -s:exported-from-wp.xml -xsl:flatten-wp-xml.xslt -o:extracted-info.xml
"c:\Program Files\R\R-4.0.0\bin\RScript" categories-tags-from-wp-posts.R
pause
