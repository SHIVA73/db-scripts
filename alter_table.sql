-- List of tables, columns, and desired data types
SET @columnsToCheck = 'finaltable.Department VARCHAR(255), finaltable.EmployeeName VARCHAR(100), othertable.Age INT';

-- Loop through each table-column pair
SET @counter = 1;
SET @totalColumns = 3; -- Number of column-table pairs to check

WHILE @counter <= @totalColumns DO
    -- Extract table, column, and data type from the list
    SET @tableColumnDataType = (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(@columnsToCheck, ',', @counter), ',', -1));
    SET @tableName = (SELECT SUBSTRING_INDEX(@tableColumnDataType, '.', 1));
    SET @columnName = (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(@tableColumnDataType, '.', 2), ' ', 1));
    SET @desiredDataType = (SELECT SUBSTRING_INDEX(@tableColumnDataType, ' ', -1));

    -- Check if the column exists in the current table
    SELECT COUNT(*)
    INTO @columnExists
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tableName
    AND COLUMN_NAME = @columnName
    AND TABLE_SCHEMA = 'sampletest';

    -- If column exists, check the data type
    IF @columnExists = 1 THEN
        SELECT COLUMN_TYPE
        INTO @currentDataType
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @tableName
        AND COLUMN_NAME = @columnName
        AND TABLE_SCHEMA = 'sampletest';

        -- Check if the data type matches the desired one
        IF @currentDataType != @desiredDataType THEN
            -- Alter the column data type
            SET @alterColumnStatement = CONCAT('ALTER TABLE ', @tableName, ' MODIFY ', @columnName, ' ', @desiredDataType, ';');
            PREPARE stmt FROM @alterColumnStatement;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        ELSE
            SELECT CONCAT('Column ', @columnName, ' already has the desired data type in table ', @tableName);
        END IF;
    ELSE
        -- Add the column if it doesn't exist
        SET @alterTableStatement = CONCAT('ALTER TABLE ', @tableName, ' ADD COLUMN ', @columnName, ' ', @desiredDataType, ';');
        PREPARE stmt FROM @alterTableStatement;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    -- Move to the next column-table pair
    SET @counter = @counter + 1;
END WHILE;
