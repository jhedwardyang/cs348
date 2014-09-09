# Edward Yang, Fall 2014 - CS348
# A01 Q04
# Management wants to know which countries are well represented by our network of suppliers. Write a statement to list the name of each nation that contains at least two different suppliers.
# Now let us suppose that instead of at least two different suppliers, management wants to know the names of each nation that has at least seven different suppliers. In your hard copy solutions explain (describe in less than a paragraph of text, no need to give actual queries) what would be the best way change your original answer, in both RA and SQL, to accommodate for this change in specifications.

SELECT n.n_name # select nation names
FROM NATION n # from table nations
JOIN SUPPLIER s # joining table suppliers
ON s.s_nationkey = n.n_nationkey # match the foreign keys on the nationkey
GROUP BY n.n_nationkey # group the suppliers by nationkey
HAVING COUNT(n.n_nationkey) >= 2 # and there are at least 2 different suppliers
;

# Part 2: Change the >= 2 to >= 7.