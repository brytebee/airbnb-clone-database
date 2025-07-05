# Sample Data for Airbnb Clone Database

## Overview
This script populates the property booking database with realistic sample data that demonstrates typical platform usage patterns. The data includes multiple user types, international properties, completed bookings with payments, and authentic user interactions.

## Data Summary

| Table | Records | Description |
|-------|---------|-------------|
| User | 10 | 1 admin, 4 hosts, 5 guests |
| Location | 8 | Properties across US and Europe |
| Property | 8 | Diverse property types and price ranges |
| Booking | 9 | Mix of confirmed, pending, and canceled bookings |
| Payment | 6 | Payments for confirmed bookings |
| Review | 6 | Guest reviews with ratings 3-5 stars |
| Message | 11 | Pre-booking inquiries and host-guest communication |

## Key Features

### Realistic User Profiles
* **Admin**: Platform administrator account
* **Hosts**: Property owners from different countries
* **Guests**: Active travelers with booking history

### Geographic Diversity
* **US Properties**: Miami, New York, Los Angeles
* **European Properties**: London, Paris, Madrid, Rome, Berlin
* **Price Range**: $129.99 - $899.99 per night

### Complete Booking Lifecycle
* **Confirmed Bookings**: With corresponding payments and reviews
* **Pending Bookings**: Awaiting host approval
* **Canceled Bookings**: Demonstrating cancellation scenarios

### Payment Methods
* Credit card, PayPal, and Stripe transactions
* Amounts match calculated booking totals

### Authentic Communications
* Pre-booking inquiries and responses
* Check-in instruction requests
* Guest services and support
* Post-stay follow-ups

## Usage Instructions

### Running the Script
1. **Prerequisites**: Ensure the database schema is created
2. **Execute**: Run the entire script or sections as needed
3. **Verification**: Check the final SELECT statements for data counts

```sql
-- Run the complete script
mysql -u username -p database_name < sample_data.sql

-- Or execute sections individually
```

### Data Relationships
The sample data maintains referential integrity:
* All foreign keys reference valid primary keys
* Booking dates are logical (end > start)
* Payment amounts match calculated totals
* Reviews are from actual guests who stayed

### Calculated Fields
Total prices are calculated dynamically:
```sql
total_price = price_per_night × (end_date - start_date)
```
Example: Miami condo booking = $299.99 × 5 nights = $1,499.95

## Data Scenarios

### Successful Bookings
* **Jessica → Sarah's Miami Condo**: Perfect 5-star experience
* **David → Sarah's NYC Penthouse**: Great stay with minor street noise
* **Lisa → Michael's Hollywood Villa**: Luxury experience with pool

### International Travel
* **James → Emma's London Flat**: Authentic British experience
* **Maria → Emma's Paris Apartment**: Classic Parisian charm
* **Jessica → Carlos's Madrid Loft**: Central location with rooftop terrace

### Host-Guest Interactions
* Responsive pre-booking communication
* Helpful local recommendations
* Quick issue resolution
* Positive post-stay follow-up

## Testing Scenarios

### Query Examples

**Find available properties for dates:**
```sql
SELECT p.name, l.city, l.country 
FROM Property p 
JOIN Location l ON p.location_id = l.location_id
WHERE p.property_id NOT IN (
    SELECT property_id FROM Booking 
    WHERE status = 'confirmed' 
    AND start_date <= '2024-12-31' 
    AND end_date >= '2024-12-01'
);
```

**Calculate host earnings:**
```sql
SELECT 
    CONCAT(u.first_name, ' ', u.last_name) as host_name,
    COUNT(b.booking_id) as total_bookings,
    SUM(py.amount) as total_earnings
FROM User u
JOIN Property p ON u.user_id = p.host_id
JOIN Booking b ON p.property_id = b.property_id
JOIN Payment py ON b.booking_id = py.booking_id
WHERE u.role = 'host'
GROUP BY u.user_id;
```

**Find properties with highest ratings:**
```sql
SELECT 
    p.name,
    l.city,
    l.country,
    AVG(r.rating) as avg_rating,
    COUNT(r.review_id) as review_count
FROM Property p
JOIN Location l ON p.location_id = l.location_id
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id
ORDER BY avg_rating DESC;
```

**Analyze booking patterns by month:**
```sql
SELECT 
    MONTHNAME(b.start_date) as month,
    COUNT(*) as booking_count,
    SUM(py.amount) as total_revenue
FROM Booking b
JOIN Payment py ON b.booking_id = py.booking_id
WHERE b.status = 'confirmed'
GROUP BY MONTH(b.start_date)
ORDER BY MONTH(b.start_date);
```

## Sample User Credentials

### Admin Account
* **Email**: admin@bookingapp.com
* **Role**: admin
* **Access**: Full platform management

### Host Accounts
* **Sarah Johnson**: sarah.johnson@email.com (US properties)
* **Michael Chen**: michael.chen@email.com (Hollywood villa)
* **Emma Williams**: emma.williams@email.com (European properties)
* **Carlos Rodriguez**: carlos.rodriguez@email.com (Madrid/Rome/Berlin)

### Guest Accounts
* **Jessica Brown**: jessica.brown@email.com (Active traveler)
* **David Wilson**: david.wilson@email.com (Business traveler)
* **Lisa Taylor**: lisa.taylor@email.com (Luxury seeker)
* **James Anderson**: james.anderson@email.com (International traveler)
* **Maria Garcia**: maria.garcia@email.com (European explorer)

## Data Integrity Notes

### Password Security
* All passwords are hashed using bcrypt
* Sample hashes provided for testing purposes
* Production systems should use proper authentication

### UUID Format
* All IDs use UUID format for uniqueness
* Foreign key relationships are properly maintained
* No orphaned records exist in the sample data

### Date Consistency
* Created dates follow logical chronological order
* Booking dates are in the future from creation dates
* Payment dates match booking confirmation dates

## Customization Options

### Adding More Data
To expand the dataset:
1. **New Users**: Follow the UUID pattern for IDs
2. **New Properties**: Ensure location_id references exist
3. **New Bookings**: Verify date ranges don't overlap
4. **New Messages**: Maintain sender/recipient relationships

### Modifying Existing Data
When updating sample data:
1. Preserve foreign key relationships
2. Maintain date logic (end > start dates)
3. Keep payment amounts consistent with bookings
4. Ensure review ratings are 1-5 scale

## Troubleshooting

### Common Issues
* **Foreign key constraints**: Ensure referenced records exist
* **Date format errors**: Use 'YYYY-MM-DD HH:MM:SS' format
* **Duplicate IDs**: Each UUID must be unique
* **Missing required fields**: All NOT NULL columns need values

### Verification Queries
```sql
-- Check for orphaned records
SELECT COUNT(*) FROM Booking 
WHERE property_id NOT IN (SELECT property_id FROM Property);

-- Verify payment amounts match booking totals
SELECT b.booking_id, 
       (p.price_per_night * DATEDIFF(b.end_date, b.start_date)) as calculated_total,
       py.amount as payment_amount
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
JOIN Payment py ON b.booking_id = py.booking_id
WHERE ABS((p.price_per_night * DATEDIFF(b.end_date, b.start_date)) - py.amount) > 0.01;
```

## Performance Considerations

### Indexing Recommendations
The sample data works well with these indexes:
* `idx_booking_dates` on (start_date, end_date)
* `idx_property_location` on (location_id)
* `idx_user_role` on (role)
* `idx_review_rating` on (rating)

### Query Optimization
* Use appropriate JOINs for relationship queries
* Filter by status for active bookings
* Consider date range indexes for availability searches

## Development Environment Setup

### Quick Start
1. Create database schema
2. Run sample data script
3. Verify data with count queries
4. Test application functionality

### Testing Framework
Use this data for:
* Unit testing booking logic
* Integration testing payment flows
* User interface testing with realistic data
* Performance testing with moderate dataset

---

*This sample data provides a solid foundation for developing and testing my airbnb clone platform. The realistic scenarios and complete data relationships make it ideal for both development and demonstration purposes.*