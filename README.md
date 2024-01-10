# Chinook-database-analysis

Analysing the ``CHINOOK Music Store Database`` to answer various questions on sales, customer choices, best tracks etc. We have solved a total of 24 questions from basic to conventional questions and also found out some useful queries.

### Introduction

- Firstly I have downloaded the dataset of Chinook Database named ``Chinook_PostgreSql`` from https://github.com/cwoodruff/ChinookDatabase under Scripts Folder and then to make columns and tables easily be queried by altering them all lowercase, I have made a ``chinook_fixer`` SQL file.
- After Running both files in ``mydb`` , I have cleared the space and start querying fresh for my Data Analytics project.
- For a quick reference, I have also made **ERD(Entity Relationship Diagram)** using ``pgAdmin 4`` GUI client tool.

### Objectives

- The aim is to analyze the Music store and answer various questions accordingly. 
- Goal is to provide insights to the Sales team of Music Store to improve their profits and decide for which tracks to continue and which ones to stop. 
- **Discount Coupons**: Find customers who are loyal and provide them offers. 
- **Customer Segmentation**: Find genres which are liked by most people in each country and state.


### Project Achievements

Many Questions are covered and their detailed Solutions and complete understanding could only be found by running the queries in ``mydb``. However some of the major insights are as follows:

#### Major Insights
- There are most number of tracks(6580) in the ``Music`` playlist.
- ``Jane Peacock`` did the maximum sales($222 approx.) in year 2010.
- Among all genres, ``Rock`` has Maximum tracks(i.e. 835 which is 37.3% of all) sold and Maximum Money($826.65) is spent on it.
- ``USA`` has most customers that is, 13 and also the most number of invoices(91).
- ``O Samba Poconé`` is the song with minimum duration.
- The customers of ``Prague`` city made us the most profit.
- ``Helena Holý`` is the customer who spent the most.
- ``Led Zeppelin`` is the name of artist who have written the most tracks(114) of Rock genre.
- Band of ``Iron Maiden`` has earned the most and its total sales is $138.60 .
- In all given countries, ``Rock`` is the most popular genre(in terms of number of purchases) except for Sweden where Latin is popular.


