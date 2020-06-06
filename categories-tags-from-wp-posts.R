## Take an XML file containing metadata about blog posts that's been organized by 
## an XSLT script to be easier to load as a dataframe into R. Produce useful
## information about the blog posts, primarily taxonomic, in an Ecel spreadsheet

# Preliminaries -----------------------------------------------------------

#make sure there is a designated mirror for when this is run as a script 
local({r <- getOption("repos")
r["CRAN"] <- "https://cloud.r-project.org/" 
options(repos=r)
})

#packages required with functions used from those packages
if(!require(XML)) {install.packages("XML"); library(XML)} #xmlParse() xmlTODataFrame() parseURI()
if(!require(lubridate)) {install.packages("lubridate"); library(lubridate)} #parse_date_time()
if(!require(tidyr)) {install.packages("tidyr"); library(tidyr)} #separate_rows
if(!require(dplyr)) {install.packages("dplyr"); library(dplyr)} #select() group_by() summarise() arrange() mutate()
if(!require(writexl)) {install.packages("writexl"); library(writexl)} #xl_hyperlink() write_xlsx()

#start
doc <- xmlParse("sample-wp-posts-info-extract.xml")

# Main worksheet listing all posts sorted by date -------------------------

#grab the overall table of post metadata, fixing the date
wp_posts <- xmlToDataFrame(nodes = getNodeSet(doc, "//item"), stringsAsFactors=FALSE) %>%
   mutate(date = as_date(parse_date_time(date, "adbYHMSz"))) %>%
   mutate(title = trimws(title)) 

#add a column just showing the path only
wp_posts$url_path <- sapply(wp_posts$link, function(x) parseURI(x)$path)

#create a column for output as linked text (URL, title) when the spreadsheet is
#written
class(wp_posts$link) <- "hyperlink"
wp_posts$linked_title <- gsub("\"", "\"\"", wp_posts$title) #escape the double quotes for the Excel hypertext formula
wp_posts$linked_title <- xl_hyperlink(wp_posts$link, name = wp_posts$linked_title)

#order the columns and sort
wp_posts <- select(wp_posts, linked_title, date, yoast_metadesc, excerpt, category, tags, url_path) %>% 
   arrange(desc(date))

# Posts by Categories worksheet --------------------------------------------

wp_categories <- wp_posts %>%
   select(category, linked_title) %>%
   #if there are multiple categories separated by commas for the post flag it
   mutate(multiple = grepl(",",category)) %>% 
   #if there are multiple categories for the post flag split up into multiple
   #sharing the same title
   separate_rows(category, sep = ",") %>%
   #sort by category
   arrange(category)

# Category Count worksheet --------------------------------------------

wp_categories_ranked <- wp_categories %>%
   group_by(category) %>%
   #summarize categories by count like a pivot table
   summarise(category_count=n()) %>%
   #sort categories by count highest first
   arrange(desc(category_count))


# Posts by Tags worksheet --------------------------------------------------

#grab a list of post/tag pairs taking into account there can be more than one tag for
#each post which will be a comma-separated list in the tag column that can be expanded as multiple rows
wp_tags <- wp_posts %>%
   select(tags, linked_title) %>%
   #split up by tags into multiple rows sharing the same title
   separate_rows(tags, sep = ",") %>%
   #sort by tag used
   arrange(desc(tags))

# Tag Count worksheet -----------------------------------------------------

wp_tags_ranked <- wp_tags %>%
   group_by(tags) %>%
   #summarize tags by count like a pivot table
   summarise(tag_count=n()) %>%
   #sort tags by count highest first
   arrange(desc(tag_count))

# Write out an Excel file containing all the sheets -----------------------

write_xlsx(list(Main = wp_posts,
                `Posts by Categories` = wp_categories,
                `Category Count` = wp_categories_ranked,
                `Posts by Tags` = wp_tags,
                `Tag Count` = wp_tags_ranked), path="sample-posts-analyzed.xlsx")

