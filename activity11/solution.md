# Activity 11: SQL to MongoDB & Advanced Querying - Answer Template

## Part 1: Relational to Document Modeling

### 1. Proposed JSON Schema
```json
{
  "_id": ObjectId(),
  "title": "Introduction to MongoDB",
  "body": "MongoDB is a NoSQL database...",
  "created_at": ISODate("2026-03-24T10:00:00Z"),
  "author": {
    "id": 1,
    "username": "devbench",
    "email": "bench@example.com"
  },
  "tags": [
    { "name": "javascript" },
    { "name": "nosql" }
  ]
}
```

### 2. Strategic Choices
*   **Tags:** Embedded
*   **Author:** Embedded

### 3. Justification
> Embedding tags improves read efficiency for post queries since they are short and frequently retrieved together with postings. Embedding author information eliminates the need for additional lookups when showing post details, as user data changes often, improving query efficiency with less duplication risk.

---

## Part 2: Querying with MQL Operators

### 1. Price Range
*Find all items priced between $100 and $500 (inclusive).*
```javascript
db.inventory.find({ price: { $gte: 100, $lte: 500 } })
```

### 2. Category Match
*Find all items that are in either the "Peripherals" or "Home" categories.*
```javascript
db.inventory.find({ category: { $in: ["Peripherals", "Home"] } })
```

### 3. Tag Power
*Find all items that have **both** the "work" AND "wireless" tags.*
```javascript
db.inventory.find({ tags: { $all: ["work", "wireless"] } })
```

### 4. Nested Check
*Find all items where the `specs.ram` is greater than 8GB.*
```javascript
db.inventory.find({ "specs.RAM": { $gt: 8 } })
```

### 5. High Ratings
*Find all items that have at least one `5` in their `ratings` array.*
```javascript
db.inventory.find({ ratings: 5 })
```

---

## Screenshots
> Attach your screenshots here showing the results of your queries in the terminal.