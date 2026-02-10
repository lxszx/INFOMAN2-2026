# I RECORDED TIMES

Initial Data Insertion Time (100,000 rows): 135.248ms

Query Execution Time (Non-Indexed): 4.953ms 

Query Execution Time (Indexed): 0.676 ms

Single Row Insertion Time (With Index): 10.347 ms

# II ANALYSIS QUESTIONS

1. How did the query execution time change after creating the index? Was it faster or slower? By approximately how much?
- After creating the index, the query execution time became significantly faster. Before the index, the query used a sequential scan and took 4.953ms. After creating the index, the query used an index scan and took 0.676ms, which is approximately 3.977ms faster. 

2. Why do you think the query performance changed as you observed?
- The performance improved because the index allows PostgreSQL to directly locate rows that match the search condition (first_name = 'Rahul') without scanning every row in the table. Instead of checking all 100,000 rows, PostgreSQL uses the index structure to quickly find the matching rows.

3. What is the trade-off of having an index on a table? (Hint: Compare the initial bulk insertion time with the single row insertion time after the index was created).
- The trade-off is that indexes speed up read queries but slow down write operations. During bulk insertion, PostgreSQL had to insert all data quickly, but after creating the index, each new insert must also update the index, which adds overhead. Therefore, inserting a single row with an index takes longer than inserting without an index. 

# III SCREENSHOTS

ROW COUNT VERIFICATION
![](/activity5/images/image1.png)

EXPLAIN ANALYZE OUTPUT FOR NON-INDEXED QUERY
![](/activity5/images/image2.png)
![](/activity5/images/image3.png)

EXPLAIN ANALYZE OUTPUT FOR INDEXED QUERY
![](/activity5/images/image4.png)