-- Quick fix for duplicate key constraint error
-- Choose one of these options:

-- Option 1: Clear all existing data (if you want to start fresh)
-- WARNING: This deletes ALL existing data!
-- DELETE FROM article;

-- Option 2: Remove only duplicate records (keeps first occurrence)
WITH duplicates AS (
  SELECT id,
         ROW_NUMBER() OVER (PARTITION BY "ArtNouvCode" ORDER BY id) as rn
  FROM article
)
DELETE FROM article 
WHERE id IN (
  SELECT id FROM duplicates WHERE rn > 1
);

-- Option 3: Check what duplicates exist first
SELECT "ArtNouvCode", COUNT(*) as duplicate_count
FROM article 
GROUP BY "ArtNouvCode" 
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 10;

-- After running one of the above options, try importing your CSV again
