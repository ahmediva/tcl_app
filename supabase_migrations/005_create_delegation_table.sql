-- Create DELEGATION table for Supabase
CREATE TABLE delegation (
    CodeDeleg INT PRIMARY KEY,
    CodeGouv INT,
    LibelleFr VARCHAR(255),
    LibelleAr VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE delegation ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users to read delegations
CREATE POLICY "Authenticated users can read delegations" 
ON delegation FOR SELECT 
TO authenticated 
USING (true);

-- Create policy for authenticated users to insert delegations
CREATE POLICY "Authenticated users can insert delegations" 
ON delegation FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Create policy for authenticated users to update delegations
CREATE POLICY "Authenticated users can update delegations" 
ON delegation FOR UPDATE 
TO authenticated 
USING (true);

-- Create policy for authenticated users to delete delegations
CREATE POLICY "Authenticated users can delete delegations" 
ON delegation FOR DELETE 
TO authenticated 
USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_delegation_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_delegation_updated_at 
BEFORE UPDATE ON delegation 
FOR EACH ROW 
EXECUTE FUNCTION update_delegation_updated_at();

-- Insert some sample delegation data
INSERT INTO delegation (CodeDeleg, CodeGouv, LibelleFr, LibelleAr) VALUES
(1, 1, 'Délégation 1', 'تفويض 1'),
(2, 1, 'Délégation 2', 'تفويض 2'),
(3, 2, 'Délégation 3', 'تفويض 3');
