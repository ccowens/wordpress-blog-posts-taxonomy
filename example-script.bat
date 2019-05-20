java -cp "C:\Program Files\Saxon\saxon9he.jar"  net.sf.saxon.Transform -t -s:sample-exported-from-wp.xml -xsl:flatten-wp-xml.xslt -o:sample-wp-posts-info-extract.xml
"c:\Program Files\R\R-3.5.3\bin\RScript" categories-tags-from-wp-posts.R
