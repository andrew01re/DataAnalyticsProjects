#Data Cleaning of tables created in SQL 

### Setting up Environment
  install.packages("tidyverse")
  install.packages("skimr")
  install.packages("janitor")
  install.packages("sqldf")

  library(tidyverse)
  library(skimr)
  library(janitor)
  library(sqldf)

### Importing data
  edu <- read_csv("county_edu.csv")
  demo <- read_csv("county_demographics.csv")
  emp <- read_csv("county_employment.csv")
  housing <- read_csv("county_housing.csv")
  inc <- read_csv("county_income.csv")
  commute <- read_csv("county_commute.csv")
  pop <- read_csv("county_population.csv")
  zill <- read_csv("zillow.csv")

#### Education

  head(edu)
  str(edu)

  # The county name is formatted Name\nCounty
  #There is at least one instance of the county name being >1 word like first\nsecond\nCounty

  edu$county <- gsub("[\n]"," ", edu$county)    #replaces all new lines with spaces


  #reformat avg_SAT_score to an int
  edu$avg_SAT_score <- gsub(",","",edu$avg_SAT_score) %>% 
    as.numeric()

#### Demographics
  head(demo)
  str(demo)

  demo$county <- gsub("[\n]"," ", demo$county)   #replaces all new lines with spaces

  colnames(demo) <- c("county", "0-19", "20-34", "35-44", "45-54", "55-64", "65+") 

  #pivot table to long format  
  demo = tidyr::pivot_longer(data = demo,
                                  cols = colnames(demo)[-1],
                                  names_to = 'age_range',
                                  values_to = 'percent_of_pop',
                                  values_drop_na = FALSE)


#### Employment

  head(emp)
  str(emp)


  emp$county <- gsub("[\n]"," ", emp$county)   #replaces all new lines with spaces

  emp <- emp %>% mutate_if(is.numeric,as.character)
  # remove the commas and $s from all columns (except first two) and convert the columns to numeric
  for (i in 3:length(emp)){
    for (j in 1:nrow(emp[,i])) {
        emp[j,i] <- gsub("[$,.]","",emp[j,i])
    j=j+1 
    }
    i=i+1
  }

  emp[,-1] <- emp[,-1] %>% 
    mutate_if(is.character, as.numeric)


  emp = tidyr::pivot_longer(data = emp,
                                  cols = colnames(emp)[-1:-2],
                                  names_to = 'industry',
                                  values_to = 'job_count',
                                  values_drop_na = FALSE)


#### Housing
  #housing and zillow data will need to be combined into one table. Starting with housing.csv:

  head(housing)
  str(housing)

  #Fix county name format
  housing$county <- gsub(", nc"," County", housing$county) %>%  # removes the suffix of the county
    str_to_title()

  #reformat date to date datatype. Datapoints are monthly, so added 01 as day
  housing$date <- as.Date(paste0(as.character(housing$date), '01'), format='%Y%m%d')

  head(zill)
  str(zill)

  #pivot the data from wide to long
  long_zill = tidyr::pivot_longer(data = zill,
                                  cols = colnames(zill)[-1],
                                  names_to = 'date',
                                  values_to = 'median_home_price',
                                  values_drop_na = FALSE)
  ###Since the data is monthly, and I want to combine with housing data, transform the date to the first of each month
  head(long_zill)
  substr(long_zill$date, 9,10) <- "01"
  long_zill$date <- as.Date(long_zill$date)
  housing_m <- merge(housing, long_zill)
  
  #This merge resulted in at least one NULL value. Need to investigate:
 
  missing_counties <- sqldf('SELECT DISTINCT h.county FROM housing h EXCEPT SELECT DISTINCT m.county FROM housing_m m')
  missing_counties #returned Mcdowell County as the only result

  housing_counties <-sqldf('SELECT DISTINCT county FROM housing')
  zillow_counties <-sqldf('SELECT DISTINCT county FROM long_zill')
  setdiff(housing_counties, zillow_counties)

  # The issue is that the d in McDowell is lowercase in the housing data frame.
  housing$county <- gsub("Mcdowell","McDowell", housing$county)
  print(unique(housing_m$county),na.print="NULL",n=110)
#### Income

  head(inc)
  str(inc)

  inc$county <- gsub("[\n]"," ", inc$county)  #replaces all new lines with spaces
                      

#### Commute 
  head(commute)
  str(commute)

  commute$county <- gsub("[\n]"," ", commute$county)   #replaces all new lines with spaces

  #convert to long format
  commute = tidyr::pivot_longer(data = commute,
                                  cols = colnames(commute)[-1:-2],
                                  names_to = 'method',
                                  values_to = 'percent_of_pop',
                                  values_drop_na = FALSE)
  commute$method <- gsub("method_bike_perc","Bike", commute$method) %>%
    {gsub("method_pub_trans_perc","Public Transit", .)} %>%
    {gsub("method_other_perc","Other", .)} %>%
    {gsub("method_walked_perc","Walk", .)} %>%
    {gsub("wfh_perc","Work From Home", .)} %>%
    {gsub("method_vehicle_perc","Personal Vehicle", .)} 

#### Population Predicitons
  head(pop)
  str(pop)

  pop$county <- paste0(pop$county, " County")
  pop <- filter(pop, county != "State County")


  #separate lat and long from geom_center
  pop <- separate(data = pop, col = geom_center, into = c("lattitude", "longitude"), sep = ", ")
  pop$lattitude <-as.numeric(pop$lattitude)
  pop$longitude <-as.numeric(pop$longitude)

# Export to CSV for upload to Tableau

write.csv(edu, "education.csv", row.names=FALSE)
write.csv(demo, "demographics.csv", row.names=FALSE)
write.csv(emp, "employment.csv", row.names=FALSE)
write.csv(inc, "income.csv", row.names=FALSE)
write.csv(housing_m, "housing.csv", row.names=FALSE)
write.csv(commute, "commute.csv", row.names=FALSE)
write.csv(pop, "population.csv", row.names=FALSE)
