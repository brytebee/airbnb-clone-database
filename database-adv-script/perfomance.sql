-- Query Performance Analysis and Optimization
-- Objective: Analyze and optimize complex queries for better performance

-- 1. INITIAL COMPLEX QUERY (Before Optimization)
-- Retrieves all bookings with user details, property details, and payment details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    b.created_at as booking_created,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    p.property_id,
    p.name as property_name,
    p.description,
    p.price_per_night,
    p.created_at as property_created,
    l.street_address,
    l.city,
    l.state_province,
    l.country,
    l.postal_code,
    py.payment_id,
    py.amount,
    py.payment_date,
    py.payment_method,
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Location l ON p.location_id = l.location_id
JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment py ON b.booking_id = py.booking_id
ORDER BY b.created_at DESC;

-- 2. ANALYZE QUERY PERFORMANCE
-- Check execution plan before optimization
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    b.created_at as booking_created,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    p.property_id,
    p.name as property_name,
    p.description,
    p.price_per_night,
    p.created_at as property_created,
    l.street_address,
    l.city,
    l.state_province,
    l.country,
    l.postal_code,
    py.payment_id,
    py.amount,
    py.payment_date,
    py.payment_method,
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Location l ON p.location_id = l.location_id
JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment py ON b.booking_id = py.booking_id
ORDER BY b.created_at DESC;

-- 3. OPTIMIZED QUERY VERSION 1 (Reduce unnecessary columns)
-- Only select essential columns to reduce data transfer
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    CONCAT(u.first_name, ' ', u.last_name) as guest_name,
    u.email as guest_email,
    p.name as property_name,
    CONCAT(l.city, ', ', l.country) as location,
    p.price_per_night,
    py.amount as payment_amount,
    py.payment_method
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Location l ON p.location_id = l.location_id
LEFT JOIN Payment py ON b.booking_id = py.booking_id
ORDER BY b.created_at DESC;

-- 4. OPTIMIZED QUERY VERSION 2 (Add WHERE clause for filtering)
-- Add date range filtering to reduce dataset size
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    CONCAT(u.first_name, ' ', u.last_name) as guest_name,
    u.email as guest_email,
    p.name as property_name,
    CONCAT(l.city, ', ', l.country) as location,
    p.price_per_night,
    py.amount as payment_amount,
    py.payment_method
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Location l ON p.location_id = l.location_id
LEFT JOIN Payment py ON b.booking_id = py.booking_id
WHERE b.created_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    AND b.status IN ('confirmed', 'pending')
ORDER BY b.created_at DESC
LIMIT 1000;

-- 5. OPTIMIZED QUERY VERSION 3 (Use subquery for payments)
-- Separate payment info to avoid LEFT JOIN on large payment table
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    CONCAT(u.first_name, ' ', u.last_name) as guest_name,
    u.email as guest_email,
    p.name as property_name,
    CONCAT(l.city, ', ', l.country) as location,
    p.price_per_night,
    (SELECT py.amount FROM Payment py WHERE py.booking_id = b.booking_id LIMIT 1) as payment_amount,
    (SELECT py.payment_method FROM Payment py WHERE py.booking_id = b.booking_id LIMIT 1) as payment_method
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Location l ON p.location_id = l.location_id
WHERE b.created_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    AND b.status IN ('confirmed', 'pending')
ORDER BY b.created_at DESC
LIMIT 1000;

-- 6. PERFORMANCE MONITORING QUERIES

-- Enable query profiling
SET profiling = 1;

-- Run the optimized query
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    CONCAT(u.first_name, ' ', u.last_name) as guest_name,
    p.name as property_name,
    CONCAT(l.city, ', ', l.country) as location,
    p.price_per_night
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Location l ON p.location_id = l.location_id
WHERE b.created_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY b.created_at DESC
LIMIT 100;

-- Show profiling results
SHOW PROFILES;

-- Get detailed profile for last query
SHOW PROFILE FOR QUERY 1;

-- 7. ALTERNATIVE APPROACH: MATERIALIZED VIEW CONCEPT
-- Create a view for frequently accessed booking details
CREATE VIEW booking_summary AS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    b.created_at,
    CONCAT(u.first_name, ' ', u.last_name) as guest_name,
    u.email as guest_email,
    p.name as property_name,
    p.price_per_night,
    CONCAT(l.city, ', ', l.country) as location
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Location l ON p.location_id = l.location_id;

-- Use the view for better performance
SELECT * FROM booking_summary 
WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY created_at DESC
LIMIT 100;

-- 8. QUERY OPTIMIZATION ANALYSIS

-- Check slow query log settings
SHOW VARIABLES LIKE 'slow_query_log%';
SHOW VARIABLES LIKE 'long_query_time';

-- Enable slow query logging
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;

-- Check index usage for optimization
SHOW INDEX FROM Booking;
SHOW INDEX FROM User;
SHOW INDEX FROM Property;