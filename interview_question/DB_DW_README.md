# Database & Data Warehouse — Interview Question Bank

A comprehensive, structured reference covering all major Database and Data Warehouse topics relevant to Data Engineering roles. Each question includes the concept explained in plain language, a real-world analogy, and a key takeaway for interviews.

---

## Table of Contents

1. [Relational Database Fundamentals](#1-relational-database-fundamentals)
2. [SQL & Query Optimisation](#2-sql--query-optimisation)
3. [Indexing & Storage Internals](#3-indexing--storage-internals)
4. [Transactions, ACID & Isolation](#4-transactions-acid--isolation)
5. [NoSQL & Polyglot Persistence](#5-nosql--polyglot-persistence)
6. [Data Warehouse Design](#6-data-warehouse-design)
7. [Dimensional Modelling](#7-dimensional-modelling)
8. [OLAP, Partitioning & Performance](#8-olap-partitioning--performance)
9. [Modern Cloud Data Platforms](#9-modern-cloud-data-platforms)
10. [ELT/ETL & Pipeline Patterns](#10-eltetl--pipeline-patterns)

---

## Difficulty Legend

| Badge | Level |
|-------|-------|
| 🟢 | Beginner |
| 🟡 | Intermediate |
| 🔴 | Advanced |

---

## 1. Relational Database Fundamentals

### 🟢 Q1 — What is normalisation and why is it both a benefit and a problem in data engineering?

**Answer:**
Normalisation means organising a database to eliminate duplicate data and keep information in one place. For example, instead of storing a customer's city in every order row, you store it once in a customers table and reference it. This keeps data consistent and saves storage. The problem is that when you need to answer a question — like "show me all orders with customer city" — you have to JOIN multiple tables together. Joins are expensive on large datasets. In data warehouses where you run heavy analytical queries, too much normalisation makes queries painfully slow. That's why data warehouses often deliberately denormalise: store some duplicate data to avoid expensive joins at query time.

> **Analogy:** Normalisation is like a tidy library where each book is in exactly one place. Great for keeping things organised, but if you need three books at once, you're running around the library. Denormalisation is pre-stacking the books you always use together on your desk.

> **Remember:** Normalisation = less duplication, more joins. Denormalisation = some duplication, faster queries. OLTP prefers normal, OLAP prefers denormalised.

---

### 🟢 Q2 — What is the difference between primary keys, foreign keys, and surrogate keys? Why do warehouses prefer surrogate keys?

**Answer:**
A primary key uniquely identifies every row in a table — no two rows can have the same value. A foreign key is a column that references the primary key of another table, creating a link between tables. A natural key is a real-world identifier like an email address or social security number. A surrogate key is a made-up ID (usually an auto-incrementing number) that has no business meaning. Data warehouses prefer surrogate keys because natural keys from source systems can change (a customer changes their email), can be null, or can collide across different source systems. Surrogate keys give the warehouse full control over identity and make it easy to track historical changes.

> **Analogy:** A natural key is like using your email as a library card number — works until you change your email. A surrogate key is like a barcode the library assigns you — it never changes regardless of your personal details.

> **Remember:** Natural keys change. Surrogate keys are stable, warehouse-controlled IDs. Always use surrogate keys in dimension tables.

---

### 🟡 Q3 — What are the types of table relationships and how do they map to data warehouse patterns?

**Answer:**
One-to-one: one row in table A matches exactly one row in table B — like a person and their passport. One-to-many: one row in A matches many rows in B — like one customer and many orders. Many-to-many: many rows in A match many rows in B — like students and courses (one student takes many courses, one course has many students). Many-to-many is the tricky one: you cannot model it with just two tables. You need a bridge or junction table in between. In a data warehouse, this shows up as bridge dimension tables — for example, a customer who belongs to multiple market segments needs a bridge table between the customer dimension and the segment dimension.

> **Analogy:** One-to-many is a parent with children. Many-to-many is a group of friends who all share multiple group chats — you need a separate membership list to track who is in which group.

> **Remember:** Many-to-many always needs a bridge table. In a warehouse this prevents double-counting of facts.

---

### 🟡 Q4 — What is referential integrity and what are the tradeoffs of enforcing it in a warehouse vs pipeline?

**Answer:**
Referential integrity means the database guarantees that a foreign key always points to a real existing row. If an order references customer ID 999 and customer 999 doesn't exist, the database rejects it. This is a powerful safety net in transactional systems. In data warehouses, referential integrity is usually disabled. Why? Because bulk loading millions of rows with FK constraint checking is very slow — the database checks every single row. Also, source data often arrives out of order: orders might load before the customer record loads. Warehouses handle this at the pipeline level instead — data quality checks, late-arriving dimension handling, and audit reports catch mismatches.

> **Analogy:** Enforcing FK at the database level is like a bouncer checking every person's ID at a stadium gate. Efficient for a bar, but for a sold-out stadium it creates a traffic jam. The stadium pre-validates ticket lists offline instead.

> **Remember:** Warehouses disable FK constraints for load performance. Enforce data quality in the pipeline instead.

---

## 2. SQL & Query Optimisation

### 🟢 Q5 — Explain the logical order of SQL clause execution and why it matters when writing queries.

**Answer:**
SQL clauses execute in this order: FROM (get the table) → JOIN (combine tables) → WHERE (filter rows) → GROUP BY (group them) → HAVING (filter groups) → SELECT (choose columns) → ORDER BY (sort) → LIMIT (cut results). This order is not the same as the order you write them in. Two common mistakes that come from not knowing this: (1) Using a column alias from SELECT in a WHERE clause — it fails because WHERE runs before SELECT. (2) Wondering why you can't filter on a window function result in WHERE — window functions are computed at SELECT time, after WHERE has already run. Knowing this order helps you write correct queries and understand error messages.

> **Analogy:** Think of it like making a sandwich: first you get the bread (FROM), add ingredients (JOIN), remove what you don't want (WHERE), cut it in sections (GROUP BY), then describe what you made (SELECT).

> **Remember:** FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT. WHERE runs before SELECT, so you cannot use SELECT aliases in WHERE.

---

### 🟡 Q6 — What is the difference between a correlated subquery and a non-correlated subquery, and why can correlated subqueries be a performance hazard?

**Answer:**
A non-correlated subquery runs once and its result is used by the outer query — it is independent. A correlated subquery references a column from the outer query, which means it must re-run for every single row of the outer query. If the outer table has 10 million rows, the subquery runs 10 million times. This is almost always catastrophically slow. The fix is to rewrite correlated subqueries as JOINs or as window functions — for example, finding the most recent order per customer is a classic correlated subquery pattern that rewrites perfectly as `ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC)`.

> **Analogy:** A non-correlated subquery is like looking up a word in a dictionary once and using the definition all day. A correlated subquery is like looking it up fresh every time you say the word.

> **Remember:** Correlated subquery = re-runs per row = danger on large tables. Rewrite with window functions or JOINs.

---

### 🟡 Q7 — Explain window functions (ROW_NUMBER, RANK, LAG, LEAD, SUM OVER). Why are they better than self-joins?

**Answer:**
Window functions perform calculations across a set of rows related to the current row — without collapsing those rows into a group like GROUP BY does. `ROW_NUMBER` assigns a unique sequential number per partition. `RANK` is like ROW_NUMBER but ties get the same rank. `LAG` looks at the previous row's value, `LEAD` looks at the next row's value — both crucial for time-series comparisons. `SUM OVER` computes a running total. Before window functions, engineers wrote self-joins (joining the table to itself) to get previous row values — which is slow, complex, and hard to read. Window functions do all of this in a single table pass, making them both faster and cleaner.

> **Analogy:** Window functions are like a moving spotlight that shines on the rows around each row as you walk through the table — without needing to bring the whole table back together.

> **Remember:** Window functions never collapse rows. They're the right tool for rankings, running totals, and row-to-row comparisons.

---

### 🟡 Q8 — What is a query execution plan and what signals tell you a query will be slow?

**Answer:**
A query execution plan (seen with `EXPLAIN` or `EXPLAIN ANALYZE`) shows the step-by-step strategy the database will use to answer your query: which indexes to use, how tables are joined, in what order. Red flags that signal slow performance:
- **Sequential Scan** on a large table — the database reads every row instead of using an index
- **Nested Loop Join** between two large tables — O(n×m) comparisons
- **Row estimate vs actual row count mismatch** — stale statistics mislead the planner
- **Sort operations** on large datasets — expensive, may spill to disk

The cost numbers in the plan are estimates — always use `EXPLAIN ANALYZE` on real data to see actual timings.

> **Analogy:** A query plan is like a GPS route. A sequential scan is like the GPS routing you through every street in the city instead of taking the highway.

> **Remember:** Look for sequential scans on big tables, nested loops on large joins, and mismatched row estimates — these are the three most common culprits.

---

### 🔴 Q9 — Explain the difference between EXISTS, IN, and JOIN for filtering. When does each perform differently?

**Answer:**
`IN` materialises a list of values and checks membership — fast for small lists, but problematic when the subquery returns NULLs (any comparison with NULL is unknown, so the IN check can silently exclude rows). `EXISTS` checks if at least one row matches and short-circuits as soon as it finds the first match — efficient for large subqueries because it doesn't materialise the full result. A `JOIN` can return duplicate rows if the right side has multiple matches per left row — you'd need DISTINCT or GROUP BY to fix that. General rule: use EXISTS for "does a related record exist?" checks, IN for small static lists, and JOIN when you need columns from both tables.

> **Analogy:** IN is like checking if your name is on a printed list. EXISTS is like asking a guard "is anyone named X inside?" — the guard stops looking after finding the first match.

> **Remember:** EXISTS short-circuits — great for large subqueries. IN breaks with NULLs. JOIN can create duplicates.

---

### 🔴 Q10 — How would you optimise a slow analytical query on hundreds of millions of rows in BigQuery or Snowflake?

**Answer:**
Work through this checklist:
1. **Check partition pruning** — does your WHERE clause filter on the partition column? If not, the engine scans the entire table.
2. **Check clustering/sort keys** — are you filtering on a clustered column?
3. **Avoid SELECT *** — reading unused columns wastes I/O in columnar stores.
4. **Look for large joins** — can you pre-filter one side before joining?
5. **Use approximate functions** like `APPROX_COUNT_DISTINCT` instead of `COUNT(DISTINCT)` for dashboard metrics — 10× faster with ~1% error.
6. **Materialise expensive subquery results** as a CTE or temp table if used multiple times.
7. **Check for data skew** — one partition holding most data causes one worker to do all the work.

> **Analogy:** Optimising a warehouse query is like optimising a warehouse shipment: route directly to the right shelf (partition pruning), don't carry boxes you don't need (avoid SELECT *), and distribute the load evenly (fix skew).

> **Remember:** Partition pruning first, then column selection, then join optimisation, then approximate aggregates. Profile before guessing.

---

## 3. Indexing & Storage Internals

### 🟢 Q11 — What is a database index and why can too many indexes be worse than none in a write-heavy pipeline?

**Answer:**
An index is a separate data structure the database maintains alongside your table that speeds up lookups — like the index at the back of a book. Without it, finding rows means reading every single row (a full table scan). With an index on the right column, the database jumps straight to matching rows. The catch: every time you INSERT, UPDATE, or DELETE a row, the database must update every index on that table too. A table with 10 indexes pays 10 write operations for every 1 logical write. For an ETL pipeline loading millions of rows per hour, this is a major bottleneck. Common practice: drop indexes before bulk loads, load the data, then rebuild indexes.

> **Analogy:** Indexes are like a book's index — great for readers, but the author has to update it every time they edit a page.

> **Remember:** More indexes = faster reads, slower writes. Drop indexes before bulk ETL loads, rebuild after.

---

### 🟡 Q12 — Explain B-tree vs bitmap indexes. When does each excel and why are bitmaps popular in warehouses?

**Answer:**
A B-tree index is a balanced tree structure great for high-cardinality columns (email, user ID, order number) and range queries (dates between X and Y). It works like a sorted phone book — fast for finding exact values or ranges. A bitmap index stores a bit vector per unique value — for example, for a `status` column with values Active/Inactive/Pending, it stores one bit per row per value. For low-cardinality columns (few unique values) this is extremely compact and blazingly fast for AND/OR filtering across multiple columns. Analytical queries often filter on 3–5 low-cardinality columns simultaneously — bitmaps are perfect. But bitmaps are terrible for write-heavy workloads because updating one row requires rebuilding the bit vectors.

> **Analogy:** B-tree is a phone book — sorted, great for finding "all names starting with S". Bitmap is a voting tally — one column per option, incredibly fast to count combinations.

> **Remember:** B-tree = high cardinality, range queries. Bitmap = low cardinality, analytical AND/OR filters. Bitmap is read-only friendly.

---

### 🟡 Q13 — What is columnar storage and why do analytical warehouses use it instead of row storage?

**Answer:**
In row-oriented storage (like PostgreSQL), all columns of a row are stored together on disk. To answer "what is the average revenue across all orders?", you read every column of every row even though you only need the revenue column. In columnar storage (like Parquet, Redshift, BigQuery), each column is stored together separately. To answer the same question, you read only the revenue column — skipping all other columns entirely. This dramatically reduces disk I/O. As a bonus, values in the same column tend to be similar (same data type, often similar values), so they compress extremely well — a numeric column with many repeated values can compress 10× or more.

> **Analogy:** Row storage is like storing each person's full profile in one envelope. Columnar storage is like having a separate folder for everyone's age, another for everyone's city — when you want average age, you open just one folder.

> **Remember:** Columnar = read only what you need, compress similar values. Perfect for analytics. Bad for row-level updates.

---

### 🔴 Q14 — How does Snowflake's micro-partition architecture work and how does it differ from traditional Hive partitioning?

**Answer:**
In Hive or PostgreSQL, you explicitly declare a partition column (like date) and the engineer manually manages partition layout. If you choose the wrong column or data changes distribution patterns, you're stuck. Snowflake automatically divides all tables into micro-partitions of 50–500MB compressed data. Each micro-partition stores metadata about the min and max value of every column inside it. When you run a query with a WHERE clause, Snowflake's query planner checks metadata to skip entire micro-partitions that can't possibly contain matching rows — called micro-partition pruning. No manual partition declaration needed. Clustering keys are an optional hint to Snowflake to physically co-locate data by a column, improving pruning further.

> **Analogy:** Traditional partitioning is like a filing cabinet where you choose which drawer holds which year's files upfront. Snowflake micro-partitions are like a smart organiser that labels every drawer automatically and tells you instantly which drawers to skip.

> **Remember:** Snowflake auto-partitions everything. Clustering keys help pruning on your most-filtered columns but are optional.

---

## 4. Transactions, ACID & Isolation

### 🟢 Q15 — What does ACID stand for and why does each property matter in a data pipeline?

**Answer:**
- **Atomicity:** A transaction is all-or-nothing. If a pipeline writes 1 million rows and crashes halfway, Atomicity guarantees the partial write is rolled back — you don't end up with half the data.
- **Consistency:** Every transaction takes the database from one valid state to another, enforcing all rules and constraints.
- **Isolation:** Concurrent transactions don't interfere with each other — one pipeline writing data doesn't corrupt what another pipeline is reading simultaneously.
- **Durability:** Once a transaction is committed, it survives crashes — written to disk permanently, not just memory.

In pipeline design, ACID matters most at landing zones and staging tables where partial writes could corrupt downstream analytics.

> **Analogy:** Atomicity = a bank transfer either completes fully or not at all — you never lose money in transit. Durability = once the transfer is confirmed, a power cut doesn't reverse it.

> **Remember:** Atomicity prevents partial writes. Isolation prevents concurrent pipeline interference. Durability prevents data loss on crash.

---

### 🟡 Q16 — Explain the four SQL transaction isolation levels and the anomalies each prevents.

**Answer:**

| Level | Prevents | Allows |
|-------|----------|--------|
| Read Uncommitted | Nothing | Dirty reads, non-repeatable reads, phantom reads |
| Read Committed | Dirty reads | Non-repeatable reads, phantom reads |
| Repeatable Read | Dirty + non-repeatable reads | Phantom reads |
| Serializable | All anomalies | Nothing — but slowest |

- **Dirty read:** Reading data that another transaction hasn't committed yet — could be rolled back.
- **Non-repeatable read:** A value you read twice in the same transaction changes between reads.
- **Phantom read:** New rows appear in a repeated query within the same transaction.

Read Committed is the default in most databases and fine for most pipelines. For long-running analytical reports that must see a consistent snapshot, use Repeatable Read or Serializable.

> **Analogy:** Read Uncommitted = reading rough drafts still being written. Read Committed = only published pages. Repeatable Read = pages are locked while you're reading. Serializable = you have the only copy in the library.

> **Remember:** Read Committed is the practical default. Use Repeatable Read or Serializable for multi-step analytical queries that must see consistent data.

---

### 🟡 Q17 — What is MVCC (Multi-Version Concurrency Control) and how does it allow reads and writes simultaneously?

**Answer:**
MVCC solves the classic problem of reads and writes blocking each other. Instead of locking a row when someone writes to it, the database keeps multiple versions of the row. A writer creates a new version; readers continue to see the old version that was current when their transaction started. No one waits for anyone else. This is why in PostgreSQL you can run a long report query without blocking the application from inserting new orders. The trade-off: old versions accumulate as dead rows (dead tuples). PostgreSQL's `VACUUM` process periodically cleans these up. If VACUUM falls behind on a high-write table, the table bloats and slows down.

> **Analogy:** MVCC is like a document with tracked changes — the current author works on a new version while reviewers still read the previous one. Nobody waits for the other.

> **Remember:** MVCC = no read/write blocking. But run VACUUM regularly in PostgreSQL or dead tuples accumulate and kill performance.

---

### 🔴 Q18 — What is a distributed transaction and what patterns do data engineers use instead of 2PC?

**Answer:**
A distributed transaction tries to keep multiple separate databases in sync atomically — commit all or rollback all. Two-Phase Commit (2PC) is the classic protocol: a coordinator asks all participants to prepare, then tells them all to commit. The problem: if the coordinator crashes after prepare but before commit, all participants are locked waiting forever. Data engineers use better alternatives:

- **Outbox Pattern:** Write to your own database and an outbox table in one local transaction, then a separate process reliably publishes those events.
- **Saga Pattern:** Each service does its own local transaction and publishes an event; if a step fails, compensating transactions undo previous steps.
- **Idempotent writes + event sourcing:** Each service consumes events and applies them safely even if replayed.

> **Analogy:** 2PC is like asking 10 people to jump simultaneously — if the coordinator collapses mid-air, everyone is stuck frozen. The Outbox pattern is like passing a baton in a relay race — each runner is responsible only for their own leg.

> **Remember:** Avoid 2PC in production distributed systems. Use Outbox Pattern or Saga Pattern instead.

---

## 5. NoSQL & Polyglot Persistence

### 🟢 Q19 — What are the main NoSQL database categories and which data engineering use case fits each?

**Answer:**

| Type | Examples | Best For |
|------|----------|----------|
| Key-Value | Redis, DynamoDB | Caching, session data, real-time counters |
| Document | MongoDB, Firestore | Semi-structured data, varying schemas, product catalogues |
| Column-Family | Cassandra, HBase | Time-series, IoT events, high write throughput |
| Graph | Neo4j | Social networks, fraud detection, recommendation engines |

> **Analogy:** Key-Value = a locker room (fast, access by locker number only). Document = a filing cabinet with flexible folders. Column-Family = a spreadsheet designed for writing billions of rows. Graph = a mind map of connected ideas.

> **Remember:** Match the database to the access pattern. There's no universal best — each has a specific strength.

---

### 🟡 Q20 — Explain the CAP theorem. How does choosing CP vs AP affect pipeline design?

**Answer:**
CAP theorem says a distributed database can guarantee at most two of three things:
- **C**onsistency — every read gets the latest write
- **A**vailability — every request gets a response
- **P**artition Tolerance — the system keeps working even if network messages are lost between nodes

Since network partitions always happen in real distributed systems, you really choose between **CP** and **AP**:
- **CP** systems (HBase): choose consistency over availability — if nodes can't agree, they refuse to answer rather than give stale data.
- **AP** systems (Cassandra with default settings): choose availability — always respond but might return slightly stale data.

For your pipeline: if you read from an AP system, design your code to tolerate slightly old data. Add reconciliation jobs to catch and fix inconsistencies.

> **Analogy:** CP is a bank ATM that goes offline during a network issue rather than risk showing wrong balance. AP is a scoreboard that keeps showing the last known score even if the update is delayed.

> **Remember:** AP systems always respond but data may be stale. Add reconciliation in your pipeline to catch inconsistencies.

---

### 🟡 Q21 — What is schema-on-read and why does it create challenges when loading into a structured warehouse?

**Answer:**
Schema-on-read means the database (like MongoDB or a JSON data lake) imposes no structure when data is written — any shape is accepted. Structure is only interpreted when you read the data. This is flexible for producers but creates headaches for data engineers loading into a structured warehouse. Problems you face:
- A field called `amount` might be an integer in some documents and a string in others
- Fields might be completely missing in some documents
- Nested arrays of varying depth need to be flattened
- New fields appear without warning

You must write defensive pipeline code that handles all these cases, infers types, fills missing fields with defaults, and flattens nested structures into relational columns.

> **Analogy:** Schema-on-read is like accepting packages of any size and shape in your warehouse. Convenient for the sender, but when you try to put them on standardised shelves, you have to repack everything.

> **Remember:** Schema-on-read = flexible writes, painful ingestion. Always validate, coerce types, and fill missing fields before loading into a warehouse.

---

### 🔴 Q22 — Explain Cassandra's data model and why queries must be designed around the data model.

**Answer:**
In a relational database you design tables first and write any query later. In Cassandra you do the opposite: decide your queries first, then design the tables to serve them. Each table is optimised for exactly one access pattern.

- **Partition key:** determines which node stores the data — all rows with the same partition key are stored together and retrieved in one fast operation.
- **Clustering key:** sorts rows within a partition.

If you query by a column that is not your partition key, Cassandra must scan every node in the cluster — equivalent to a full table scan across a distributed system, which is catastrophically slow. This means one use case = one table, and adding a new query pattern often means creating a new table.

> **Analogy:** Cassandra is like a post office that sorts mail by zip code. You can retrieve all mail for a zip code instantly. But if you want all mail for a specific street name across all zip codes, every post office in the country has to search their entire pile.

> **Remember:** Design Cassandra tables around queries, not around entities. One query pattern = one table.

---

## 6. Data Warehouse Design

### 🟢 Q23 — What is the difference between an OLTP database and a data warehouse? Why can't you just run analytics on the production database?

**Answer:**
OLTP (Online Transaction Processing) databases are designed for speed on individual rows — inserting an order, updating a customer address, reading one user's profile. They are optimised for thousands of small, fast operations per second with many concurrent users. OLAP (Online Analytical Processing) data warehouses are designed for scanning millions or billions of rows to compute aggregates — total revenue by region, monthly active users, conversion rates.

Running a heavy analytical query on a production OLTP database:
- Scans millions of rows and holds locks
- Consumes all CPU
- Slows down every live customer transaction happening simultaneously

Warehouses use completely different storage structures (columnar) and query engines optimised for large scans.

> **Analogy:** An OLTP database is a busy restaurant kitchen — optimised for making one dish at a time, fast. A warehouse is a food factory — optimised for processing tonnes of ingredients in bulk. You wouldn't run a factory production line through a restaurant kitchen.

> **Remember:** OLTP = fast row operations for live users. OLAP warehouse = heavy scans for analytics. Never mix them — separate workloads completely.

---

### 🟢 Q24 — What is the difference between a data warehouse, a data lake, and a data lakehouse?

**Answer:**

| | Data Warehouse | Data Lake | Data Lakehouse |
|--|---------------|-----------|----------------|
| **Examples** | Snowflake, BigQuery, Redshift | S3, GCS, ADLS | Delta Lake, Iceberg, Hudi |
| **Storage** | Proprietary columnar | Raw files (any format) | Object storage (S3/GCS) |
| **Structure** | Schema-on-write | Schema-on-read | Schema-on-write |
| **ACID** | Yes | No | Yes |
| **Cost** | High | Low | Low |
| **Best for** | BI & governed analytics | Raw data, ML, flexibility | Both |

The **lakehouse** is the modern default for large-scale platforms — lake-level storage costs combined with warehouse-like governance and performance.

> **Analogy:** Warehouse = a clean, organised supermarket with labelled shelves. Data lake = a giant storage container where you throw everything. Lakehouse = a well-organised warehouse built inside a cheap storage container.

> **Remember:** Lakehouse = lake storage costs + warehouse-like features. It's the modern default for large-scale data platforms.

---

### 🟡 Q25 — What is a staging layer in a data warehouse and why is it a best practice?

**Answer:**
A staging layer is a landing zone where raw data arrives exactly as it came from the source — no transformations, no business logic applied. Think of it as a waiting room before data enters the main warehouse. Why is this critical?

1. If a transformation has a bug, you can reprocess from staging without re-extracting from the source system.
2. It gives you an auditable record of exactly what data arrived and when — important for debugging "why does the report show X?" questions.
3. It decouples extraction (getting data out of the source) from transformation (cleaning and modelling data) — the two can run at different speeds and fail independently.

> **Analogy:** Staging is like unloading boxes from a delivery truck into a receiving dock before sorting them into the warehouse. If something's wrong with the sorting, you still have the original boxes in the dock.

> **Remember:** Staging = raw, immutable, replayable. Never transform data before staging it. Staging enables debugging and reprocessing.

---

### 🟡 Q26 — What is the difference between Kimball, Inmon, and Data Vault approaches?

**Answer:**

| Approach | Philosophy | Pros | Cons |
|----------|-----------|------|------|
| **Kimball** | Star schemas per business process | Fast to build, easy to query, BI-friendly | Can have inconsistencies across areas |
| **Inmon** | Normalised 3NF enterprise warehouse | Single source of truth, consistent | Complex, slow to build, hard to query directly |
| **Data Vault** | Hub-Satellite-Link model | Auditable, agile, handles change well | Complex to query, needs a consumption layer on top |

Most modern teams use **Kimball** or **Data Vault** with a dbt-powered consumption layer on top.

> **Analogy:** Kimball is building a department store where each department is set up for its own shoppers. Inmon is building one central stockroom with individual checkout counters on top. Data Vault is building a museum archive that records everything ever received, tagged and dated, for future curators to interpret.

> **Remember:** Kimball = fast to build, easy to query. Inmon = consistent but complex. Data Vault = auditable and agile.

---

### 🔴 Q27 — Explain Slowly Changing Dimensions (SCD) Types 1, 2, and 3 and the pipeline complexity each adds.

**Answer:**
SCD handles the challenge of dimension attributes that change over time — like a customer moving cities or changing their name.

| Type | Strategy | History | Pipeline Complexity |
|------|----------|---------|---------------------|
| **Type 1** | Overwrite the old value | None — history lost | Simple UPDATE |
| **Type 2** | Insert a new row, expire the old | Full history preserved | Complex MERGE with effective dates + current flag |
| **Type 3** | Add a "previous value" column | One step back only | Add column, moderate |

**Type 2** is the warehouse standard. It requires:
- Surrogate keys (natural keys won't work)
- `effective_start_date` and `effective_end_date` columns
- A `is_current` flag
- Merge/upsert pipeline logic that detects changes

> **Analogy:** Type 1 = editing a Wikipedia article without tracking changes. Type 2 = Wikipedia's full revision history — every edit preserved. Type 3 = a form with a "previous address" field — only one old version stored.

> **Remember:** Type 2 is the industry standard. It requires surrogate keys, effective date columns, current flag, and upsert pipeline logic.

---

## 7. Dimensional Modelling

### 🟢 Q28 — What is a star schema and why is it preferred for data warehouses over a normalised schema?

**Answer:**
A star schema has one central fact table surrounded by dimension tables — and it looks like a star when drawn. The fact table stores measurable events (a sale, a click, a payment) with numeric values and foreign keys to dimensions. Dimension tables store descriptive context (who, what, when, where). The design is intentionally denormalised — dimension data is not further broken into sub-tables. This means joins are simple: you always join fact to one or two dimension tables, never chains of 5+ tables. BI tools like Tableau, Power BI, and Looker are built expecting star schemas.

> **Analogy:** A star schema is like a receipt: in the centre is "you bought X for £Y on date Z" (fact). On the sides are the product details, customer details, store details (dimensions). Everything connects back to the receipt.

> **Remember:** Star schema = fact table in the centre, dimension tables around it. Simple joins, fast queries, BI-tool friendly.

---

### 🟡 Q29 — What is a fact table and what are additive, semi-additive, and non-additive facts?

**Answer:**

| Type | Can SUM across... | Examples |
|------|------------------|---------|
| **Additive** | All dimensions | Revenue, quantity, clicks |
| **Semi-additive** | Some dimensions (not time) | Account balance, inventory level |
| **Non-additive** | No dimensions | Ratios, percentages, conversion rates |

The classification matters because using SUM on a semi-additive fact produces wrong totals. A bank account balance can be summed across accounts but not across time — summing daily balances to get a "total balance for the year" is meaningless. Non-additive facts like conversion rates should be computed at query time, never summed directly.

> **Analogy:** Revenue is additive — add up all sales freely. Account balance is semi-additive — you can add balances across accounts but not across days. Conversion rate is non-additive — you can't add percentages.

> **Remember:** Check fact type before summing. Semi-additive facts need special aggregation logic (e.g., last balance of the day, not sum).

---

### 🟡 Q30 — What is a degenerate dimension and when should you use one?

**Answer:**
A degenerate dimension is a key from the source transaction — like an order number, invoice number, or ticket ID — that lives on the fact table itself with no corresponding dimension table. You use it when the identifier is important for drill-through (going from a summary report back to the original transaction) but has no descriptive attributes worth putting in a separate table. For example, an order number links to the source system's order detail but has no name, category, or description of its own. Creating a whole dimension table for just an ID with no other columns is wasteful.

> **Analogy:** A degenerate dimension is like a receipt number printed on a receipt. It's there so you can reference the original transaction, but it has no other information around it.

> **Remember:** Degenerate dimensions are transaction keys with no attributes. Store them on the fact table directly — no separate dimension table needed.

---

### 🔴 Q31 — Explain grain in a fact table. What happens when you mix two different grains?

**Answer:**
The grain is the precise definition of what one row in the fact table represents. "One row = one order line item" is a grain. "One row = one order header" is a different grain. Grain must be declared before designing the fact table and never violated.

Mixing grains — for example, storing both order header totals and order line revenue in the same table — makes aggregations produce wrong results. If you SUM the revenue column you might double-count because header rows and line rows both contribute.

Detection signs:
- Row counts that don't match source
- SUM values higher than expected
- Joining to a dimension table that unexpectedly multiplies rows

The fix: split into two separate fact tables — one per grain.

> **Analogy:** Grain is like the unit of measurement on a ruler. If you mix inches and centimetres on the same ruler without labelling them, every measurement you take is wrong.

> **Remember:** Declare grain before designing. One fact table = one grain. Mixing grains = guaranteed wrong aggregations.

---

### 🔴 Q32 — What is a bridge table in dimensional modelling and when do you need one?

**Answer:**
A bridge table solves the many-to-many relationship between a dimension and a fact. Example: a customer can belong to multiple market segments (Premium, Loyal, At-Risk). If you try to put the segment on the customer dimension, you can only store one. If you duplicate the customer row per segment in the fact table, all numeric facts get counted multiple times.

The bridge table sits between the customer dimension and the fact table, with one row per customer-segment combination. To prevent double-counting, bridge tables often include a **weighting factor** — if a customer is in 3 segments, each bridge row gets weight 1/3 so revenue totals stay correct.

> **Analogy:** A bridge table is like a class roster — it lists every student-class combination. Without it you'd have to duplicate either the student record or the class record.

> **Remember:** Bridge table = many-to-many between dimension and fact. Always add weighting factors to prevent double-counting.

---

## 8. OLAP, Partitioning & Performance

### 🟡 Q33 — What is partitioning in a data warehouse? What is the difference between partitioning for performance vs data management?

**Answer:**

| Purpose | How It Helps |
|---------|-------------|
| **Performance** | Query filters on the partition column → engine skips non-matching partitions (partition pruning) |
| **Data management** | DROP old partition instantly instead of slow DELETE; tiered storage (hot/cold) |

The key caveat: **partition pruning only works if your query actually filters on the partition column.** A query `WHERE product_id = 123` on a date-partitioned table still scans every partition.

> **Analogy:** Partitioning a table by date is like organising a filing cabinet by year. To find 2024 files you open only the 2024 drawer, not all 20 drawers.

> **Remember:** Partition by your most common filter column (usually date). Pruning only happens if the WHERE clause uses the partition column.

---

### 🟡 Q34 — Explain materialised views vs regular views. When are materialised views valuable and what are their costs?

**Answer:**
A regular view is just a saved SQL query — every time you query it, the underlying SQL runs from scratch against the base tables. Zero storage benefit. A materialised view pre-computes the query result and stores it on disk like a real table. Querying it is instant — you read pre-computed rows instead of re-aggregating millions of rows each time.

**Best use case:** Expensive dashboards that run the same heavy aggregation query thousands of times per day over slowly-changing data.

**Cost:** The materialised view must be refreshed when underlying data changes.
- Full refresh = recompute everything (slow but simple)
- Incremental refresh = only process new/changed rows (fast but only supported for specific query patterns)

> **Analogy:** A regular view is like a live camera feed — always current but requires processing every time you look. A materialised view is like a photograph — instant to view, but it goes out of date and must be retaken periodically.

> **Remember:** Materialised views are worth it when the same expensive aggregation is run repeatedly on slowly changing data.

---

### 🔴 Q35 — What is data skew in a distributed query engine, how do you detect it, and how do you fix it?

**Answer:**
Data skew means one partition or worker node has much more data than the others. In a distributed system like Spark, BigQuery, or Redshift, queries are split across many workers. If 90% of your data has the same `customer_id` (say, a bulk test account), one worker processes that enormous partition while all other workers finish and sit idle. The overall job runs as slow as that one overloaded worker.

**Detection:** One task in Spark UI taking 10× longer than others. One node in Redshift execution plan with dramatically higher cost.

**Fixes:**
1. **Broadcast join** — if one side of a join is small, send a copy to every worker so no shuffling needed
2. **Salting** — add a random number suffix to the skewed join key to spread data across more partitions, then aggregate the partial results
3. **Pre-filter** the skewed key before joining

> **Analogy:** Skew is like a supermarket checkout where 50 people all want to pay cash and only one cashier takes cash — while the card-payment queues are empty.

> **Remember:** Detect skew via task timing imbalance. Fix with broadcast joins for small tables or salting for skewed keys.

---

### 🔴 Q36 — Explain Redshift distribution styles (KEY, ALL, EVEN, AUTO). How do you pick the right distribution key for a fact table?

**Answer:**

| Style | How It Works | Best For |
|-------|-------------|---------|
| **EVEN** | Round-robin across nodes | Default; no join benefit |
| **KEY** | Same key value → same node | Eliminating shuffle on joins |
| **ALL** | Full copy on every node | Small, slowly-changing dimension tables |
| **AUTO** | Redshift decides | Small tables (auto-assigns ALL), large tables (auto-assigns EVEN) |

For a fact table: choose **KEY distribution** on the column you most frequently join to — usually your highest-cardinality dimension key (`customer_id` or `date_key`). When you join two KEY-distributed tables on the same column, matching rows are already co-located on the same node — no network shuffle required.

> **Analogy:** KEY distribution is like sorting mail by zip code so each postman only delivers to their own neighbourhood — letters and packages for the same zip code are always together, so delivery (joins) is fast.

> **Remember:** KEY distribution on your most-joined column eliminates the most expensive shuffle operations. Use ALL for small dimensions.

---

## 9. Modern Cloud Data Platforms

### 🟡 Q37 — What is separation of storage and compute in cloud warehouses, and how does it change pipeline architecture?

**Answer:**
In traditional databases, storage and compute live on the same machine — you pay for both even when idle, and scaling one means scaling both. Cloud warehouses separate them completely:
- **Storage:** data lives in cheap object storage (S3, GCS) — billed per GB stored
- **Compute:** query engines (virtual warehouses, slots) are spun up on demand — billed per second of active use

This changes pipeline architecture significantly:
- **Pause compute** when no queries are running — saving 100% of compute cost
- **Spin up multiple independent compute clusters** over the same data — separate workloads for ETL, BI, and data science
- **Scale storage and compute independently** — no need to over-provision hardware for peak loads

> **Analogy:** Traditional database = owning a car (you pay for it whether you drive or not). Separate storage/compute = a taxi service — you only pay when you're actually riding.

> **Remember:** Pause compute when not in use. Scale compute independently from storage. Multiple clusters can query the same data simultaneously.

---

### 🟡 Q38 — What is Apache Iceberg (or Delta Lake) and what problems does it solve that plain Parquet files on S3 cannot?

**Answer:**

Plain Parquet files on S3 are just files — no transactions, no schema history, no efficient row-level updates. Apache Iceberg adds a metadata layer on top:

| Feature | Plain Parquet on S3 | Apache Iceberg |
|---------|---------------------|----------------|
| ACID transactions | ❌ | ✅ |
| Time travel | ❌ | ✅ |
| Schema evolution | ❌ | ✅ |
| Partition evolution | ❌ | ✅ |
| Efficient deletes/updates | ❌ | ✅ |

Iceberg tracks which files belong to the table, their min/max statistics per column, and the schema at each point in time. It turns a collection of files into a proper, queryable, versionable table.

> **Analogy:** Plain Parquet on S3 is a pile of receipts in a shoebox. Iceberg is the same receipts now in a proper accounting ledger with dates, corrections, and full audit trail.

> **Remember:** Iceberg = ACID + time travel + schema evolution on top of cheap object storage. The modern replacement for Hive tables.

---

### 🔴 Q39 — Explain the medallion architecture (bronze/silver/gold layers) and the engineering principles behind each layer.

**Answer:**

| Layer | Contents | Principle |
|-------|----------|-----------|
| **Bronze** | Raw data, exactly as received | Immutable. Never modify. Full audit trail. |
| **Silver** | Deduplicated, type-corrected, conformed | Trustworthy and consistent. Business rules start here. |
| **Gold** | Aggregated, domain-specific, BI-ready | Optimised for query performance and consumption. |

The key engineering principle: **each layer is independently reprocessable**.
- If silver logic changes → reprocess silver from bronze
- If gold logic changes → reprocess gold from silver
- Nothing is ever lost

This enables safe iteration — you can improve transformation logic at any layer without fear of losing the original data.

> **Analogy:** Bronze = raw ingredients delivered by the farmer. Silver = washed, chopped, measured ingredients. Gold = the finished dish plated for the table.

> **Remember:** Bronze = raw and immutable. Silver = clean and conformed. Gold = aggregated for consumers. Each layer must be independently reprocessable.

---

### 🔴 Q40 — What is dbt and how does it change the role of a data engineer compared to traditional SQL scripts?

**Answer:**

| Dimension | Traditional SQL Scripts | dbt |
|-----------|------------------------|-----|
| Versioning | Manual, often none | Git-controlled |
| Dependencies | Manually managed | Auto-built via `ref()` |
| Testing | Manual or none | Built-in schema + custom tests |
| Documentation | Separate document | Inline YAML, auto-generated |
| Execution | Manual or cron | dbt run / dbt cloud |

With dbt: every transformation is a SELECT statement in a `.sql` file. The `ref()` function references other models and dbt automatically builds the dependency DAG. You can write tests — "this column must be unique", "this column must not be null". The entire transformation DAG runs with one command and deploys through CI/CD like any other code.

> **Analogy:** Traditional SQL scripts are like hand-written recipes scattered in different notebooks. dbt is a professional recipe management system — every recipe versioned, tested, and linked to the ingredients it uses.

> **Remember:** dbt = version-controlled, tested, documented SQL transformations with automatic DAG. Use `ref()` to build dependencies between models.

---

## 10. ELT/ETL & Pipeline Patterns

### 🟢 Q41 — What is the difference between ETL and ELT and why has ELT become dominant?

**Answer:**
- **ETL** (Extract, Transform, Load): extract data from the source → transform it in a separate engine (Python, Spark) → load the clean result into the warehouse.
- **ELT** (Extract, Load, Transform): extract raw data → load it directly into the warehouse staging layer → transform it inside the warehouse using SQL.

ELT has become dominant because:
1. Modern cloud warehouses (Snowflake, BigQuery, Redshift) are powerful enough to transform billions of rows in SQL cheaply.
2. Raw data is always preserved in the warehouse — enabling full reprocessing.
3. Transformations can be written in plain SQL and managed with dbt by any engineer on the team.
4. No separate transformation cluster to manage or scale.

> **Analogy:** ETL is like cleaning fish before bringing it to the kitchen. ELT is like bringing the whole fish to the kitchen and cleaning it there with professional tools.

> **Remember:** ELT is the modern standard. Raw data lands in staging first. Transform inside the warehouse using SQL and dbt.

---

### 🟡 Q42 — What is CDC (Change Data Capture) and why is it preferred over full table extraction?

**Answer:**

| Method | How It Works | Pros | Cons |
|--------|-------------|------|------|
| **Full extraction** | Read entire table every run | Simple | Slow, heavy on source, scales poorly |
| **Query-based CDC** | Filter on `updated_at` timestamp | Simple | Misses hard deletes, relies on column accuracy |
| **Log-based CDC** | Read database transaction log (binlog/WAL) | Real-time, captures deletes, minimal source impact | Complex setup |
| **Trigger-based CDC** | DB triggers write changes to a side table | Reliable | Adds write overhead to source |

**Log-based CDC** (tools: Debezium, Fivetran, AWS DMS) is the gold standard for production pipelines — near real-time, captures every INSERT/UPDATE/DELETE, and places almost zero load on the source database.

> **Analogy:** Full extraction is photocopying an entire 1000-page book every day to find the 2 changed pages. CDC is reading only the highlighted change log at the back.

> **Remember:** Log-based CDC is the gold standard — near real-time, minimal source impact, captures deletes. Query-based CDC is simpler but misses hard deletes.

---

### 🟡 Q43 — Explain full load, incremental load, and upsert/MERGE strategies. When would you choose each?

**Answer:**

| Strategy | Best For | Risk |
|----------|----------|------|
| **Full load** | Small tables, fully mutable source data | Expensive at scale |
| **Incremental (append-only)** | Event logs, append-only sources | Misses updates and deletes |
| **Upsert / MERGE** | Sources with updates, SCD Type 2 | Expensive on columnar stores |

Key considerations:
- High-watermark columns (`updated_at`) can be unreliable — backfills and late updates break the logic.
- MERGE statements on columnar stores (Snowflake, BigQuery) can trigger full micro-partition rewrites — expensive if misused.
- Combine strategies: incremental for recent data, periodic full load for older partitions as a safety net.

> **Analogy:** Full load = reprinting the entire newspaper every hour. Incremental = printing only today's new articles. Upsert = printing new articles and correcting any errors in yesterday's edition.

> **Remember:** Append-only source → incremental. Updates possible → upsert/MERGE. Small table or unknown change pattern → full load.

---

### 🔴 Q44 — How would you design a pipeline loading a high-volume transactional DB into a warehouse with under 5 minutes latency?

**Answer:**
A production architecture for sub-5-minute latency:

```
Source DB (read replica)
      ↓ Log-based CDC (Debezium)
   Kafka topic
      ↓ Stream processor (Flink / Spark Streaming)
  Warehouse staging table
      ↓ Micro-batch MERGE (every 1-2 min)
  Production warehouse table
```

Key design decisions:
1. Use a **read replica** for CDC — never put CDC load on the primary DB.
2. **Kafka** decouples source from destination and provides a durable buffer.
3. Use a **schema registry** to handle schema changes without breaking the pipeline.
4. Design the MERGE to be **idempotent** — safe to replay if anything fails.
5. Use Kafka consumer group offsets for exactly-once tracking.

> **Analogy:** Log-based CDC is a journalist listening to a police scanner (the DB log). Kafka is the news wire. The stream processor is the editor. The warehouse is the published newspaper — updated every few minutes.

> **Remember:** CDC on read replica → Kafka buffer → micro-batch MERGE into warehouse. Schema registry for evolution. Idempotent MERGE for safe retries.

---

### 🔴 Q45 — What is the late-arriving data problem in data warehouses and how do you handle it architecturally?

**Answer:**
Late-arriving data is when an event that happened in the past arrives in your pipeline after the reporting period has already closed. Classic example: a mobile app that was offline for 3 days comes back online and sends all its events — events timestamped 3 days ago but arriving now.

**Processing time vs Event time:**
- **Processing time:** when the event arrived in your system
- **Event time:** when the event actually happened

Always process by **event time** where accuracy matters, not when the event arrived.

**Architectural solutions:**

| Pattern | How It Works |
|---------|-------------|
| Reprocessable gold layer | Design gold tables to be rebuilt from silver when late data arrives |
| Open correction windows | Keep recent partitions open for updates for N days |
| Correction records | Insert adjustment rows in the fact table rather than updating rows |
| Communicate finality windows | Tell BI users that metrics within the last 7 days are provisional |

> **Analogy:** Late-arriving data is like receiving a letter postmarked last week that only arrived today. Do you file it under today's date or last week's? Filing it under today gives wrong historical records. Filing it under last week means old records get updated.

> **Remember:** Use event time, not processing time. Keep a reprocessing window for recent partitions. Communicate metric finality windows to business users.

---

## Quick Reference Cheat Sheet

| Topic | Key Rule |
|-------|----------|
| Normalisation | OLTP = normalised. OLAP warehouse = denormalised for query speed |
| Surrogate keys | Always use in dimension tables — natural keys change |
| SQL execution order | FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY |
| Correlated subqueries | Rewrite as window functions or JOINs — never leave on large tables |
| Window functions | Never collapse rows. Use for rankings, running totals, row comparisons |
| Indexes | Drop before bulk loads, rebuild after. Too many = slow writes |
| Columnar storage | Read only needed columns, compress similar values. Bad for row updates |
| ACID | Atomicity prevents partial writes. Durability prevents crash data loss |
| MVCC | No read/write blocking. Run VACUUM in PostgreSQL or tables bloat |
| Distributed transactions | Use Outbox or Saga patterns — avoid 2PC in production |
| CAP theorem | CP = consistent but may reject. AP = always responds but may be stale |
| Star schema | Fact in centre, dimensions around it. Simple joins, BI-friendly |
| Grain | Declare before designing. One fact table = one grain. Never mix |
| SCD Type 2 | Surrogate keys + effective dates + current flag + upsert logic |
| Fact types | Additive = SUM freely. Semi-additive = careful with time. Non-additive = never SUM |
| Partitioning | Pruning only works if WHERE filters on the partition column |
| Materialised views | Precompute expensive, frequently-run aggregations over slow-changing data |
| Data skew | Broadcast small tables. Salt skewed join keys |
| Medallion architecture | Bronze = raw. Silver = clean. Gold = aggregated. Each reprocessable |
| dbt | Use `ref()` for dependencies. Version, test, and document all models |
| ETL vs ELT | ELT is the modern default. Land raw → transform inside the warehouse |
| CDC | Log-based CDC is gold standard — real-time, captures deletes, minimal source impact |
| Late-arriving data | Process by event time. Keep correction windows open. Communicate finality to users |

---

*Generated for Data Engineering interview preparation. Covers beginner through advanced topics across Relational Databases, SQL, NoSQL, Data Warehouse Design, Dimensional Modelling, Cloud Platforms, and Pipeline Patterns.*
