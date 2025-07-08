-- Database Indexes for Airbnb Clone Database
-- Objective: Optimize query performance by creating strategic indexes

-- 1. USER TABLE INDEXES
-- Email is used frequently for login and lookups
CREATE INDEX idx_user_email ON User(email);

-- Role-based queries are common for admin functions
CREATE INDEX idx_user_role ON User(role);

-- Created_at for user analytics and reporting
CREATE INDEX idx_user_created_at ON User(created_at);

-- 2. BOOKING TABLE INDEXES
-- User_id is heavily used in JOIN operations
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Property_id is used in JOIN operations and property analytics
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Status filtering is common (pending, confirmed, canceled)
CREATE INDEX idx_booking_status ON Booking(status);

-- Date range queries are very frequent
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Composite index for date range queries
CREATE INDEX idx_booking_date_range ON Booking(start_date, end_date);

-- Created_at for booking analytics
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Composite index for user bookings with status
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);

-- 3. PROPERTY TABLE INDEXES
-- Host_id for host-related queries
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Location_id for location-based searches
CREATE INDEX idx_property_location_id ON Property(location_id);

-- Price filtering and sorting
CREATE INDEX idx_property_price ON Property(price_per_night);

-- Created_at for property analytics
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Updated_at for recently modified properties
CREATE INDEX idx_property_updated_at ON Property(updated_at);

-- 4. LOCATION TABLE INDEXES
-- City and country for location searches
CREATE INDEX idx_location_city ON Location(city);
CREATE INDEX idx_location_country ON Location(country);

-- Composite index for city-country searches
CREATE INDEX idx_location_city_country ON Location(city, country);

-- Geospatial queries (if using location-based searches)
CREATE INDEX idx_location_coordinates ON Location(latitude, longitude);

-- 5. REVIEW TABLE INDEXES
-- Property_id for property review queries
CREATE INDEX idx_review_property_id ON Review(property_id);

-- User_id for user review history
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Rating for filtering high-rated properties
CREATE INDEX idx_review_rating ON Review(rating);

-- Created_at for recent reviews
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for property ratings
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- 6. PAYMENT TABLE INDEXES
-- Booking_id for payment-booking relationships
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Payment_date for financial reporting
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Payment_method for payment analytics
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- 7. MESSAGE TABLE INDEXES
-- Sender and recipient for message queries
CREATE INDEX idx_message_sender_id ON Message(sender_id);
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Sent_at for message chronology
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for conversation threads
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- 8. PERFORMANCE ANALYSIS COMMANDS

-- Check index usage
SHOW INDEX FROM User;
SHOW INDEX FROM Booking;
SHOW INDEX FROM Property;

-- Analyze query performance before indexing
EXPLAIN SELECT * FROM Booking b 
JOIN User u ON b.user_id = u.user_id 
WHERE b.start_date >= '2024-01-01' AND b.status = 'confirmed';

-- Analyze query performance after indexing
EXPLAIN SELECT * FROM Booking b 
JOIN User u ON b.user_id = u.user_id 
WHERE b.start_date >= '2024-01-01' AND b.status = 'confirmed';

-- Monitor index effectiveness
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    CARDINALITY,
    SUB_PART,
    NULLABLE
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'airbnb_clone'
ORDER BY TABLE_NAME, INDEX_NAME;

-- Index maintenance commands
ANALYZE TABLE User, Booking, Property, Location, Review, Payment, Message;
OPTIMIZE TABLE User, Booking, Property, Location, Review, Payment, Message;