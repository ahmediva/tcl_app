-- Create CATEGORIETCL table for Supabase
-- Table de référence pour les catégories de la taxe sur les établissements
-- à caractère commercial et industriel (TCL)
-- CatCode: Code numérique de la catégorie TCL
-- CatLibelle: Libellé descriptif de la catégorie
-- CatEtat: État de la catégorie (A=Actif, I=Inactif, etc.)
CREATE TABLE CATEGORIETCL (
    NUMERO INTEGER PRIMARY KEY,
    CatCode INTEGER NOT NULL,
    CatDate TIMESTAMP NULL,
    CatLibelle VARCHAR(150) NULL,
    CatDateEffet TIMESTAMP NULL,
    CatDateFinEffet TIMESTAMP NULL,
    CatEtat CHAR(1) NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE CATEGORIETCL ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users to read CATEGORIETCL
CREATE POLICY "Authenticated users can read CATEGORIETCL" 
ON CATEGORIETCL FOR SELECT 
TO authenticated 
USING (true);

-- Create policy for authenticated users to insert CATEGORIETCL
CREATE POLICY "Authenticated users can insert CATEGORIETCL" 
ON CATEGORIETCL FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Create policy for authenticated users to update CATEGORIETCL
CREATE POLICY "Authenticated users can update CATEGORIETCL" 
ON CATEGORIETCL FOR UPDATE 
TO authenticated 
USING (true);

-- Create policy for authenticated users to delete CATEGORIETCL
CREATE POLICY "Authenticated users can delete CATEGORIETCL" 
ON CATEGORIETCL FOR DELETE 
TO authenticated 
USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_CATEGORIETCL_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_CATEGORIETCL_updated_at 
BEFORE UPDATE ON CATEGORIETCL 
FOR EACH ROW 
EXECUTE FUNCTION update_CATEGORIETCL_updated_at();

-- Insert some sample CATEGORIETCL data (optional)
INSERT INTO CATEGORIETCL (NUMERO, CatCode, CatLibelle, CatDate, CatDateEffet, CatDateFinEffet, CatEtat) VALUES
(1, 101, 'Catégorie 1', NOW(), NOW(), NULL, 'A'),
(2, 102, 'Catégorie 2', NOW(), NOW(), NULL, 'A');
