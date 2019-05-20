# Processing Wordpress Blog Post Taxonomy #

Demo of using XSLT and R to process a download of posts from WP into an Excel workbook for analyzing categories and tags.

1. Manually export (or have someone) export current posts.
XML from WP: `sample-exported-from-wp.xml`
1. Run XSLT script on the exported XML.
Script: `flatten-wp-xml.xslt` 
XML Output: `sample-wp-posts-info-extract.xml`
2. Run R script on XML output to produce analysis by category and tag.
Script: `categories-tags-from-wp-posts.R`
Excel Spreadsheet: `sample-posts-analyzed.xlsx` (worksheets: Main, Posts by Categories, Category Count, Posts by Tags, Tag Count)

## Example Batch File ##

`example-script.bat` is what I use on my system.

