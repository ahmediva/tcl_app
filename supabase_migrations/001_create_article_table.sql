-- Create ARTICLE table
CREATE TABLE article (
    art_nouv_code VARCHAR(12) PRIMARY KEY,
    art_deb_per INTEGER,
    art_fin_per INTEGER,
    art_imp SMALLINT,
    art_taux_pres DOUBLE PRECISION,
    art_date_deb_imp TIMESTAMP,
    art_date_fin_imp TIMESTAMP,
    art_mnt_taxe DOUBLE PRECISION,
    art_agent VARCHAR(30),
    art_date_saisie TIMESTAMP,
    art_red_code VARCHAR(12),
    art_mond VARCHAR(12),
    art_occup VARCHAR(12),
    art_arrond CHAR(2) NOT NULL,
    art_rue CHAR(5) NOT NULL,
    art_texte_adresse VARCHAR(255),
    art_sur_tot DOUBLE PRECISION,
    art_sur_couv DOUBLE PRECISION,
    art_prix_ref DOUBLE PRECISION,
    art_cat_art VARCHAR(10),
    art_qual_occup VARCHAR(100),
    art_sur_cont DOUBLE PRECISION,
    art_sur_decl DOUBLE PRECISION,
    art_prix_metre MONEY,
    art_base_taxe SMALLINT,
    art_etat SMALLINT,
    art_taxe_office CHAR(1),
    art_num_role VARCHAR(6),
    code_gouv INTEGER,
    code_deleg INTEGER,
    code_imeda INTEGER,
    code_com VARCHAR(5),
    red_type_prpor SMALLINT,
    art_tel_decl VARCHAR(8),
    art_email_decl VARCHAR(255),
    art_commentaire VARCHAR(255),
    art_cat_activite SMALLINT,
    art_nom_commerce VARCHAR(255),
    art_occup_voie SMALLINT,
    art_latitude DOUBLE PRECISION,
    art_longitude DOUBLE PRECISION,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE article ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users to read all articles
CREATE POLICY "Authenticated users can read articles" 
ON article FOR SELECT 
TO authenticated 
USING (true);

-- Create policy for authenticated users to insert articles
CREATE POLICY "Authenticated users can insert articles" 
ON article FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Create policy for authenticated users to update articles
CREATE POLICY "Authenticated users can update articles" 
ON article FOR UPDATE 
TO authenticated 
USING (true);

-- Create policy for authenticated users to delete articles
CREATE POLICY "Authenticated users can delete articles" 
ON article FOR DELETE 
TO authenticated 
USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_article_updated_at 
BEFORE UPDATE ON article 
FOR EACH ROW 
EXECUTE FUNCTION update_updated_at_column();
