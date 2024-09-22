#Load relevant packages
library(rvest)
library(xml2)

#Setting URL website
url <- "https://gvpt.umd.edu/facultystaffgroup/Faculty"
webpage <- read_html(url)


#Extract data
#Name_data
prof_names_data <- webpage |> 
  html_nodes(".views-field-field-position-title a") |>
  html_text()
urls_name_data <- webpage |>
  html_nodes(".views-field-field-position-title a") |>
  html_attr("href")
#Email_data
professor_email <- webpage |>
  html_nodes(".spamspan") |>
  html_text()

clean_prof_email <- gsub("\\[at\\]", "@", professor_email)

#Add NA to the missing email with specific professor
prof_w_missing_email <- "Lund, Neil"

index_missing_email <- which(prof_names_data == prof_w_missing_email)
clean_prof_email <- append(clean_prof_email, NA, after = index_missing_email - 1)


#URL_change
base_url <- "https://gvpt.umd.edu/facultystaffgroup/Faculty"
full_urls <- paste0(base_url, urls_name_data)

#Save the data
data_prof_email <- data.frame(Email = clean_prof_email)
prof_name <- data.frame(
  Name = prof_names_data,
  Profile_URL = full_urls
)

final_data <- data.frame(
  Name = prof_name$Name,
  Email = clean_prof_email
)

#Export data to a csv file

write.csv(final_data, "professors_email_list.csv", row.names = FALSE)