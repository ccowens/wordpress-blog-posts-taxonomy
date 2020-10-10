java -cp "C:\Program Files\Saxon\saxon9he.jar"  net.sf.saxon.Transform -t -s:data/exported-from-wp.xml -xsl:flatten-wp-xml.xslt -o:data/extracted-info.xml
"c:\Program Files\R\R-4.0.2\bin\RScript" categories-tags-from-wp-posts.R
pause
