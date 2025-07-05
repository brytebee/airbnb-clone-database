# Database Normalization Analysis to 3NF

## Current Schema Analysis

### 1NF (First Normal Form) Compliance
✅ **PASSED** - All tables satisfy 1NF requirements:
- Each column contains atomic values
- No repeating groups
- Each row is unique (primary keys defined)
- Column values are of a single type

### 2NF (Second Normal Form) Compliance
✅ **PASSED** - All tables satisfy 2NF requirements:
- All tables are in 1NF
- All non-key attributes are fully functionally dependent on the primary key
- No partial dependencies identified (all primary keys are single attributes)

### 3NF (Third Normal Form) Analysis

#### ❌ **VIOLATIONS IDENTIFIED**

**1. Location Redundancy in Property Table**
- **Issue**: The `location` field in the Property table stores complete address information as a single VARCHAR
- **Problem**: This violates 3NF because location components (city, state, country, zip) are not normalized
- **Impact**: Data redundancy, inconsistent formatting, difficult querying by location components

**2. Calculated Field Violation in Booking Table**
- **Issue**: `total_price` in Booking table can be calculated from `price_per_night * number_of_nights`
- **Problem**: This is a derived attribute that depends on other attributes, violating 3NF
- **Impact**: Data inconsistency risk, storage redundancy

## Recommended Normalization Steps

### Step 1: Normalize Location Data

**Create Location Table:**
```sql
CREATE TABLE Location (
    location_id UUID PRIMARY KEY,
    street_address VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Update Property Table:**
```sql
-- Remove location field, add location_id foreign key
ALTER TABLE Property 
DROP COLUMN location,
ADD COLUMN location_id UUID,
ADD FOREIGN KEY (location_id) REFERENCES Location(location_id);
```

### Step 2: Handle Calculated Fields

**Remove total_price from Booking Table:**
```sql
-- Remove total_price as it can be calculated
ALTER TABLE Booking DROP COLUMN total_price;
```

**Create a view or calculate dynamically:**
```sql
CREATE VIEW BookingWithTotal AS
SELECT 
    b.*,
    (p.price_per_night * (DATEDIFF(b.end_date, b.start_date))) AS total_price
FROM Booking b
JOIN Property p ON b.property_id = p.property_id;
```

### Step 3: Additional Improvements for Better Normalization

**Create PaymentMethod Table (Optional Enhancement):**
```sql
CREATE TABLE PaymentMethod (
    method_id UUID PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Update Payment table
ALTER TABLE Payment 
DROP COLUMN payment_method,
ADD COLUMN method_id UUID,
ADD FOREIGN KEY (method_id) REFERENCES PaymentMethod(method_id);
```

## Final 3NF-Compliant Schema

### Core Tables (Updated)

**User Table** - No changes needed
```sql
CREATE TABLE User (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Location Table** - New
```sql
CREATE TABLE Location (
    location_id UUID PRIMARY KEY,
    street_address VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Property Table** - Updated
```sql
CREATE TABLE Property (
    property_id UUID PRIMARY KEY,
    host_id UUID NOT NULL,
    location_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES User(user_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);
```

**Booking Table** - Updated
```sql
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);
```

**Payment Table** - No changes needed for basic 3NF
```sql
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);
```

**Review Table** - No changes needed
```sql
CREATE TABLE Review (
    review_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);
```

**Message Table** - No changes needed
```sql
CREATE TABLE Message (
    message_id UUID PRIMARY KEY,
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES User(user_id),
    FOREIGN KEY (recipient_id) REFERENCES User(user_id)
);
```

## Benefits of 3NF Compliance

1. **Eliminated Data Redundancy**: Location data is now centralized and reusable
2. **Improved Data Integrity**: No risk of calculated field inconsistencies
3. **Better Query Performance**: Structured location data enables efficient location-based queries
4. **Easier Maintenance**: Changes to location formats only need to be made in one place
5. **Scalability**: The normalized structure supports future enhancements more easily

## Migration Considerations

1. **Data Migration**: Existing location strings need to be parsed and inserted into the new Location table
2. **Application Updates**: Queries that previously used `total_price` need to be updated to calculate it dynamically
3. **Indexing**: Add appropriate indexes on `location_id` and frequently queried location fields
4. **Backward Compatibility**: Consider creating views to maintain compatibility with existing application code

## Verification of 3NF Compliance

After implementing these changes:
- ✅ **1NF**: All atomic values, no repeating groups
- ✅ **2NF**: No partial dependencies (all PKs are single attributes)
- ✅ **3NF**: No transitive dependencies, all non-key attributes depend only on primary keys
