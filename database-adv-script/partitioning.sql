-- Table Partitioning for Airbnb Clone Database
-- Objective: Implement partitioning on Booking table to optimize large dataset queries

-- 1. DROP EXISTING BOOKING TABLE (if needed for recreation)
-- DROP TABLE IF EXISTS Booking;

-- 2. CREATE PARTITIONED BOOKING TABLE
-- Partition by RANGE based on start_date (monthly partitions)
CREATE TABLE Booking_Partitioned (
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date),
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
) 
PARTITION BY RANGE (YEAR(start_date) * 100 + MONTH(start_date)) (
    PARTITION p202401 VALUES LESS THAN (202402),
    PARTITION p202402 VALUES LESS THAN (202403),
    PARTITION p202403 VALUES LESS THAN (202404),
    PARTITION p202404 VALUES LESS THAN (202405),
    PARTITION p202405 VALUES LESS THAN (202406),
    PARTITION p202406 VALUES LESS THAN (202407),
    PARTITION p202407 VALUES LESS THAN (202408),
    PARTITION p202408 VALUES LESS THAN (202409),
    PARTITION p202409 VALUES LESS THAN (202410),
    PARTITION p202410 VALUES LESS THAN (202411),
    PARTITION p202411 VALUES LESS THAN (202412),
    PARTITION p202412 VALUES LESS THAN (202501),
    PARTITION p202501 VALUES LESS THAN (202502),
    PARTITION p202502 VALUES LESS THAN (202503),
    PARTITION p202503 VALUES LESS THAN (202504),
    PARTITION p202504 VALUES LESS THAN (202505),
    PARTITION p202505 VALUES LESS THAN (202506),
    PARTITION p202506 VALUES LESS THAN (202507),
    PARTITION p202507 VALUES LESS THAN (202508),
    PARTITION p202508 VALUES LESS THAN (202509),
    PARTITION p202509 VALUES LESS THAN (202510),
    PARTITION p202510 VALUES LESS THAN (202511),
    PARTITION p202511 VALUES LESS THAN (202512),
    PARTITION p202512 VALUES LESS THAN (202601),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 3. CREATE INDEXES ON PARTITIONED TABLE
-- Recreate essential indexes for the partitioned table
CREATE INDEX idx_booking_part_user_id ON Booking_Partitioned(user_id);
CREATE INDEX idx_booking_part_property_id ON Booking_Partitioned(property_id);
CREATE INDEX idx_booking_part_status ON Booking_Partitioned(status);
CREATE INDEX idx_booking_part_created_at ON Booking_Partitioned(created_at);

-- 4. ALTERNATIVE PARTITIONING STRATEGIES

-- Option A: Quarterly partitions (for less frequent partition maintenance)
/*
CREATE TABLE Booking_Quarterly (
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date),
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
) 
PARTITION BY RANGE (QUARTER(start_date) + YEAR(start_date) * 10) (
    PARTITION p2024_q1 VALUES LESS THAN (20242),
    PARTITION p2024_q2 VALUES LESS THAN (20243),
    PARTITION p2024_q3 VALUES LESS THAN (20244),
    PARTITION p2024_q4 VALUES LESS THAN (20251),
    PARTITION p2025_q1 VALUES LESS THAN (20252),
    PARTITION p2025_q2 VALUES LESS THAN (20253),
    PARTITION p2025_q3 VALUES LESS THAN (20254),
    PARTITION p2025_q4 VALUES LESS THAN (20261),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
*/

-- Option B: Hash partitioning by user_id (for user-based queries)
/*
CREATE TABLE Booking_User_Hash (
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, user_id),
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
) 
PARTITION BY HASH(CRC32(user_id))
PARTITIONS 8;
*/

-- 5. PERFORMANCE TEST QUERIES

-- Test 1: Query specific date range (should only scan relevant partitions)
EXPLAIN PARTITIONS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.last_name
FROM Booking_Partitioned b
JOIN User u ON b.user_id = u.user_id
WHERE b.start_date >= '2024-06-01' 
    AND b.start_date < '2024-08-01'
    AND b.status = 'confirmed';

-- Test 2: Query current month bookings
EXPLAIN PARTITIONS
SELECT COUNT(*) as current_month_bookings
FROM Booking_Partitioned
WHERE start_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
    AND start_date < DATE_ADD(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH);

-- Test 3: Query last 3 months of bookings
EXPLAIN PARTITIONS
SELECT 
    DATE_FORMAT(start_date, '%Y-%m') as booking_month,
    COUNT(*) as booking_count,
    SUM(CASE WHEN status = 'confirmed' THEN 1 ELSE 0 END) as confirmed_bookings
FROM Booking_Partitioned
WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY DATE_FORMAT(start_date, '%Y-%m')
ORDER BY booking_month;

-- 6. PARTITION MAINTENANCE COMMANDS

-- Add new partition for future month
ALTER TABLE Booking_Partitioned 
ADD PARTITION (PARTITION p202601 VALUES LESS THAN (202602));

-- Drop old partition (be careful with this in production!)
-- ALTER TABLE Booking_Partitioned DROP PARTITION p202401;

-- Check partition information
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH,
    PARTITION_EXPRESSION,
    PARTITION_DESCRIPTION
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = 'airbnb_clone' 
    AND TABLE_NAME = 'Booking_Partitioned';

-- 7. PERFORMANCE COMPARISON QUERIES

-- Before partitioning (simulate with regular table)
SET @start_time = NOW(6);
SELECT COUNT(*) FROM Booking 
WHERE start_date >= '2024-06-01' AND start_date < '2024-08-01';
SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) as execution_time_microseconds;

-- After partitioning
SET @start_time = NOW(6);
SELECT COUNT(*) FROM Booking_Partitioned 
WHERE start_date >= '2024-06-01' AND start_date < '2024-08-01';
SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) as execution_time_microseconds;

-- 8. PARTITION PRUNING VERIFICATION

-- Check which partitions are being accessed
EXPLAIN PARTITIONS
SELECT * FROM Booking_Partitioned 
WHERE start_date = '2024-07-15';

-- Multiple partition access
EXPLAIN PARTITIONS
SELECT * FROM Booking_Partitioned 
WHERE start_date >= '2024-06-15' AND start_date <= '2024-08-15';

-- 9. MONITORING AND MAINTENANCE SCRIPT

-- Create a procedure to automatically add future partitions
DELIMITER //
CREATE PROCEDURE AddFuturePartitions()
BEGIN
    DECLARE next_year INT;
    DECLARE next_month INT;
    DECLARE partition_name VARCHAR(10);
    DECLARE partition_value INT;
    
    SET next_year = YEAR(CURDATE());
    SET next_month = MONTH(CURDATE()) + 3; -- Add 3 months ahead
    
    IF next_month > 12 THEN
        SET next_year = next_year + 1;
        SET next_month = next_month - 12;
    END IF;
    
    SET partition_name = CONCAT('p', next_year, LPAD(next_month, 2, '0'));
    SET partition_value = next_year * 100 + next_month + 1;
    
    SET @sql = CONCAT('ALTER TABLE Booking_Partitioned ADD PARTITION (PARTITION ', 
                     partition_name, ' VALUES LESS THAN (', partition_value, '))');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- 10. PERFORMANCE REPORT TEMPLATE

/*
PARTITIONING PERFORMANCE REPORT
================================

Test Environment:
- Table: Booking_Partitioned
- Partitioning Strategy: RANGE by start_date (monthly)
- Number of Partitions: 25 (24 months + future)
- Test Data Size: [Insert actual data size]

Performance Improvements Observed:

1. Date Range Queries:
   - Before Partitioning: [X] seconds
   - After Partitioning: [Y] seconds
   - Improvement: [Z]% faster

2. Partition Pruning:
   - Single month queries now scan only 1 partition instead of entire table
   - 3-month range queries scan only 3 partitions

3. Maintenance Operations:
   - Old data can be dropped by partition (faster than DELETE)
   - New partitions can be added without affecting existing data

4. Index Performance:
   - Indexes are smaller per partition
   - Query planning is more efficient

Recommendations:
- Monitor partition sizes and adjust strategy if needed
- Implement automated partition maintenance
- Consider sub-partitioning for extremely large datasets
*/