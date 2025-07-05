-- 1. Non-correlated subquery: Properties with average rating > 4.0
SELECT 
    p.property_id,
    p.name,
    p.price_per_night,
    p.description
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);

-- Alternative using EXISTS (often more efficient):
SELECT 
    p.property_id,
    p.name,
    p.price_per_night,
    p.description
FROM Property p
WHERE EXISTS (
    SELECT 1
    FROM Review r
    WHERE r.property_id = p.property_id
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);

-- 2. Correlated subquery: Users who have made more than 3 bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3;

-- Bonus: Get the actual booking count for verification
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (
        SELECT COUNT(*)
        FROM Booking b
        WHERE b.user_id = u.user_id
    ) as booking_count
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3
ORDER BY booking_count DESC;

-- 3. Additional complex subquery examples:

-- Find properties that have never been booked (non-correlated)
SELECT 
    p.property_id,
    p.name,
    p.price_per_night
FROM Property p
WHERE p.property_id NOT IN (
    SELECT DISTINCT b.property_id
    FROM Booking b
    WHERE b.property_id IS NOT NULL
);

-- Find users whose latest booking was in the last 30 days (correlated)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM User u
WHERE (
    SELECT MAX(b.created_at)
    FROM Booking b
    WHERE b.user_id = u.user_id
) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Find properties with above-average pricing in their location (correlated)
SELECT 
    p.property_id,
    p.name,
    p.price_per_night,
    l.city,
    l.country
FROM Property p
JOIN Location l ON p.location_id = l.location_id
WHERE p.price_per_night > (
    SELECT AVG(p2.price_per_night)
    FROM Property p2
    JOIN Location l2 ON p2.location_id = l2.location_id
    WHERE l2.city = l.city AND l2.country = l.country
);