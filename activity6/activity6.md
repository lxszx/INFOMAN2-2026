# I ANALYSIS QUESTIONS

1. This query is not S-ARGable. What does that mean in the context of this query? Why can't the query planner use a simple index on the `date` column effectively?

- The query is not SARGable because it applies functions (EXTRACT) to the data column. This prevents the query planner from using a standard index efficiently, forcing a full table scan. 

- SARGable version (optimized):
SELECT id, title
FROM posts
WHERE date >= '2015-01-01'
    AND date <  '2015-02-01';

- Index:
CREATE INDEX idx_posts_date
ON posts (date);


## Scenario 1 — Slow Author Profile Page

### Query (Before Optimization)

EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE author_id = 1
ORDER BY date DESC;

![](/activity6/images/image1.png)

CREATE INDEX idx_posts_author_date
ON posts (author_id, date DESC);

EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE author_id = 1
ORDER BY date DESC;

![](/activity6/images/image2.png)


## Scenario 2 — Unsearch Blog

### Query (Before Optimization)

EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE title ILIKE '%database%';

![](/activity6/images/image3.png)

CREATE INDEX idx_posts_title
ON posts (title);

EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE title ILIKE '%database%';

![](/activity6/images/image4.png)

EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE title ILIKE 'database%';

![](/activity6/images/image5.png)


## Scenario 3 — Monthly Performance Report

### Query (Before Optimization)

EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE EXTRACT(YEAR FROM date) = 2015
  AND EXTRACT(MONTH FROM date) = 1;

![](/activity6/images/image6.png)

CREATE INDEX idx_posts_date
ON posts (date);

EXPLAIN ANALYZE
SELECT id, title
FROM posts
WHERE date >= '2015-01-01'
  AND date <  '2015-02-01';

![](/activity6/images/image7.png)