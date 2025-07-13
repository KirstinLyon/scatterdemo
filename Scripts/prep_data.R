# AUTHOR:       Kirstin Lyon
# DATE:         2025-07-09
# VERSION:      1.0
# PURPOSE:      Fetch and clean data for Enhanced Geographical Analysis (SADC Countries)
# LICENSE:      MIT License
# DEPENDENCIES: tidyverse, janitor
# INPUT:        Raw PEPFAR EGA data file (CSV or Excel)
# OUTPUT:       Cleaned and filtered CSV file for Mozambique
# NOTES:        Filters only SADC data; assumes standard PEPFAR EGA schema
# USAGE:        Run script in R environment with dependencies installed


# Load required libraries----------------------------------------------------

library(tidyverse)
library(janitor)

# Define constants and parameters--------------------------------------------

DATA <- "Data/Enhanced_Geographical_Analysis.txt"
INDICATORS <- c( "TB_STAT_POS", "TB_STAT")
EXCLUDE_FISCAL_YEAR <- c("2016", "2017", "2018")
SADC_COUNTRY <- c("Angola", 
                  "Botswana",
                  "Comoros", # not in dataset
                  "Democratic Republic of the Congo",
                  "Eswatini", 
                  "Lesotho", 
                  "Madagascar", #not in dataset
                  "Malawi", 
                  "Mauritius", #not in dataset
                  "Mozambique", 
                  "Namibia", 
                  "Seychelles", #not in dataset
                  "South Africa",
                  "Tanzania", 
                  "Zambia", 
                  "Zimbabwe")

EXCLUDE_FISCAL_YEAR <- c("2016", "2017", "2018", "2019", "2020", "2021")


# Function to prepare data for analysis--------------------------------------
#' Process PEPFAR data
#'
#' @param data Enhanced geographical dataset
#'
#' @returns clean dataset
#' @export
#'
#' @examples
#' prep_data(data)

prep_data <- function(data){
    temp <- data |> 
        select(-matches(EXCLUDE_FISCAL_YEAR)) |> 
        pivot_longer(cols = matches("results$"), names_to = "period", values_to = "value") |> 
        separate(period, into = c("fiscal_year", "period_type", "quarter", "misc"), sep = "_", fill = "right") |> 
        select(-c(period_type, misc)) |> 
        mutate(fiscal_year = str_remove(fiscal_year, "^x"),
               period = paste0(fiscal_year, " Q", quarter)
        ) |> 
        select(-c(fiscal_year, quarter)) |> 
        rename(province = sub_national_unit_1,
               district = sub_national_unit_2
        ) 
    
    
    return(temp)
}

# LOAD AND CLEAN DATA ---------------------------------------------------------
my_data <- read_tsv(DATA) |> 
    clean_names() |> 
    filter(indicator %in% INDICATORS,
           country %in% SADC_COUNTRY,
           sub_national_unit_2 != "Data above SNU2"
    ) |>
    mutate(indicator = case_when(indicator == "TB_STAT" ~ paste(indicator, numerator_denominator, sep = "_"),
                                   .default = indicator)
           ) |> 
    select (-c(
        operating_unit, 
        iso3,
        description,
               sub_national_unit_3_uid,
               sub_national_unit_2_uid,
               sub_national_unit_1_uid,
               sub_national_unit_3,
               modality,
               numerator_denominator,
    )) |> 

    group_by(country, indicator, sub_national_unit_1, sub_national_unit_2) |>
    summarise(across(matches("Results$"), ~sum(.x, na.rm = TRUE)), .groups = "drop") |> 
    prep_data() 

write_csv(my_data, "Dataout/clean_pepfar_test_data.csv")
