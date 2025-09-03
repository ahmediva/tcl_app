-- Create USERS table for Supabase
CREATE TABLE USERS (
    UserCode VARCHAR(30) NOT NULL,
    UserName VARCHAR(100) NOT NULL,
    UserEmail VARCHAR(100) NULL,
    UserRole VARCHAR(20) NOT NULL,
    UserPassword VARCHAR(255) NOT NULL, -- hashed
    UserActive BIT NOT NULL DEFAULT TRUE,
    UserDateCreation TIMESTAMP NOT NULL DEFAULT NOW(),
    UserLastLogin TIMESTAMP NULL,
    CONSTRAINT PK_USERS PRIMARY KEY (UserCode)
);

-- Enable Row Level Security
ALTER TABLE USERS ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users to read users
CREATE POLICY "Authenticated users can read users" 
ON USERS FOR SELECT 
TO authenticated 
USING (true);

-- Create policy for authenticated users to insert users
CREATE POLICY "Authenticated users can insert users" 
ON USERS FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Create policy for authenticated users to update users
CREATE POLICY "Authenticated users can update users" 
ON USERS FOR UPDATE 
TO authenticated 
USING (true);

-- Create policy for authenticated users to delete users
CREATE POLICY "Authenticated users can delete users" 
ON USERS FOR DELETE 
TO authenticated 
USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$ 
BEGIN 
    NEW.updated_at = NOW(); 
    RETURN NEW; 
END; 
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_users_updated_at 
BEFORE UPDATE ON USERS 
FOR EACH ROW 
EXECUTE FUNCTION update_users_updated_at();
