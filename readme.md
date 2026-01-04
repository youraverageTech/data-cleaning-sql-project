# Data Cleaning Project

## Overview
This project involves cleaning and preparing a dataset of club member information stored in a CSV file called club_member_info.csv. The data is loaded into a PostgreSQL database table, and SQL queries are used to perform data cleaning operations.

## Problem Statement
 1. remove extra spaces and/or invalid characters.
 2. seperate or combine values as needed.
 3. ensure that certain values are within range.
 4. correct incorrect spelling or inputted data.
 5. adding new or relevant row or column to the new dataset.
 6. check for duplicate entries and remove them.

## step taken in this project
 1. cleaning incorrect spelling from full_name and creating columns first_name and last_name
 2. cleaning age column
 3. create columns street_address, city, and state from column full_address
 4. correcting column membership_date where members there are from 1900's into 2000's
 5. combining all transfromed data into table called transformed_club_member_info
 6. checking and removing duplicate values in data.
 7. converting empty values('', '-', '--', 'n/a', 'na', 'null', 'none') into null.
 8. the cleaned and transformed data is stored in a table named cleaned_club_member_info.
 9. lastly, export cleaned_club_member_info to csv file using python file.