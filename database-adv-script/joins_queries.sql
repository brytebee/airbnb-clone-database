-- 1. INNER JOIN: Retrieve all bookings with their respective users
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.last_name,
    u.email
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id;

-- 2. LEFT JOIN: Retrieve all properties and their reviews (including properties with no reviews)
SELECT 
    p.property_id,
    p.name AS property_name,
    p.price_per_night,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
ORDER BY p.property_id, r.created_at DESC;

-- 3. FULL OUTER JOIN: Retrieve all users and all bookings (even orphaned records)
-- Note: MySQL doesn't support FULL OUTER JOIN natively, so we use UNION of LEFT and RIGHT JOINs
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id

UNION

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status
FROM User u
RIGHT JOIN Booking b ON u.user_id = b.user_id
WHERE u.user_id IS NULL;

-- Alternative for databases that support FULL OUTER JOIN (PostgreSQL, SQL Server):
/*
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status
FROM User u
FULL OUTER JOIN Booking b ON u.user_id = b.user_id;
*/