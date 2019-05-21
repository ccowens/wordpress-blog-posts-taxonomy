# Processing Wordpress Blog Post Taxonomy #
Demo of using XSLT and R to process a download of posts from WP into an Excel workbook for analyzing categories and tags.
## The Basic Idea ##
Use XSLT on the Wordpress XML to select what you want and flatten the structure so it's easier to bring in as a table into R. Combine multiple child items into one item separated by commas (for XSLT 1.0 compatibility use clunky version of XSLT 2.0 `string-join()`). Then bring it into R using the tidyr package to unpack the comma-separated items into multiple rows. For example:

Color | Fruit
------|-------------
green | pear,apple |

becomes:

Color | Fruit
------|-------------
green | pear |
green | apple |

Then, use R to make various summary, etc. tables that can be saved as worksheets in one workbook for convenience.
## The Steps ##

1. Manually export (or have someone export) current posts from the WP dashboard.
![](https://i.imgur.com/RE5XCaL.png)<br>
XML from WP: `sample-exported-from-wp.xml`
1. Run an XSLT script on the exported XML.<br>
Script: `flatten-wp-xml.xslt` <br>
XML Output: `sample-wp-posts-info-extract.xml`
2. Run an R script on XML output to produce analysis by category and tag.<br>
Script: `categories-tags-from-wp-posts.R`<br>
Excel Spreadsheet: `sample-posts-analyzed.xlsx` (worksheets: Main, Posts by Categories, Category Count, Posts by Tags, Tag Count)

## Example Batch File ##

`example-script.bat` is what I use on my system.

