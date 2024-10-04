-- Check if the column 'Department' exists in the 'finaltable' table
SELECT COUNT(*)
INTO @columnExists
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'finaltable'
AND COLUMN_NAME = 'Department'
AND TABLE_SCHEMA = 'sampletest';

-- If the column does not exist, dynamically alter the table
SET @alterTableStatement = IF(@columnExists = 0, 
    'ALTER TABLE finaltable ADD COLUMN Department VARCHAR(255);', 
    'SELECT "Column already exists";'
);

-- Prepare and execute the dynamic SQL statement
PREPARE stmt FROM @alterTableStatement;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
