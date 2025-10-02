-- Quick fix for RLS issue
-- Run this in your Supabase SQL Editor

-- Step 1: Check current policies
SELECT policyname, roles, cmd FROM pg_policies WHERE tablename = 'article';

-- Step 2: Drop existing restrictive policies (if any)
DROP POLICY IF EXISTS "Authenticated users can read articles" ON article;

-- Step 3: Create new policy that allows anonymous access
CREATE POLICY "Allow anonymous read access" 
ON article FOR SELECT 
TO anon, authenticated, public
USING (true);

-- Step 4: Test the fix
SELECT COUNT(*) as total_records FROM article;
