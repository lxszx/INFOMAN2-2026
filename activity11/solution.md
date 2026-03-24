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
    "email": "tamayobench@gmail.com"
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

## INSERT INVENTORY DATA

```
db.inventory.insertMany([
  { name: "Pro Laptop", category: "Electronics", price: 1200, tags: ["work","gaming"], specs: { RAM: 16, CPU: "i7" }, ratings: [5, 4, 5] },
  { name: "Budget Phone", category: "Electronics", price: 200, tags: ["mobile"], specs: { RAM: 4, CPU: "snapdragon" }, ratings: [3, 2] },
  { name: "Mechanical Keyboard", category: "Peripherals", price: 150, tags: ["work","wireless"], specs: { Keys: 104 }, ratings: [5, 5] },
  { name: "Smart Watch", category: "Electronics", price: 350, tags: ["mobile","wireless"], specs: { RAM: 2 }, ratings: [4, 4, 3] },
  { name: "Desk Lamp", category: "Home", price: 45, tags: ["office"], specs: {}, ratings: [5] },
  { name: "Gaming Monitor", category: "Peripherals", price: 450, tags: ["gaming","high-refresh"], specs: { Resolution: "4K", Refresh: "144Hz" }, ratings: [5, 4] },
  { name: "USB-C Hub", category: "Accessories", price: 60, tags: ["work","connectivity"], specs: { Ports: 7 }, ratings: [4, 3, 4] },
  { name: "Ergonomic Mouse", category: "Peripherals", price: 85, tags: ["work","wireless"], specs: { DPI: 4000 }, ratings: [5, 5, 4] },
  { name: "External SSD", category: "Storage", price: 120, tags: ["backup","fast"], specs: { Capacity: "1TB" }, ratings: [5, 4] },
  { name: "Web Cam", category: "Accessories", price: 110, tags: ["work","video"], specs: { Resolution: "1080p" }, ratings: [4, 4] },
  { name: "NC Headphones", category: "Audio", price: 300, tags: ["travel","wireless"], specs: { Battery: "30h" }, ratings: [5, 5, 5] },
  { name: "Smart Bulb", category: "Home", price: 25, tags: ["lighting","wireless"], specs: { Color: "RGB" }, ratings: [3, 4] },
  { name: "Router", category: "Networking", price: 180, tags: ["home","wireless"], specs: { Speed: "AX3000" }, ratings: [4, 5] },
  { name: "Tablet", category: "Electronics", price: 650, tags: ["mobile","creative"], specs: { RAM: 8, Storage: "256GB" }, ratings: [5, 4, 4] },
  { name: "BT Speaker", category: "Audio", price: 90, tags: ["outdoor","wireless"], specs: { Waterproof: "IPX7" }, ratings: [4, 4] }
])
```

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