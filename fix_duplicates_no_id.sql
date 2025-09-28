-- Fixed SQL script for duplicate key constraint error
-- Updated to work without 'id' column

-- Option 1: Check what duplicates exist first
SELECT "ArtNouvCode", COUNT(*) as duplicate_count
FROM article 
GROUP BY "ArtNouvCode" 
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 10;

-- Option 2: Remove duplicates using ArtNouvCode as the identifier
-- This will keep only the first occurrence of each ArtNouvCode
WITH duplicates AS (
  SELECT "ArtNouvCode",
         ROW_NUMBER() OVER (PARTITION BY "ArtNouvCode" ORDER BY "ArtNouvCode") as rn
  FROM article
)
DELETE FROM article 
WHERE "ArtNouvCode" IN (
  SELECT "ArtNouvCode" FROM duplicates WHERE rn > 1
);

-- Option 3: If you want to clear all data and start fresh
-- WARNING: This deletes ALL existing data!
-- DELETE FROM article;

-- Option 4: Alternative approach - create a new table with unique records
-- CREATE TABLE article_clean AS
-- SELECT DISTINCT ON ("ArtNouvCode") *
-- FROM article
-- ORDER BY "ArtNouvCode";

-- Then drop the old table and rename the new one:
-- DROP TABLE article;
-- ALTER TABLE article_clean RENAME TO article;

-- Show results after cleanup
SELECT COUNT(*) as total_records FROM article;
SELECT COUNT(DISTINCT "ArtNouvCode") as unique_records FROM article;
SELECT 'Duplicate cleanup completed!' as status;
