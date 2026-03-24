# Activity 10 Solution


## Part 1: Quick Mapping (Postgres -> MongoDB)

| PostgreSQL                                  | MongoDB Equivalent                                             |
| ------------------------------------------- | -------------------------------------------------------------- |
| `INSERT INTO posts ...`                     | `db.posts.insertOne({...})`                                    |
| `SELECT * FROM posts WHERE title='...'`     | `db.posts.find({ title: '...' })`                              |
| `UPDATE posts SET title='...' WHERE id=...` | `db.posts.updateOne({ _id: ... }, { $set: { title: '...' } })` |
| `DELETE FROM posts WHERE id=...`            | `db.posts.deleteOne({ _id: ... })`                             |


## Part 2: Hands-on CRUD in MongoDB

Write the commands you executed and paste screenshots from Mongo shell after each command/block.

### 2.1 Setup

Commands:

```javascript
use devstream_db
db.posts.drop()

db.posts.insertOne({
  _id: 1,
  title: "Mastering MongoDB for Postgres Devs",
  content: "Intro guide",
  author_username: "db_wizard",
  category: "database",
  views: 10
})
```
Screenshot(s):

![](/activity10/images/image1.png)

### 2.2 Create

Commands:

```javascript
db.posts.insertOne({
  _id: 2,
  title: "Learning NoSQL Fast",
  content: "Quick tips for beginners",
  author_username: "bench_user",
  category: "technology",
  views: 5
})
```

Screenshot(s):
![](/activity10/images/image2.png)

### 2.3 Read

Commands:

```javascript
// Find all posts
db.posts.find()

// Find post with _id: 1
db.posts.find({ _id: 1 })

// Show only title and author_username (exclude _id)
db.posts.find({}, { title: 1, author_username: 1, _id: 0 })
```

Screennshot(s):

![](/activity10/images/image3.png)

![](/activity10/images/image4.png)

![](/activity10/images/image5.png)


### 2.4 Update

Commands:

```javascript
// Change title of _id: 1
db.posts.updateOne(
  { _id: 1 },
  { $set: { title: "MongoDB CRUD Basics" } }
)

// Increase views by 1
db.posts.updateOne(
  { _id: 1 },
  { $inc: { views: 1 } }
)

// Add status: "published" to all posts
db.posts.updateMany(
  {},
  { $set: { status: "published" } }
)
```
Screenshot(s):

![](/activity10/images/image6.png)

![](/activity10/images/image7.png)

![](/activity10/images/image8.png)


### 2.5 Delete

Commands:

```javascript
db.posts.deleteOne({ _id: 2 })
```

Screenshot(s):
![](/activity10/images/image9.png)

## Part 3: Reflection (3-4 sentences)

1. One thing that feels easier in MongoDB CRUD:

MongoDB feels easier when inserting and updating data because it uses flexible JSON-like documents, so there is no need to strictly define a schema beforehand. It is also simple to modify fields using operators like $set and $inc.

2. One thing that was clearer in PostgreSQL CRUD:

PostgreSQL is clearer when working with structured data because the schema enforces consistency and relationships. SQL queries are also more readable for complex filtering and joins compared to MongoDB queries.