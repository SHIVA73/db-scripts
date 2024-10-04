-- Check if the column 'Department' exists in the 'finaltable' table
SET @columnExists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'finaltable'
    AND COLUMN_NAME = 'Department'
    AND TABLE_SCHEMA = 'sampletest'
);

-- If the column does not exist, add it
IF @columnExists = 0 THEN
    ALTER TABLE finaltable ADD COLUMN Department VARCHAR(255);
END IF;

