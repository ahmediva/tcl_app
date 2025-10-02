-- Fix RLS policies for article table to allow anonymous users to read data
-- This migration allows public access to read article data while maintaining security

-- Create policy for anonymous users to read articles
CREATE POLICY "Anonymous users can read articles" 
ON article FOR SELECT 
TO anon 
USING (true);

-- Also allow anonymous users to read articles (redundant but explicit)
CREATE POLICY "Public can read articles" 
ON article FOR SELECT 
TO public 
USING (true);

-- Keep the existing authenticated user policies for write operations
-- The existing policies for INSERT, UPDATE, DELETE remain for authenticated users only
