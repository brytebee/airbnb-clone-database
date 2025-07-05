-- ===================================
-- SAMPLE DATA POPULATION SCRIPT
-- Property Booking Platform Database
-- ===================================

-- Clear existing data (uncomment if needed)
-- DELETE FROM Message;
-- DELETE FROM Payment;
-- DELETE FROM Review;
-- DELETE FROM Booking;
-- DELETE FROM Property;
-- DELETE FROM Location;
-- DELETE FROM User;

-- ===================================
-- USER DATA
-- ===================================

INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
-- Admins
('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Admin', 'Smith', 'admin@bookingapp.com', '$2b$12$KIx8zOmF7YqZ8X5QW2J9eOKEFGHI3456789abcdef', '+1-555-0001', 'admin', '2024-01-01 10:00:00'),

-- Hosts
('b2c3d4e5-f6g7-8901-bcde-f23456789012', 'Sarah', 'Johnson', 'sarah.johnson@email.com', '$2b$12$LJy9aPnG8ZrA9Y6RX3K0fPLFGHI4567890bcdefg', '+1-555-0102', 'host', '2024-01-15 14:30:00'),
('c3d4e5f6-g7h8-9012-cdef-345678901234', 'Michael', 'Chen', 'michael.chen@email.com', '$2b$12$MKz0bQoH9AsB0Z7SY4L1gQMGHI5678901cdefgh', '+1-555-0203', 'host', '2024-01-20 09:15:00'),
('d4e5f6g7-h8i9-0123-defg-456789012345', 'Emma', 'Williams', 'emma.williams@email.com', '$2b$12$NL10cRpI0BtC1A8TZ5M2hRNHI6789012defghi', '+44-20-7123-4567', 'host', '2024-02-01 16:45:00'),
('e5f6g7h8-i9j0-1234-efgh-567890123456', 'Carlos', 'Rodriguez', 'carlos.rodriguez@email.com', '$2b$12$OM21dSqJ1CuD2B9UA6N3iSOI789012345efghij', '+34-91-234-5678', 'host', '2024-02-10 11:20:00'),

-- Guests
('f6g7h8i9-j0k1-2345-fghi-678901234567', 'Jessica', 'Brown', 'jessica.brown@email.com', '$2b$12$PN32eTrK2DvE3C0VB7O4jTPJ8901234567fghijk', '+1-555-0304', 'guest', '2024-02-15 08:30:00'),
('g7h8i9j0-k1l2-3456-ghij-789012345678', 'David', 'Wilson', 'david.wilson@email.com', '$2b$12$QO43fUsL3EwF4D1WC8P5kUQK901234567ghijkl', '+1-555-0405', 'guest', '2024-02-20 13:15:00'),
('h8i9j0k1-l2m3-4567-hijk-890123456789', 'Lisa', 'Taylor', 'lisa.taylor@email.com', '$2b$12$RP54gVtM4FxG5E2XD9Q6lVRL01234567hijklm', '+1-555-0506', 'guest', '2024-03-01 10:45:00'),
('i9j0k1l2-m3n4-5678-ijkl-901234567890', 'James', 'Anderson', 'james.anderson@email.com', '$2b$12$SQ65hWuN5GyH6F3YE0R7mWSM12345678ijklmn', '+1-555-0607', 'guest', '2024-03-05 15:30:00'),
('j0k1l2m3-n4o5-6789-jklm-012345678901', 'Maria', 'Garcia', 'maria.garcia@email.com', '$2b$12$TR76iXvO6HzI7G4ZF1S8nXTN23456789jklmno', '+1-555-0708', 'guest', '2024-03-10 12:00:00');

-- ===================================
-- LOCATION DATA
-- ===================================

INSERT INTO Location (location_id, street_address, city, state_province, country, postal_code, latitude, longitude, created_at) VALUES
-- US Locations
('loc1-2345-6789-abcd-ef1234567890', '123 Ocean Drive', 'Miami', 'Florida', 'United States', '33139', 25.7617, -80.1918, '2024-01-15 14:30:00'),
('loc2-3456-789a-bcde-f23456789012', '456 Park Avenue', 'New York', 'New York', 'United States', '10016', 40.7589, -73.9851, '2024-01-20 09:15:00'),
('loc3-4567-89ab-cdef-345678901234', '789 Sunset Boulevard', 'Los Angeles', 'California', 'United States', '90028', 34.0983, -118.3267, '2024-02-01 16:45:00'),

-- International Locations
('loc4-5678-9abc-defg-456789012345', '12 Kensington Gardens', 'London', 'England', 'United Kingdom', 'W2 3XA', 51.5074, -0.1278, '2024-02-10 11:20:00'),
('loc5-6789-abcd-efgh-567890123456', '34 Calle Mayor', 'Madrid', 'Madrid', 'Spain', '28013', 40.4168, -3.7038, '2024-02-15 08:30:00'),
('loc6-789a-bcde-fghi-678901234567', '56 Champs-Élysées', 'Paris', 'Île-de-France', 'France', '75008', 48.8566, 2.3522, '2024-02-20 13:15:00'),
('loc7-89ab-cdef-ghij-789012345678', '78 Via del Corso', 'Rome', 'Lazio', 'Italy', '00186', 41.9028, 12.4964, '2024-03-01 10:45:00'),
('loc8-9abc-defg-hijk-890123456789', '90 Kastanienallee', 'Berlin', 'Berlin', 'Germany', '10435', 52.5200, 13.4050, '2024-03-05 15:30:00');

-- ===================================
-- PROPERTY DATA
-- ===================================

INSERT INTO Property (property_id, host_id, location_id, name, description, price_per_night, created_at, updated_at) VALUES
-- Sarah's Properties
('prop1-234-567-890-abc123456789', 'b2c3d4e5-f6g7-8901-bcde-f23456789012', 'loc1-2345-6789-abcd-ef1234567890', 'Luxury Beachfront Condo', 'Stunning 2BR/2BA oceanfront condo with panoramic views of Miami Beach. Features modern amenities, private balcony, and direct beach access. Perfect for couples or small families.', 299.99, '2024-01-15 14:30:00', '2024-01-15 14:30:00'),
('prop2-345-678-901-bcd234567890', 'b2c3d4e5-f6g7-8901-bcde-f23456789012', 'loc2-3456-789a-bcde-f23456789012', 'Manhattan Penthouse Suite', 'Elegant 3BR penthouse in the heart of Manhattan with city skyline views. High-end finishes, full kitchen, and rooftop terrace. Walking distance to Central Park and Times Square.', 599.99, '2024-01-16 10:00:00', '2024-01-16 10:00:00'),

-- Michael's Properties
('prop3-456-789-012-cde345678901', 'c3d4e5f6-g7h8-9012-cdef-345678901234', 'loc3-4567-89ab-cdef-345678901234', 'Hollywood Hills Villa', 'Spectacular 4BR villa in the Hollywood Hills with infinity pool and city views. Modern design, gourmet kitchen, and private gym. Celebrity-style luxury living.', 899.99, '2024-01-20 09:15:00', '2024-01-20 09:15:00'),

-- Emma's Properties
('prop4-567-890-123-def456789012', 'd4e5f6g7-h8i9-0123-defg-456789012345', 'loc4-5678-9abc-defg-456789012345', 'Cozy London Flat', 'Charming 1BR flat in Kensington with traditional British charm. Recently renovated with modern amenities while preserving historic character. Close to Hyde Park and museums.', 189.99, '2024-02-01 16:45:00', '2024-02-01 16:45:00'),
('prop5-678-901-234-efg567890123', 'd4e5f6g7-h8i9-0123-defg-456789012345', 'loc6-789a-bcde-fghi-678901234567', 'Parisian Apartment', 'Elegant 2BR apartment near Champs-Élysées with classic Parisian architecture. High ceilings, French doors, and city views. Perfect base for exploring the City of Light.', 349.99, '2024-02-02 11:30:00', '2024-02-02 11:30:00'),

-- Carlos's Properties
('prop6-789-012-345-fgh678901234', 'e5f6g7h8-i9j0-1234-efgh-567890123456', 'loc5-6789-abcd-efgh-567890123456', 'Madrid City Center Loft', 'Modern 2BR loft in the heart of Madrid with industrial design and rooftop terrace. Walking distance to Prado Museum and Retiro Park. Ideal for culture enthusiasts.', 229.99, '2024-02-10 11:20:00', '2024-02-10 11:20:00'),
('prop7-890-123-456-ghi789012345', 'e5f6g7h8-i9j0-1234-efgh-567890123456', 'loc7-89ab-cdef-ghij-789012345678', 'Roman Holiday Apartment', 'Authentic 1BR apartment in historic Rome center. Stone walls, original frescoes, and modern comforts. Steps from Trevi Fountain and Pantheon.', 269.99, '2024-02-11 14:15:00', '2024-02-11 14:15:00'),
('prop8-901-234-567-hij890123456', 'e5f6g7h8-i9j0-1234-efgh-567890123456', 'loc8-9abc-defg-hijk-890123456789', 'Berlin Modern Studio', 'Minimalist studio in trendy Prenzlauer Berg. Contemporary design, full kitchen, and bike rental included. Perfect for solo travelers or couples exploring Berlin.', 129.99, '2024-02-12 16:45:00', '2024-02-12 16:45:00');

-- ===================================
-- BOOKING DATA
-- ===================================

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, status, created_at) VALUES
-- Confirmed Bookings
('book1-234-567-890-abc123456789', 'prop1-234-567-890-abc123456789', 'f6g7h8i9-j0k1-2345-fghi-678901234567', '2024-06-15', '2024-06-20', 'confirmed', '2024-03-15 10:30:00'),
('book2-345-678-901-bcd234567890', 'prop2-345-678-901-bcd234567890', 'g7h8i9j0-k1l2-3456-ghij-789012345678', '2024-07-01', '2024-07-05', 'confirmed', '2024-03-20 14:45:00'),
('book3-456-789-012-cde345678901', 'prop3-456-789-012-cde345678901', 'h8i9j0k1-l2m3-4567-hijk-890123456789', '2024-08-10', '2024-08-15', 'confirmed', '2024-04-01 09:15:00'),
('book4-567-890-123-def456789012', 'prop4-567-890-123-def456789012', 'i9j0k1l2-m3n4-5678-ijkl-901234567890', '2024-09-05', '2024-09-10', 'confirmed', '2024-04-15 16:20:00'),
('book5-678-901-234-efg567890123', 'prop5-678-901-234-efg567890123', 'j0k1l2m3-n4o5-6789-jklm-012345678901', '2024-10-12', '2024-10-18', 'confirmed', '2024-05-01 11:30:00'),
('book6-789-012-345-fgh678901234', 'prop6-789-012-345-fgh678901234', 'f6g7h8i9-j0k1-2345-fghi-678901234567', '2024-11-20', '2024-11-25', 'confirmed', '2024-05-15 13:45:00'),

-- Pending Bookings
('book7-890-123-456-ghi789012345', 'prop7-890-123-456-ghi789012345', 'g7h8i9j0-k1l2-3456-ghij-789012345678', '2024-12-01', '2024-12-05', 'pending', '2024-06-01 15:00:00'),
('book8-901-234-567-hij890123456', 'prop8-901-234-567-hij890123456', 'h8i9j0k1-l2m3-4567-hijk-890123456789', '2024-12-15', '2024-12-20', 'pending', '2024-06-10 10:30:00'),

-- Canceled Booking
('book9-012-345-678-ijk901234567', 'prop1-234-567-890-abc123456789', 'i9j0k1l2-m3n4-5678-ijkl-901234567890', '2024-05-01', '2024-05-05', 'canceled', '2024-02-15 12:00:00');

-- ===================================
-- PAYMENT DATA
-- ===================================

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
-- Payments for confirmed bookings
('pay1-234-567-890-abc123456789', 'book1-234-567-890-abc123456789', 1499.95, '2024-03-15 10:35:00', 'credit_card'),
('pay2-345-678-901-bcd234567890', 'book2-345-678-901-bcd234567890', 2399.96, '2024-03-20 14:50:00', 'paypal'),
('pay3-456-789-012-cde345678901', 'book3-456-789-012-cde345678901', 4499.95, '2024-04-01 09:20:00', 'stripe'),
('pay4-567-890-123-def456789012', 'book4-567-890-123-def456789012', 949.95, '2024-04-15 16:25:00', 'credit_card'),
('pay5-678-901-234-efg567890123', 'book5-678-901-234-efg567890123', 2099.94, '2024-05-01 11:35:00', 'paypal'),
('pay6-789-012-345-fgh678901234', 'book6-789-012-345-fgh678901234', 1149.95, '2024-05-15 13:50:00', 'stripe');

-- ===================================
-- REVIEW DATA
-- ===================================

INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
-- Reviews for completed stays
('rev1-234-567-890-abc123456789', 'prop1-234-567-890-abc123456789', 'f6g7h8i9-j0k1-2345-fghi-678901234567', 5, 'Absolutely incredible stay! The beachfront location was perfect and the condo exceeded all expectations. Sarah was an amazing host - very responsive and helpful. The views from the balcony were breathtaking. Will definitely book again!', '2024-06-22 14:30:00'),

('rev2-345-678-901-bcd234567890', 'prop2-345-678-901-bcd234567890', 'g7h8i9j0-k1l2-3456-ghij-789012345678', 4, 'Great location in Manhattan with stunning city views. The penthouse was luxurious and well-appointed. Only minor issue was some noise from the street, but overall an excellent experience. Would recommend to anyone visiting NYC.', '2024-07-07 16:45:00'),

('rev3-456-789-012-cde345678901', 'prop3-456-789-012-cde345678901', 'h8i9j0k1-l2m3-4567-hijk-890123456789', 5, 'Hollywood Hills villa was a dream come true! The infinity pool and city views were spectacular. Michael provided excellent local recommendations. The house was immaculate and had everything we needed for a perfect LA vacation.', '2024-08-17 11:20:00'),

('rev4-567-890-123-def456789012', 'prop4-567-890-123-def456789012', 'i9j0k1l2-m3n4-5678-ijkl-901234567890', 4, 'Charming flat in a perfect London location. Emma was very welcoming and the flat had authentic British character while being modern and comfortable. Easy access to Hyde Park and museums. Minor issue with heating but quickly resolved.', '2024-09-12 09:15:00'),

('rev5-678-901-234-efg567890123', 'prop5-678-901-234-efg567890123', 'j0k1l2m3-n4o5-6789-jklm-012345678901', 5, 'Magnifique! This Parisian apartment was everything we hoped for and more. The location near Champs-Élysées was perfect for exploring the city. Emma was incredibly helpful with recommendations. The apartment was beautifully decorated and very clean.', '2024-10-20 15:30:00'),

('rev6-789-012-345-fgh678901234', 'prop6-789-012-345-fgh678901234', 'f6g7h8i9-j0k1-2345-fghi-678901234567', 3, 'Nice loft in central Madrid with good amenities. Carlos was responsive to our questions. The rooftop terrace was a great feature. However, the neighborhood was a bit noisy at night and the WiFi was inconsistent. Overall decent value for the location.', '2024-11-27 12:45:00');

-- ===================================
-- MESSAGE DATA
-- ===================================

INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- Pre-booking inquiries
('msg1-234-567-890-abc123456789', 'f6g7h8i9-j0k1-2345-fghi-678901234567', 'b2c3d4e5-f6g7-8901-bcde-f23456789012', 'Hi Sarah! I\'m interested in booking your beachfront condo for June 15-20. Is it available? Also, is there parking available?', '2024-03-10 14:30:00'),
('msg2-345-678-901-bcd234567890', 'b2c3d4e5-f6g7-8901-bcde-f23456789012', 'f6g7h8i9-j0k1-2345-fghi-678901234567', 'Hi Jessica! Yes, the condo is available for those dates. There\'s complimentary valet parking included. The beach access is direct from the building. Would you like me to send you more details about the amenities?', '2024-03-10 15:45:00'),
('msg3-456-789-012-cde345678901', 'f6g7h8i9-j0k1-2345-fghi-678901234567', 'b2c3d4e5-f6g7-8901-bcde-f23456789012', 'That sounds perfect! I\'ll proceed with the booking. Thank you for the quick response!', '2024-03-10 16:00:00'),

-- Booking confirmation and check-in details
('msg4-567-890-123-def456789012', 'g7h8i9j0-k1l2-3456-ghij-789012345678', 'b2c3d4e5-f6g7-8901-bcde-f23456789012', 'Hi Sarah, I just booked your Manhattan penthouse for July 1-5. Could you please share the check-in instructions?', '2024-03-20 15:00:00'),
('msg5-678-901-234-efg567890123', 'b2c3d4e5-f6g7-8901-bcde-f23456789012', 'g7h8i9j0-k1l2-3456-ghij-789012345678', 'Hi David! Thank you for booking. I\'ll send you detailed check-in instructions 24 hours before your arrival. The doorman will have your keys. Looking forward to hosting you!', '2024-03-20 15:30:00'),

-- Host-to-guest communication
('msg6-789-012-345-fgh678901234', 'c3d4e5f6-g7h8-9012-cdef-345678901234', 'h8i9j0k1-l2m3-4567-hijk-890123456789', 'Hi Lisa! Welcome to LA! I hope you\'re enjoying the villa. Just wanted to check if you need any restaurant recommendations or local tips. The infinity pool is best enjoyed during sunset!', '2024-08-12 18:00:00'),
('msg7-890-123-456-ghi789012345', 'h8i9j0k1-l2m3-4567-hijk-890123456789', 'c3d4e5f6-g7h8-9012-cdef-345678901234', 'Hi Michael! Thank you so much for the warm welcome. The villa is absolutely stunning! We\'d love some restaurant recommendations, especially for seafood. The sunset by the pool was magical last night!', '2024-08-12 19:30:00'),

-- Guest services and support
('msg8-901-234-567-hij890123456', 'i9j0k1l2-m3n4-5678-ijkl-901234567890', 'd4e5f6g7-h8i9-0123-defg-456789012345', 'Hi Emma, we\'re having a small issue with the heating in the London flat. Could you help us figure out how to adjust it?', '2024-09-07 20:00:00'),
('msg9-012-345-678-ijk901234567', 'd4e5f6g7-h8i9-0123-defg-456789012345', 'i9j0k1l2-m3n4-5678-ijkl-901234567890', 'Hi James! So sorry about that. The thermostat is a bit tricky - it\'s the digital panel next to the kitchen. I\'ll send you a photo with instructions. I can also pop by tomorrow if you need help!', '2024-09-07 20:15:00'),

-- Post-stay follow-up
('msg10-123-456-789-jkl012345678', 'j0k1l2m3-n4o5-6789-jklm-012345678901', 'd4e5f6g7-h8i9-0123-defg-456789012345', 'Hi Emma! We just checked out of your beautiful Parisian apartment. Thank you for such a wonderful stay! We left a review and would love to book again next time we visit Paris.', '2024-10-18 11:00:00'),
('msg11-234-567-890-klm123456789', 'd4e5f6g7-h8i9-0123-defg-456789012345', 'j0k1l2m3-n4o5-6789-jklm-012345678901', 'Hi Maria! Thank you so much for the lovely review! It was a pleasure hosting you. You\'re always welcome back - I\'ll make sure to keep those dates available for you next year. Safe travels!', '2024-10-18 12:30:00');

-- ===================================
-- DATA POPULATION COMPLETE
-- ===================================

-- Verify data insertion
SELECT 'Users' as table_name, COUNT(*) as record_count FROM User
UNION ALL
SELECT 'Locations', COUNT(*) FROM Location
UNION ALL
SELECT 'Properties', COUNT(*) FROM Property
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Booking
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payment
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Review
UNION ALL
SELECT 'Messages', COUNT(*) FROM Message;

-- Show sample booking totals (calculated dynamically)
SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) as guest_name,
    p.name as property_name,
    b.start_date,
    b.end_date,
    DATEDIFF(b.end_date, b.start_date) as nights,
    p.price_per_night,
    (p.price_per_night * DATEDIFF(b.end_date, b.start_date)) as total_price,
    b.status
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
ORDER BY b.created_at;