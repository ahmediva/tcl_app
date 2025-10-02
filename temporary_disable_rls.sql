-- Temporary fix: Disable RLS for testing
-- WARNING: This removes security, only use for testing!

-- Disable RLS temporarily
ALTER TABLE article DISABLE ROW LEVEL SECURITY;

-- Test query
SELECT COUNT(*) FROM article;

-- Re-enable RLS after testing
-- ALTER TABLE article ENABLE ROW LEVEL SECURITY;

-- Then add the correct policy:
-- CREATE POLICY "Anonymous users can read articles" 
-- ON article FOR SELECT 
-- TO anon 
-- USING (true);
