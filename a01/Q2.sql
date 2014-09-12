# Edward Yang, Fall 2014 - CS348
# A01 Q02
# The collection team in our Canadian office wants to know the custkeys, names and phone numbers of all local customers that owe us money so that they can harass these customers over the phone. Write a query that will retrieve all custkeys, names, and phone numbers of customers in the nation of ‘CANADA’ that have an account balance strictly less than zero.

# Strategy: Take customers and find which nation they live in (via JOIN) then check for params.

SELECT c.c_custkey, c.c_name, c.c_phone # select custkeys, names and phone numbers
FROM CUSTOMER c # from customers table (alias 'c')
JOIN NATION n # join the nation table to access the nation rows (alias 'n')
ON c.c_nationkey = n.n_nationkey # match the foreign key
WHERE c_acctbal < 0 # who have an account balance strictly less than 0
AND n.n_name = 'CANADA' # who live in canada
;