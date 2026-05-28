-- Mock data for the Motzklist app.
-- IDs are assigned explicitly so the frontend can rely on stable values
-- (e.g. /api/equipment?school_id=1&grade_id=1). Sequences are reset at the
-- end so subsequent inserts from the running app pick up at the next free ID.

-- Schools
INSERT INTO school (sid, sname) VALUES
    (1, 'Ben Gurion'),
    (2, 'ORT'),
    (3, 'Brener'),
    (4, 'Herzel'),
    (5, 'Begin');

-- Grades: 9th-12th for every school (gid = (sid-1)*4 + (grade-8))
INSERT INTO grade (gid, sid, gname) VALUES
    (1,  1, '9th Grade'),  (2,  1, '10th Grade'), (3,  1, '11th Grade'), (4,  1, '12th Grade'),
    (5,  2, '9th Grade'),  (6,  2, '10th Grade'), (7,  2, '11th Grade'), (8,  2, '12th Grade'),
    (9,  3, '9th Grade'),  (10, 3, '10th Grade'), (11, 3, '11th Grade'), (12, 3, '12th Grade'),
    (13, 4, '9th Grade'),  (14, 4, '10th Grade'), (15, 4, '11th Grade'), (16, 4, '12th Grade'),
    (17, 5, '9th Grade'),  (18, 5, '10th Grade'), (19, 5, '11th Grade'), (20, 5, '12th Grade');

-- Equipment catalog
INSERT INTO equipment (eid, ename, price) VALUES
    (101, 'Notebook (Ruled)',           2.50),
    (102, 'Pencil',                     0.50),
    (103, 'Math Textbook - Algebra I', 45.00),
    (201, 'Laptop (Required)',        800.00),
    (202, 'Engineering Calculator',    35.00),
    (203, 'Physics Textbook - Advanced', 60.00),
    (901, 'Binder (3-ring)',            5.00),
    (902, 'Highlighters',               1.50);

-- Requirements: what each (school, grade) needs
-- Ben Gurion, 9th Grade (gid=1)
INSERT INTO requirement (gid, eid, quantity) VALUES
    (1, 101, 5),
    (1, 102, 12),
    (1, 103, 1);

-- ORT, 12th Grade (gid=8)
INSERT INTO requirement (gid, eid, quantity) VALUES
    (8, 201, 1),
    (8, 202, 1),
    (8, 203, 1);

-- Default-ish requirements for a couple of other grades so the UI has data
-- Brener, 10th Grade (gid=10)
INSERT INTO requirement (gid, eid, quantity) VALUES
    (10, 901, 2),
    (10, 902, 4);

-- Users (passwords intentionally plain in mock data only)
INSERT INTO users (uid, uname, password) VALUES
    (1, 'avner', '2004'),
    (2, 'admin', '1234'),
    (3, 'noam',  '1919');

-- An active cart for user 'avner' at Ben Gurion, 9th Grade
INSERT INTO cart_entry (ceid, gid, uid) VALUES (1, 1, 1);

-- cart_item is one row per unit; Go aggregates with COUNT() when reading.
-- 2x Notebook, 1x Calculator, 1x Physics textbook
INSERT INTO cart_item (ceid, eid) VALUES
    (1, 101), (1, 101),
    (1, 202),
    (1, 203);

-- A completed order for user 'admin' at ORT, 12th Grade
INSERT INTO orders (oid, uid, gid, total_amount) VALUES
    (1, 2, 8, 895.00);

INSERT INTO order_item (oid, eid, quantity, price_at_purchase) VALUES
    (1, 201, 1, 800.00),
    (1, 202, 1,  35.00),
    (1, 203, 1,  60.00);

-- Re-sync sequences so future auto-generated IDs do not collide with the seed.
SELECT setval(pg_get_serial_sequence('school',     'sid'),  5);
SELECT setval(pg_get_serial_sequence('grade',      'gid'),  20);
SELECT setval(pg_get_serial_sequence('equipment',  'eid'),  902);
SELECT setval(pg_get_serial_sequence('users',      'uid'),  3);
SELECT setval(pg_get_serial_sequence('cart_entry', 'ceid'), 1);
SELECT setval(pg_get_serial_sequence('orders',     'oid'),  1);
