-- Create ARRONDISSEMENT table for Supabase
CREATE TABLE arrondissement (
    code VARCHAR(2) PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL,
    date_etat TIMESTAMP NOT NULL DEFAULT NOW(),
    code_etat CHAR(1) NOT NULL DEFAULT 'A',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE arrondissement ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users to read arrondissements
CREATE POLICY "Authenticated users can read arrondissements" 
ON arrondissement FOR SELECT 
TO authenticated 
USING (true);

-- Create policy for authenticated users to insert arrondissements
CREATE POLICY "Authenticated users can insert arrondissements" 
ON arrondissement FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Create policy for authenticated users to update arrondissements
CREATE POLICY "Authenticated users can update arrondissements" 
ON arrondissement FOR UPDATE 
TO authenticated 
USING (true);

-- Create policy for authenticated users to delete arrondissements
CREATE POLICY "Authenticated users can delete arrondissements" 
ON arrondissement FOR DELETE 
TO authenticated 
USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_arrondissement_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_arrondissement_updated_at 
BEFORE UPDATE ON arrondissement 
FOR EACH ROW 
EXECUTE FUNCTION update_arrondissement_updated_at();

-- Insert some sample arrondissement data
INSERT INTO arrondissement (code, libelle, date_etat, code_etat) VALUES
('01', 'Arrondissement Central', NOW(), 'A'),
('02', 'Arrondissement Nord', NOW(), 'A'),
('03', 'Arrondissement Sud', NOW(), 'A'),
('04', 'Arrondissement Est', NOW(), 'A'),
('05', 'Arrondissement Ouest', NOW(), 'A');
