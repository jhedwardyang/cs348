# Edward Yang, Fall 2014 - CS348
# A01 Q01
# A customer wants to know what parts are available between the sizes of 43 through 47 (including 43 and 47) of brand 'Brand#42'. Write a query to retrieve all such parts.

# Strategy: This query will simply select all the parts with a few restrictions that were given

SELECT * # select all columns
FROM PART # from the table PART
WHERE p_brand = 'Brand#42' # where the brand is 'Brand#42'
AND	p_size BETWEEN 43 AND 47 # where size is between 43 and 47
;