-- =====================================================
-- TCL MOBILE APP - ARTICLE TABLE SCHEMA
-- =====================================================

-- Create the article table
CREATE TABLE article (
    -- Primary identifier
    artnouvcode VARCHAR(255) PRIMARY KEY,
    
    -- Location information
    artadresse VARCHAR(255),
    
    -- People information
    artagent VARCHAR(255),                    -- Agent (CIN)
    artoccup VARCHAR(255),                    -- Occupant
    artqualoccup VARCHAR(255),                -- Qualité Occupation
    artproprietaire VARCHAR(255),             -- Nom du propriétaire
    artredcode VARCHAR(8),                    -- CIN du propriétaire (8 digits)
    artteldecl INTEGER,                       -- Téléphone domicile
    
    -- Business information
    artnomcommerce VARCHAR(255),              -- Nom Commerce
    artcatart VARCHAR(10),                    -- Catégorie Article (Activité)
    
    -- Tax calculation fields
    artsurcouv DECIMAL(10,2),                 -- Surface Couverte
    artservitudesmunicipales INTEGER,         -- Servitudes municipales (1-5)
    artautresservitudes INTEGER,              -- Autres servitudes (0 ou 1)
    arttauxpres DECIMAL(5,2),                 -- Taux Prestation
    artmnttaxe DECIMAL(10,2),                 -- Montant de la Taxe (calculé)
    
    -- TCL calculation fields
    artchiffreaffaireslocal DECIMAL(15,2),   -- Chiffre d'affaires local (0,2%)
    artexportations DECIMAL(15,2),            -- Exportations (0,1%)
    arttaxeimmobiliere DECIMAL(15,2),         -- Taxe immobilière (minimum)
    
    -- Period fields
    artdebper VARCHAR(10),                    -- Début Période
    artfinper VARCHAR(10),                    -- Fin Période
    
    -- Geographic coordinates
    artlatitude DECIMAL(10, 8),               -- Latitude
    artlongitude DECIMAL(11, 8),              -- Longitude
    
    -- Status and metadata
    artetat INTEGER DEFAULT 0,                -- 1 paye taxe, 0 ne paye pas
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_article_artnouvcode ON article(artnouvcode);
CREATE INDEX idx_article_artnomcommerce ON article(artnomcommerce);
CREATE INDEX idx_article_artproprietaire ON article(artproprietaire);
CREATE INDEX idx_article_artredcode ON article(artredcode);
CREATE INDEX idx_article_artcatart ON article(artcatart);
CREATE INDEX idx_article_coordinates ON article(artlatitude, artlongitude);
CREATE INDEX idx_article_servitudes ON article(artservitudesmunicipales, artautresservitudes);

-- Enable Row Level Security
ALTER TABLE article ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Allow authenticated read" ON article
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated insert" ON article
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated update" ON article
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated delete" ON article
    FOR DELETE USING (auth.role() = 'authenticated');

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_article_updated_at
    BEFORE UPDATE ON article
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Force PostgREST schema reload
NOTIFY pgrst, 'reload schema';

