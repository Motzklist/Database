צודק, הנה כל התוכן מרוכז בבלוק קוד אחד רציף של Markdown, מה שיאפשר לך להעתיק אותו לקובץ בשלמותו בקלות:

```markdown
# Database Documentation - Project Motzklist

This document consolidates all SQL operations required for development.
The system architecture is built on: Schools, Grades, Equipment Catalog, Requirements, Users, Shopping Carts, and Order History.

## Quick Start
Run the `motzkin-setup.bat`.
Enter your Postgres password, and then you can choose to configure the tables.

---

## 1. School Management (school)

**Note to Developers:** All values marked with `$1`, `$2`, etc. are parameters (Prepared Statements).

### Read
**Get list of all schools**
```sql
-- Retrieve all schools for dropdown menus
SELECT sid, sname
FROM school
ORDER BY sname ASC;
```

**Get single school details by ID**
```sql
SELECT * FROM school WHERE sid = $1;
```

### Create
**Add a new school**
```sql
INSERT INTO school (sname)
VALUES ($1)
RETURNING sid;
```

### Update & Delete
```sql
-- Update school name
UPDATE school
SET sname = $2
WHERE sid = $1;

-- Delete school (Cascades to grades, requirements, carts, and orders)
DELETE FROM school WHERE sid = $1;
```

---

## 2. Grade Management (grade)

### Read
**Get list of grades for a specific school**
```sql
SELECT gid, gname
FROM grade
WHERE sid = $1
ORDER BY gname ASC;
```

### Create
**Add a grade to a school**
```sql
INSERT INTO grade (sid, gname)
VALUES ($1, $2)
RETURNING gid;
```

### Update & Delete
```sql
-- Update grade name
UPDATE grade
SET gname = $2
WHERE gid = $1;

-- Delete grade
DELETE FROM grade WHERE gid = $1;
```

---

## 3. Equipment Catalog (equipment)

### Read
**Get full equipment catalog**
```sql
SELECT eid, ename, price
FROM equipment
ORDER BY ename ASC;
```

### Create & Update
```sql
-- Add item to global catalog
INSERT INTO equipment (ename, price)
VALUES ($1, $2)
RETURNING eid;

-- Update existing equipment item
UPDATE equipment
SET ename = $2, price = $3
WHERE eid = $1;
```

---

## 4. Grade Requirements (requirement)

### Read
**Get full equipment list required for a specific grade**
```sql
-- Calculates the total row price based on required quantity
SELECT 
    r.rid,
    e.eid, 
    e.ename, 
    r.quantity, 
    e.price, 
    (r.quantity * e.price) as total_row_price
FROM requirement r
JOIN equipment e ON r.eid = e.eid
WHERE r.gid = $1
ORDER BY e.ename ASC;
```

### Create & Delete
```sql
-- Link an equipment item to a grade with a specific quantity
INSERT INTO requirement (gid, eid, quantity)
VALUES ($1, $2, $3)
RETURNING rid;

-- Remove an item requirement from a grade
DELETE FROM requirement WHERE rid = $1;
```

---

## 5. User & Shopping Cart Management

### Read
**Get current active cart items for a user in a specific grade**
```sql
SELECT 
    ci.ciid,
    e.ename,
    e.price
FROM cart_item ci
JOIN cart_entry ce ON ci.ceid = ce.ceid
JOIN equipment e ON ci.eid = e.eid
WHERE ce.uid = $1 AND ce.gid = $2;
```

### Create
**Open a new cart and add an item**
```sql
-- Step 1: Create the cart entry
INSERT INTO cart_entry (gid, uid)
VALUES ($1, $2)
RETURNING ceid;

-- Step 2: Add item to the cart entry
INSERT INTO cart_item (ceid, eid)
VALUES ($1, $2)
RETURNING ciid;
```

---

## 6. Orders & Purchase History

### Read
**Get purchase history for a specific user**
```sql
SELECT oid, gid, purchase_date, total_amount
FROM orders
WHERE uid = $1
ORDER BY purchase_date DESC;
```

**Get detailed receipt for a specific order**
```sql
SELECT 
    e.ename, 
    oi.quantity, 
    oi.price_at_purchase,
    (oi.quantity * oi.price_at_purchase) as total_item_cost
FROM order_item oi
JOIN equipment e ON oi.eid = e.eid
WHERE oi.oid = $1;
```

### Create (Checkout Process)
```sql
-- Step 1: Create the main order record
INSERT INTO orders (uid, gid, total_amount)
VALUES ($1, $2, $3)
RETURNING oid;

-- Step 2: Move items from cart to order_item (saving the static price)
INSERT INTO order_item (oid, eid, quantity, price_at_purchase)
VALUES ($1, $2, $3, $4);

-- Step 3: Clear the active cart after successful order
DELETE FROM cart_entry WHERE ceid = $1;
```

---

## 7. Reports and Advanced Queries (Analytics)

### Global Equipment Search
"Who requires the Benny Goren math book?"
```sql
SELECT 
    s.sname as school_name,
    g.gname as grade_name,
    e.ename as item_name,
    r.quantity
FROM requirement r
JOIN grade g ON r.gid = g.gid
JOIN school s ON g.sid = s.sid
JOIN equipment e ON r.eid = e.eid
WHERE e.ename ILIKE '%' || $1 || '%'
ORDER BY s.sname, g.gname;
```

### Grade Budget Report
Calculates the total cost to equip an entire grade based on its requirements.
```sql
SELECT 
    g.gname as grade_name,
    COUNT(r.rid) as total_unique_items,
    COALESCE(SUM(r.quantity * e.price), 0) as total_budget_needed
FROM grade g
LEFT JOIN requirement r ON g.gid = r.gid
LEFT JOIN equipment e ON r.eid = e.eid
WHERE g.sid = $1
GROUP BY g.gid, g.gname
ORDER BY g.gname;
```

### "Empty Grades" Report
Finding grades that have no equipment requirements entered yet (important for auditing).
```sql
SELECT 
    s.sname as school_name,
    g.gname as grade_name
FROM grade g
JOIN school s ON g.sid = s.sid
LEFT JOIN requirement r ON g.gid = r.gid
WHERE r.rid IS NULL
ORDER BY s.sname, g.gname;
```

```