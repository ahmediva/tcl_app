-- =====================================================
-- FINAL ARTICLE TABLE SCHEMA - HOMOGENEOUS WITH FLUTTER MODEL
-- =====================================================
-- This script creates the article table with exact column names
-- matching the Flutter EtablissementModel (lowercase)
-- 
-- TCL CALCULATION FORMULA:
-- Montant TCL = max(0.2% × Chiffre d'affaires local + 0.1% × Exportations, Taxe immobilière)
-- =====================================================

-- Drop existing table if it exists (CAREFUL: This will delete all data!)
DROP TABLE IF EXISTS article CASCADE;

-- Create the article table with homogeneous column names
CREATE TABLE article (
    -- Primary identifier
    artnouvcode VARCHAR(255) PRIMARY KEY,           -- Article Nouveau Code (REQUIRED)
    
    -- Location information
    artadresse VARCHAR(255),                        -- Adresse complète
    
    -- People information
    artagent VARCHAR(255),                          -- Agent
    artoccup VARCHAR(255),                          -- Occupant
    artqualoccup VARCHAR(255),                      -- Qualité Occupation
    artproprietaire VARCHAR(255),                   -- Nom du propriétaire
    artredcode VARCHAR(8),                          -- CIN du propriétaire (max 8 digits)
    artteldecl INTEGER,                             -- Téléphone domicile (8 chiffres max)
    
    -- Business information
    artnomcommerce VARCHAR(255),                    -- Nom Commerce
    artcatart VARCHAR(10),                          -- Catégorie Article (Activité)
    
    -- Tax calculation fields
    artsurcouv DECIMAL(10,2),                       -- Surface Couverte (pour calcul taxe)
    artservitudesmunicipales INTEGER,                -- Nombre de servitudes municipales (1-5)
    artautresservitudes INTEGER,                     -- Autres servitudes (0 ou 1 - case à cocher)
    prixm2 DECIMAL(10,2),                           -- Prix par mètre carré (pour calcul taxe immobilière)
    arttauxpres DECIMAL(5,2),                        -- Taux Prestation (pour calcul taxe)
    artmnttaxe DECIMAL(10,2),                        -- Montant de la Taxe (calculé automatiquement)
    
    -- TCL calculation fields (Taxe sur les établissements commerciaux)
    artchiffreaffaireslocal DECIMAL(15,2),           -- Chiffre d'affaires brut local (0,2%)
    artexportations DECIMAL(15,2),                    -- Chiffre d'affaires exportations (0,1%)
    arttaxeimmobiliere DECIMAL(15,2),                 -- Taxe immobilière (minimum annuel)
    
    -- Period fields
    artdebper VARCHAR(10),                           -- Début Période
    artfinper VARCHAR(10),                           -- Fin Période
    
    -- Geographic coordinates
    artlatitude DECIMAL(10, 8),                      -- Latitude (ex: 36.8065)
    artlongitude DECIMAL(11, 8),                      -- Longitude (ex: 10.1815)
    
    -- Status and metadata
    artetat INTEGER DEFAULT 0,                      -- 1 paye taxe, 0 ne paye pas
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_article_artnouvcode ON article(artnouvcode);
CREATE INDEX idx_article_artnomcommerce ON article(artnomcommerce);
CREATE INDEX idx_article_artproprietaire ON article(artproprietaire);
CREATE INDEX idx_article_artredcode ON article(artredcode);
CREATE INDEX idx_article_artcatart ON article(artcatart);
CREATE INDEX idx_article_coordinates ON article(artlatitude, artlongitude);
CREATE INDEX idx_article_prixm2 ON article(prixm2);
CREATE INDEX idx_article_servitudes ON article(artservitudesmunicipales, artautresservitudes);

-- Enable Row Level Security
ALTER TABLE article ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Allow authenticated users to read all articles
CREATE POLICY "Allow authenticated read" ON article
    FOR SELECT USING (auth.role() = 'authenticated');

-- Allow authenticated users to insert articles
CREATE POLICY "Allow authenticated insert" ON article
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Allow authenticated users to update articles
CREATE POLICY "Allow authenticated update" ON article
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Allow authenticated users to delete articles
CREATE POLICY "Allow authenticated delete" ON article
    FOR DELETE USING (auth.role() = 'authenticated');

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_article_updated_at
    BEFORE UPDATE ON article
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Force PostgREST schema reload
NOTIFY pgrst, 'reload schema';



-- Verify the table structure
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'article' 
ORDER BY ordinal_position;

-- Display sample data
SELECT * FROM article LIMIT 5;

-- =====================================================
-- SUMMARY OF COLUMNS (MATCHING FLUTTER MODEL):
-- =====================================================
-- artnouvcode           -> artNouvCode (String, REQUIRED)
-- artagent              -> artAgent (String?)
-- artoccup              -> artOccup (String?)
-- artqualoccup          -> artQualOccup (String?)
-- artnomcommerce        -> artNomCommerce (String?)
-- artadresse            -> artAdresse (String?)
-- artproprietaire       -> artProprietaire (String?)
-- artredcode            -> artRedCode (String?)
-- artteldecl            -> artTelDecl (int?)
-- artcatart             -> artCatArt (String?)
-- artsurcouv            -> artSurCouv (double?)
-- artservitudesmunicipales -> artServitudesMunicipales (int?)
-- artautresservitudes    -> artAutresServitudes (int?)
-- prixm2                -> prixM2 (double?)
-- arttauxpres           -> artTauxPres (double?)
-- artmnttaxe            -> artMntTaxe (double?)
-- artchiffreaffaireslocal -> artChiffreAffairesLocal (double?)
-- artexportations       -> artExportations (double?)
-- arttaxeimmobiliere    -> artTaxeImmobiliere (double?)
-- artdebper             -> artDebPer (String?)
-- artfinper             -> artFinPer (String?)
-- artlatitude           -> artLatitude (double?)
-- artlongitude          -> artLongitude (double?)
-- artetat               -> artEtat (int?)
-- created_at            -> createdAt (DateTime?)
-- updated_at            -> updatedAt (DateTime?)
-- =====================================================
