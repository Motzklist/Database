-- Mock data for the Motzklist app.
-- IDs are assigned explicitly so the frontend can rely on stable values
-- (e.g. /api/equipment?school_id=1&grade_id=11). Sequences are reset at the
-- end so subsequent inserts from the running app pick up at the next free ID.

INSERT INTO school (sid, sname) VALUES
  (1, 'Ben Gurion'),
  (2, 'ORT'),
  (3, 'Brener'),
  (4, 'Herzel'),
  (5, 'Begin');

-- Each school gets its own grade rows (gid is unique).
-- gid scheme: sid * 10 + (grade_number - 8)
--   school 1 -> 11 (9th), 12 (10th), 13 (11th), 14 (12th)
--   school 2 -> 21..24, ... etc.
INSERT INTO grade (gid, sid, gname) VALUES
  (11, 1, '9th Grade'),
  (12, 1, '10th Grade'),
  (13, 1, '11th Grade'),
  (14, 1, '12th Grade'),
  (21, 2, '9th Grade'),
  (22, 2, '10th Grade'),
  (23, 2, '11th Grade'),
  (24, 2, '12th Grade'),
  (31, 3, '9th Grade'),
  (32, 3, '10th Grade'),
  (33, 3, '11th Grade'),
  (34, 3, '12th Grade'),
  (41, 4, '9th Grade'),
  (42, 4, '10th Grade'),
  (43, 4, '11th Grade'),
  (44, 4, '12th Grade'),
  (51, 5, '9th Grade'),
  (52, 5, '10th Grade'),
  (53, 5, '11th Grade'),
  (54, 5, '12th Grade');

INSERT INTO equipment (eid, ename, price) VALUES
  (101, 'Notebook (Ruled)',            2.50),
  (102, 'Pencil',                      0.50),
  (103, 'Math Textbook - Algebra I',  45.00),
  (201, 'Laptop (Required)',         800.00),
  (202, 'Engineering Calculator',     35.00),
  (203, 'Physics Textbook - Advanced', 60.00),
  (901, 'Binder (3-ring)',             5.00),
  (902, 'Highlighters',                1.50);

-- Specific lists matching the backend mock:
--   Ben Gurion 9th (gid 11) -> the "1-9" list
--   ORT 12th      (gid 24) -> the "2-12" list
-- Every other grade gets the default list (901, 902).
INSERT INTO requirement (gid, eid, quantity) VALUES
  (11, 101, 5),
  (11, 102, 12),
  (11, 103, 1),
  (24, 201, 1),
  (24, 202, 1),
  (24, 203, 1),
  (12, 901, 2), (12, 902, 4),
  (13, 901, 2), (13, 902, 4),
  (14, 901, 2), (14, 902, 4),
  (21, 901, 2), (21, 902, 4),
  (22, 901, 2), (22, 902, 4),
  (23, 901, 2), (23, 902, 4),
  (31, 901, 2), (31, 902, 4),
  (32, 901, 2), (32, 902, 4),
  (33, 901, 2), (33, 902, 4),
  (34, 901, 2), (34, 902, 4),
  (41, 901, 2), (41, 902, 4),
  (42, 901, 2), (42, 902, 4),
  (43, 901, 2), (43, 902, 4),
  (44, 901, 2), (44, 902, 4),
  (51, 901, 2), (51, 902, 4),
  (52, 901, 2), (52, 902, 4),
  (53, 901, 2), (53, 902, 4),
  (54, 901, 2), (54, 902, 4);

INSERT INTO users (uid, uname, password) VALUES
  (1, 'user1', '1234'),
  (2, 'user2', '1234'),
  (3, 'admin',  '1234');

-- Sample carts: user 1 has the Ben Gurion 9th-grade list; user 2 has the ORT 12th list.
INSERT INTO cart_entry (ceid, gid, uid) VALUES
  (1, 11, 1),
  (2, 24, 2);

-- cart_item rows: one row per item *instance* (cart quantity = number of rows).
INSERT INTO cart_item (ceid, eid) VALUES
  -- cart 1 (Ben Gurion 9th)
  (1, 101), (1, 101),
  (1, 102),
  (1, 103),
  -- cart 2 (ORT 12th)
  (2, 201),
  (2, 202),
  (2, 203);

-- Purchase history so /api/history returns something meaningful.
INSERT INTO orders (oid, uid, gid, purchase_date, total_amount) VALUES
  (1, 1, 11, '2026-01-10 09:30:00', 53.50),
  (2, 1, 12, '2026-03-22 14:05:00', 16.00),
  (3, 2, 24, '2026-04-15 11:00:00', 895.00);

INSERT INTO order_item (oid, eid, quantity, price_at_purchase) VALUES
  (1, 101, 2, 2.50),
  (1, 102, 4, 0.50),
  (1, 103, 1, 45.00),
  (2, 901, 2, 5.00),
  (2, 902, 4, 1.50),
  (3, 201, 1, 800.00),
  (3, 202, 1, 35.00),
  (3, 203, 1, 60.00);

-- Re-align BIGSERIAL sequences so future inserts don't collide with seeded IDs.
SELECT setval(pg_get_serial_sequence('school',     'sid'),  (SELECT MAX(sid)  FROM school));
SELECT setval(pg_get_serial_sequence('grade',      'gid'),  (SELECT MAX(gid)  FROM grade));
SELECT setval(pg_get_serial_sequence('equipment',  'eid'),  (SELECT MAX(eid)  FROM equipment));
SELECT setval(pg_get_serial_sequence('requirement','rid'),  (SELECT MAX(rid)  FROM requirement));
SELECT setval(pg_get_serial_sequence('users',      'uid'),  (SELECT MAX(uid)  FROM users));
SELECT setval(pg_get_serial_sequence('cart_entry', 'ceid'), (SELECT MAX(ceid) FROM cart_entry));
SELECT setval(pg_get_serial_sequence('cart_item',  'ciid'), (SELECT MAX(ciid) FROM cart_item));
SELECT setval(pg_get_serial_sequence('orders',     'oid'),  (SELECT MAX(oid)  FROM orders));
SELECT setval(pg_get_serial_sequence('order_item', 'oiid'), (SELECT MAX(oiid) FROM order_item));
