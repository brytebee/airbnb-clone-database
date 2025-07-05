# Airbnb clone Database Schema

## Overview

This database schema is designed for a property booking platform (similar to Airbnb) that allows users to list properties, make bookings, process payments, write reviews, and communicate with each other. The schema is fully normalized to Third Normal Form (3NF) to ensure data integrity, minimize redundancy, and optimize query performance.

## Features

- **User Management**: Support for guests, hosts, and administrators
- **Property Listings**: Detailed property information with location data
- **Booking System**: Complete booking lifecycle management
- **Payment Processing**: Multiple payment method support
- **Review System**: Property ratings and comments
- **Messaging**: Direct communication between users
- **Location Services**: Normalized location data with geographic coordinates

## Database Schema

### Entity Relationship Overview

```
User (1:N) Property (1:N) Booking (1:1) Payment
User (1:N) Review (N:1) Property
User (1:N) Message (N:1) User
Property (N:1) Location
```

## Table Definitions

### User Table
Stores user account information for all platform participants.

**Fields:**
- `user_id` (UUID, PK): Unique identifier for each user
- `first_name` (VARCHAR): User's first name
- `last_name` (VARCHAR): User's last name
- `email` (VARCHAR, UNIQUE): User's email address for login
- `password_hash` (VARCHAR): Encrypted password
- `phone_number` (VARCHAR, OPTIONAL): Contact phone number
- `role` (ENUM): User type - guest, host, or admin
- `created_at` (TIMESTAMP): Account creation timestamp

**Indexes:**
- Primary key on `user_id`
- Unique index on `email`

### Location Table
Normalized location data to eliminate redundancy and enable efficient geographic queries.

**Fields:**
- `location_id` (UUID, PK): Unique identifier for each location
- `street_address` (VARCHAR, OPTIONAL): Street address
- `city` (VARCHAR): City name
- `state_province` (VARCHAR, OPTIONAL): State or province
- `country` (VARCHAR): Country name
- `postal_code` (VARCHAR, OPTIONAL): ZIP/postal code
- `latitude` (DECIMAL): Geographic latitude coordinate
- `longitude` (DECIMAL): Geographic longitude coordinate
- `created_at` (TIMESTAMP): Location record creation timestamp

**Indexes:**
- Primary key on `location_id`
- Composite index on `city, country` for location searches
- Spatial index on `latitude, longitude` for geographic queries

### Property Table
Contains property listing information.

**Fields:**
- `property_id` (UUID, PK): Unique identifier for each property
- `host_id` (UUID, FK): Reference to the property owner
- `location_id` (UUID, FK): Reference to location details
- `name` (VARCHAR): Property name/title
- `description` (TEXT): Detailed property description
- `price_per_night` (DECIMAL): Nightly rental rate
- `created_at` (TIMESTAMP): Property listing creation timestamp
- `updated_at` (TIMESTAMP): Last modification timestamp

**Relationships:**
- Belongs to one User (host)
- Belongs to one Location
- Has many Bookings
- Has many Reviews

### Booking Table
Manages property reservations and booking lifecycle.

**Fields:**
- `booking_id` (UUID, PK): Unique identifier for each booking
- `property_id` (UUID, FK): Reference to booked property
- `user_id` (UUID, FK): Reference to guest making booking
- `start_date` (DATE): Check-in date
- `end_date` (DATE): Check-out date
- `status` (ENUM): Booking status - pending, confirmed, or canceled
- `created_at` (TIMESTAMP): Booking creation timestamp

**Relationships:**
- Belongs to one Property
- Belongs to one User (guest)
- Has one Payment

**Business Rules:**
- Total price is calculated as: `price_per_night * (end_date - start_date)`
- End date must be after start date
- Bookings cannot overlap for the same property

### Payment Table
Tracks payment transactions for bookings.

**Fields:**
- `payment_id` (UUID, PK): Unique identifier for each payment
- `booking_id` (UUID, FK): Reference to associated booking
- `amount` (DECIMAL): Payment amount
- `payment_date` (TIMESTAMP): When payment was processed
- `payment_method` (ENUM): Payment method used - credit_card, paypal, or stripe

**Relationships:**
- Belongs to one Booking

### Review Table
Stores guest reviews and ratings for properties.

**Fields:**
- `review_id` (UUID, PK): Unique identifier for each review
- `property_id` (UUID, FK): Reference to reviewed property
- `user_id` (UUID, FK): Reference to reviewer
- `rating` (INTEGER): Numeric rating (1-5 scale)
- `comment` (TEXT): Written review text
- `created_at` (TIMESTAMP): Review creation timestamp

**Relationships:**
- Belongs to one Property
- Belongs to one User (reviewer)

**Constraints:**
- Rating must be between 1 and 5 inclusive
- Users can only review properties they have booked

### Message Table
Enables direct communication between platform users.

**Fields:**
- `message_id` (UUID, PK): Unique identifier for each message
- `sender_id` (UUID, FK): Reference to message sender
- `recipient_id` (UUID, FK): Reference to message recipient
- `message_body` (TEXT): Message content
- `sent_at` (TIMESTAMP): Message timestamp

**Relationships:**
- Belongs to one User (sender)
- Belongs to one User (recipient)

## Normalization Details

### 3NF Compliance

The schema achieves Third Normal Form (3NF) through:

1. **First Normal Form (1NF)**: All attributes contain atomic values, no repeating groups
2. **Second Normal Form (2NF)**: No partial dependencies; all non-key attributes depend on the complete primary key
3. **Third Normal Form (3NF)**: No transitive dependencies; all non-key attributes depend only on the primary key

### Key Normalization Decisions

- **Location Separation**: Location data extracted into separate table to eliminate redundancy
- **Calculated Field Removal**: `total_price` removed from Booking table (calculated dynamically)
- **Referential Integrity**: All foreign key relationships properly defined

## Common Queries

### Find Available Properties
```sql
SELECT p.*, l.city, l.country 
FROM Property p 
JOIN Location l ON p.location_id = l.location_id
WHERE p.property_id NOT IN (
    SELECT property_id FROM Booking 
    WHERE status = 'confirmed' 
    AND start_date <= '2024-12-31' 
    AND end_date >= '2024-12-01'
);
```

### Calculate Booking Total
```sql
SELECT b.*, 
       (p.price_per_night * DATEDIFF(b.end_date, b.start_date)) AS total_price
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.booking_id = 'your-booking-id';
```

### Get Property Reviews with Ratings
```sql
SELECT r.*, u.first_name, u.last_name
FROM Review r
JOIN User u ON r.user_id = u.user_id
WHERE r.property_id = 'your-property-id'
ORDER BY r.created_at DESC;
```

## Performance Considerations

### Recommended Indexes

```sql
-- User table
CREATE INDEX idx_user_role ON User(role);
CREATE INDEX idx_user_created_at ON User(created_at);

-- Location table
CREATE INDEX idx_location_city_country ON Location(city, country);
CREATE INDEX idx_location_coordinates ON Location(latitude, longitude);

-- Property table
CREATE INDEX idx_property_host ON Property(host_id);
CREATE INDEX idx_property_location ON Property(location_id);
CREATE INDEX idx_property_price ON Property(price_per_night);

-- Booking table
CREATE INDEX idx_booking_property ON Booking(property_id);
CREATE INDEX idx_booking_user ON Booking(user_id);
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);
CREATE INDEX idx_booking_status ON Booking(status);

-- Payment table
CREATE INDEX idx_payment_booking ON Payment(booking_id);
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Review table
CREATE INDEX idx_review_property ON Review(property_id);
CREATE INDEX idx_review_user ON Review(user_id);
CREATE INDEX idx_review_rating ON Review(rating);

-- Message table
CREATE INDEX idx_message_sender ON Message(sender_id);
CREATE INDEX idx_message_recipient ON Message(recipient_id);
CREATE INDEX idx_message_sent_at ON Message(sent_at);
```

## Data Integrity Rules

1. **Referential Integrity**: All foreign keys must reference valid primary keys
2. **Business Logic**: Booking end dates must be after start dates
3. **User Roles**: Only hosts can create properties
4. **Review Constraints**: Users can only review properties they've booked
5. **Payment Validation**: Payment amounts must match calculated booking totals

## Migration Notes

When implementing this schema:

1. **Data Migration**: Existing location strings need parsing into Location table
2. **Application Updates**: Remove `total_price` calculations from application code
3. **Index Creation**: Add indexes after data population for better performance
4. **Constraint Addition**: Add business logic constraints after data validation

## Technologies

- **Database**: MySQL 8.0+ (or PostgreSQL 12+)
- **UUID Support**: Requires UUID() or gen_random_uuid() functions
- **Spatial Features**: Geographic indexing for location-based queries
- **JSON Support**: Consider adding JSON fields for flexible property attributes

## Contributing

When modifying this schema:

1. Maintain 3NF compliance
2. Update this README with changes
3. Add appropriate indexes for new query patterns
4. Ensure referential integrity is preserved
5. Test migration scripts thoroughly

---

*Last Updated: July 2025*