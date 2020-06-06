# Processing Wordpress Blog Post Taxonomy #
This is a demo of using XSLT and R to process a download of posts from WP into an Excel workbook for analyzing categories and tags (mostly).

## The Basic Idea ##
Use XSLT on the Wordpress XML to select what you want and flatten the structure so it's easier to bring in as a table into R. Combine multiple child items into one item separated by commas (for XSLT 1.0 compatibility, use clunky for-loop instead of XSLT 2.0's `string-join()`). Then, bring it into R, using the tidyr package to unpack the comma-separated items into multiple rows. For example:

Color | Fruit
------|-------------
green | pear,apple |

becomes:

Color | Fruit
------|-------------
green | pear |
green | apple |

Finally, use R to make various summary, etc. tables that can be saved as worksheets in one workbook for convenience.
## The Steps ##

1. Manually export (or have someone export) current posts from the WP dashboard.
![](https://i.imgur.com/WySF0oS.png)<br>
XML from WP: `sample-exported-from-wp.xml`
1. Run an XSLT script on the exported XML.<br>
Script: `flatten-wp-xml.xslt` <br>
XML Output: `sample-wp-posts-info-extract.xml`
2. Run an R script on XML output to produce Excel output with analysis by category and tag and individual blog post titles hyperlinked.<br>
Script: `categories-tags-from-wp-posts.R`<br>
Excel Spreadsheet: `sample-posts-analyzed.xlsx` (worksheets: Main, Posts by Categories, Category Count, Posts by Tags, Tag Count)

## Example Batch File ##

`example-script.bat` is what I use on my system.

### XSLT ###

I use the [free open source version of Saxon](http://saxon.sourceforge.net/) for XSLT processing because that's what I'm used to, but you could also use something like [`xsltproc`](http://xmlsoft.org/XSLT/xsltproc.html) instead. The XSLT is version 1.0, so you have many options.

### R ###

For this example batch file, I use the command-line script runner from the free open source [R statistical computing language](https://www.r-project.org/), but usually I just use the [free open source version of RStudio](https://www.rstudio.com/products/RStudio/#Desktop) for working with R interactively.

## The Result

### Sheets within the Output Excel File

- Main
- Posts by Category [includes flag for multiple category assignment]
- Category Count
- Posts by Tag
- Tag Count

### Columns in the Main Sheet

- Post title
- Date published
- Yoast SEO meta description
- Excerpt
- Categories
- Tags
- Path part of the URL

## Notes

There's no standard way to set what should be the meta description for a post in Wordpress that would be findable in the XML export file. SEO plug-ins have there own ways. In the example I've used the excerpt:extended tag, because it's based on a standard optional feature. I've also changed the script so it pulls in any Yoast SEO meta description since that's in the sample. 

I know I could use the list of post URLs and just scrape that actual meta description tag, but that would require a lot of banging away at the site that I would prefer to avoid. Also it assumes a meta description always exists. 

