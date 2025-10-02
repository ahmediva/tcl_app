-- Test RLS policies for article table
-- Run this in your Supabase SQL editor to check current policies

-- Check existing policies
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'article';

-- Test if anonymous access works
-- This should return data if RLS policy is correct
SELECT COUNT(*) as total_records FROM article;

-- Test specific query that the app uses
SELECT ArtNouvCode, ArtNomCommerce, ArtRue 
FROM article 
LIMIT 5;
