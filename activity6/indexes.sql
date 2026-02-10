CREATE INDEX idx_posts_author_date
ON posts (author_id, date DESC);

CREATE INDEX idx_posts_title
ON posts (title);

CREATE INDEX idx_posts_date
ON posts (date);