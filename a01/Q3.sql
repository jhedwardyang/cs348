# Edward Yang, Fall 2014 - CS348
# A01 Q03
# Management wants to improve client relations, with both customers and suppliers, who trust us the most. They want a list of all names and phone numbers belonging to either customers that have an account balance strictly greater than 9975 or suppliers that have an account balance strictly greater than 9500. Write a single statement to retrieve these required names and phone numbers.

# Strategy: Since the information we are requesting is the same with just different cases, UNION the two simple solutions together. Also remember to alias the column names.

SELECT c_name name, c_phone phone # select c_name and c_phone, then rename them as name/phone respectively
FROM CUSTOMER # from the customer table
WHERE c_acctbal > 9975 # if their balance is strictly greator than 9975
UNION ALL # and group them together with
SELECT s_name name, s_phone phone # select s_name and s_phone, then rename them as name/phone respectively
FROM SUPPLIER # from the supplier table
WHERE s_acctbal > 9500 # if their balance strictly greator than 9950
;