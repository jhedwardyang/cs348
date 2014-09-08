Hard Way Setup for Mac OS X 10.9.4, MySQL
=====

## Installing MySQL
1. Install MySQL, set root password
2. Install some sort of graphical querying environment (I used Sequel Pro)
3. Install JDBC(.jar) to /Users/<user>/Library/Java/Extensions, then symlink to /Users/Library/Java/Extensions
4. Make sure MySQL is running, goto terminal and run via mysql -u root -p

## Setting up DBs
* Chinook
  1. Run Chinook_MySql.sql as a query in your querying environment
* TPCH
  1. Edit DDL Statements.txt, remove PRIMARY from line 75 (ADD PRIMARY KEY (N_REGIONKEY);)
  2. Run 'CREATE DATABASE tpch;'
  3. Run 'USE tpch;'
  4. Run DDL Statements as queries in your querying environment
  5. Either 
    * Copy .tbl files into /usr/local/mysql/data/tpch
    * OR change the MYSQL-Load-Statements.txt file to reflect absolute location
  6. Run the MYSQL-Load-Statements.txt statements