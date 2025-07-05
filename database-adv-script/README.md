# Airbnb Clone Database - Complex SQL Queries with Joins

## Overview
This project demonstrates mastery of SQL joins through complex queries on an Airbnb clone database. The database follows a 3NF-compliant schema with proper normalization and referential integrity.

## Database Schema
The database includes 7 main tables:
- **User**: Stores user information (guests, hosts, admins)
- **Location**: Geographical data for properties
- **Property**: Property listings with host and location relationships
- **Booking**: Reservation records linking users to properties
- **Payment**: Payment transactions for bookings
- **Review**: Property ratings and comments
- **Message**: Communication between users

## Query Tasks Completed

### 1. INNER JOIN Query
**Objective**: Retrieve all bookings with their respective users

This query returns only bookings that have valid user associations, excluding any orphaned booking records.

### 2. LEFT JOIN Query
**Objective**: Retrieve all properties and their reviews (including properties with no reviews)

This query shows all properties from the database, whether they have reviews or not. Properties without reviews will show NULL values for review fields.

### 3. FULL OUTER JOIN Query
**Objective**: Retrieve all users and all bookings (even orphaned records)

This query returns all users and all bookings, including:
- Users who have never made a booking
- Bookings that may exist without valid user references (orphaned records)

**Note**: MySQL doesn't support FULL OUTER JOIN natively, so the query uses a UNION of LEFT and RIGHT JOINs to achieve the same result.

## Technical Details

### Join Types Used
- **INNER JOIN**: Returns only matching records from both tables
- **LEFT JOIN**: Returns all records from the left table and matching records from the right table
- **FULL OUTER JOIN**: Returns all records from both tables (simulated in MySQL using UNION)

### Key Features
- Proper foreign key relationships maintained
- UUID primary keys for better scalability
- Timestamp tracking for audit purposes
- Enumerated values for constrained fields (status, role, payment_method)

## Database Compatibility
The main queries work with MySQL. An alternative FULL OUTER JOIN syntax is provided for PostgreSQL and SQL Server compatibility.

## Usage
1. Execute the schema creation script to set up the database
2. Populate tables with sample data
3. Run the join queries to retrieve the requested information

This project demonstrates practical SQL skills essential for database-driven applications and real-world data analysis scenarios.