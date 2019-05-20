if(!require(XML)) {install.packages("XML"); library(XML)} #xmlParse() xmlTODataFrame()
if(!require(lubridate)) {install.packages("lubridate"); library(lubridate)} #parse_date_time()
if(!require(tidyr)) {install.packages("tidyr"); library(tidyr)} #separate_rows
if(!require(dplyr)) {install.packages("dplyr"); library(dplyr)} #select() group_by() summarise() arrange() mutate()
if(!require(writexl)) {install.packages("writexl"); library(writexl)} #xl_hyperlink() write_xlsx()

doc <- xmlParse("sample-wp-posts-info-extract.xml")

#grab the overall table of posts, fixing the date
wp_posts <- xmlToDataFrame(nodes = getNodeSet(doc, "//item"), stringsAsFactors=FALSE) %>%
   mutate(date = as_date(parse_date_time(date, "adbYHMSz"))) %>%
   mutate(title = trimws(title))

#create a column for output as linked text in a spreadsheet
class(wp_posts$link) <- "hyperlink"
wp_posts$linked_title <- gsub("\"", "\"\"", wp_posts$title) #escape the double quotes for the Excel hypertext formula
wp_posts$linked_title <- xl_hyperlink(wp_posts$link, name = wp_posts$linked_title)

#order and select the columns for the spreadsheet
wp_posts <- select(wp_posts, linked_title, date, category, tag)


#grab a list of post/category pairs taking into account there can be more than one category for
#each post which will be a comma-separated list in the category column that can be expanded as multiple rows
# -- add on boolean column for whether there were mutliple categories
wp_categories <- wp_posts %>%
   select(category, linked_title) %>%
   mutate(multiple = grepl(",",category)) %>% 
   separate_rows(category, sep = ",") %>%
   arrange(category)


#summarize by category frequency and sort
wp_categories_ranked <- wp_categories %>%
   group_by(category) %>%
   summarise(category_count=n()) %>%
   arrange(desc(category_count))

#grab a list of post/tag pairs taking into account there can be more than one tag for
#each post which will be a comma-separated list in the tag column that can be expanded as multiple rows
wp_tags <- wp_posts %>%
   select(tag, linked_title) %>%
   separate_rows(tag, sep = ",") %>%
   arrange(desc(tag))

#summarize by tag frequency and sort
wp_tags_ranked <- wp_tags %>%
  group_by(tag) %>%
  summarise(tag_count=n()) %>%
  arrange(desc(tag_count))

#write out an Excel file for everything with specified sheet names
write_xlsx(list(Main = wp_posts,
                `Posts by Categories` = wp_categories,
                `Category Count` = wp_categories_ranked,
                `Posts by Tags` = wp_tags,
                `Tag Count` = wp_tags_ranked), path="sample-posts-analyzed.xlsx")
