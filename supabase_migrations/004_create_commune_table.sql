-- Create Commune table for Supabase
-- Table de référence pour les communes
-- CodeM: Code de la commune (5 caractères)
-- Libelle: Nom de la commune
-- MINISTERE: Ministère de tutelle
-- ADRESSE: Adresse de la mairie
-- Responsable: Nom du responsable
-- Receveur: Nom du receveur
-- DansLe: Localisation/Zone géographique
CREATE TABLE Commune (
    CodeM VARCHAR(5) PRIMARY KEY,
    Libelle VARCHAR(100) NULL,
    MINISTERE VARCHAR(100) NULL,
    ADRESSE VARCHAR(255) NULL,
    Responsable VARCHAR(100) NULL,
    Receveur VARCHAR(100) NULL,
    DansLe VARCHAR(50) NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE Commune ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users to read Commune
CREATE POLICY "Authenticated users can read Commune" 
ON Commune FOR SELECT 
TO authenticated 
USING (true);

-- Create policy for authenticated users to insert Commune
CREATE POLICY "Authenticated users can insert Commune" 
ON Commune FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Create policy for authenticated users to update Commune
CREATE POLICY "Authenticated users can update Commune" 
ON Commune FOR UPDATE 
TO authenticated 
USING (true);

-- Create policy for authenticated users to delete Commune
CREATE POLICY "Authenticated users can delete Commune" 
ON Commune FOR DELETE 
TO authenticated 
USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_Commune_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_Commune_updated_at 
BEFORE UPDATE ON Commune 
FOR EACH ROW 
EXECUTE FUNCTION update_Commune_updated_at();

-- Insert some sample Commune data (optional)
INSERT INTO Commune (CodeM, Libelle, MINISTERE, ADRESSE, Responsable, Receveur, DansLe) VALUES
('1001', 'Commune Centrale', 'Ministère de l''Intérieur', 'Place de la Mairie', 'Maire Principal', 'Receveur Central', 'Zone Urbaine'),
('1002', 'Commune Nord', 'Ministère de l''Intérieur', 'Avenue du Nord', 'Maire du Nord', 'Receveur Nord', 'Zone Rurale'),
('1003', 'Commune Sud', 'Ministère de l''Intérieur', 'Rue du Sud', 'Maire du Sud', 'Receveur Sud', 'Zone Côtière');
