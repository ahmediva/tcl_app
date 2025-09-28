-- Create ARTICLE table with complete schema
CREATE TABLE article (
    ArtNouvCode VARCHAR(12) PRIMARY KEY,
    ArtDebPer INTEGER,
    ArtFinPer INTEGER,
    ArtImp SMALLINT,
    ArtTauxPres DOUBLE PRECISION,
    ArtDateDebImp TIMESTAMP,
    ArtDateFinImp TIMESTAMP,
    ArtMntTaxe DOUBLE PRECISION,
    ArtAgentSaisie VARCHAR(30),
    ArtDateSaisie TIMESTAMP,
    ArtRedCode VARCHAR(12),
    ArtMond VARCHAR(12),
    ArtOccup VARCHAR(12),
    ArtArrond CHAR(2) NOT NULL,
    ArtRue CHAR(5) NOT NULL,
    ArtTexteAdresse VARCHAR(255),
    ArtSurTot DOUBLE PRECISION,
    ArtSurCouv DOUBLE PRECISION,
    ArtPrixRef DOUBLE PRECISION,
    ArtCatArt VARCHAR(10),
    ArtQualOccup VARCHAR(100),
    ArtSurCont DOUBLE PRECISION,
    ArtSurDecl DOUBLE PRECISION,
    ArtPrixMetre MONEY,
    ArtBaseTaxe SMALLINT,
    ArtEtat SMALLINT,
    ArtTaxeOffice CHAR(1),
    ArtNumRole VARCHAR(6),
    CodeGouv INTEGER,
    CodeDeleg INTEGER,
    CodeImeda INTEGER,
    CodeCom VARCHAR(5),
    RedTypePrpor SMALLINT,
    ArtTelDecl VARCHAR(8),
    ArtEmailDecl VARCHAR(255),
    ArtCommentaire VARCHAR(255),
    ArtCatActivite SMALLINT,
    ArtNomCommerce VARCHAR(255),
    ArtOccupVoie SMALLINT,
    ArtLatitude DOUBLE PRECISION,
    ArtLongitude DOUBLE PRECISION,
    ArtNumDos VARCHAR(50),
    ArtSourMaj VARCHAR(50),
    ArtNumMaj VARCHAR(50),
    ArtDateMaj TIMESTAMP,
    ArtSour VARCHAR(50),
    ArtNumSour VARCHAR(50),
    ArtDateSour TIMESTAMP,
    ArtDateBlocage TIMESTAMP,
    ArtTypeTaxe VARCHAR(10),
    ArtImpFNAH SMALLINT,
    ArtMntTaxeTib DOUBLE PRECISION,
    ArtMntTaxeFnah DOUBLE PRECISION,
    ArtAgentCont VARCHAR(30),
    ArtDateCont TIMESTAMP,
    ArtNumAvis VARCHAR(20),
    ArtVred VARCHAR(50),
    ArtTypeRue VARCHAR(20),
    ArtNumRue VARCHAR(10),
    ArtBis VARCHAR(5),
    ArtBloc VARCHAR(10),
    ArtOrdreBloc INTEGER,
    ArtCodePos VARCHAR(10),
    ArtSectBur VARCHAR(10),
    ArtPresNet SMALLINT,
    ArtPresEcl SMALLINT,
    ArtPresCh SMALLINT,
    ArtPresTr SMALLINT,
    ArtPresEauU SMALLINT,
    ArtPresEauP SMALLINT,
    ArtPresAut SMALLINT,
    ArtSurTotCont DOUBLE PRECISION,
    ArtSurCouvCont DOUBLE PRECISION,
    ArtLoyeeAnn DOUBLE PRECISION,
    ArtConstArt VARCHAR(50),
    ArtCompArt VARCHAR(50),
    ArtUtilArt VARCHAR(50),
    ArtTitreFonc VARCHAR(100),
    ArtValVen DOUBLE PRECISION,
    ArtDens DOUBLE PRECISION,
    ArtDatePoss TIMESTAMP,
    ArtDateImp TIMESTAMP,
    ArtSitu VARCHAR(50),
    ArtFrontNord DOUBLE PRECISION,
    ArtFrontSud DOUBLE PRECISION,
    ArtFrontEst DOUBLE PRECISION,
    ArtFrontOuest DOUBLE PRECISION,
    ArtDateEtat TIMESTAMP,
    ArtCodeAvTrans VARCHAR(10),
    ArtCodeApTrans VARCHAR(10),
    ArtDerAnneeRole INTEGER,
    ArtDerAnnee_1Role INTEGER,
    ArtCite VARCHAR(50),
    Artsecteur VARCHAR(10),
    ArtCellule VARCHAR(10),
    ArtNomResid VARCHAR(100),
    ArtNomImmeuble VARCHAR(100),
    ArtEtage VARCHAR(10),
    ArtAppart VARCHAR(10),
    ArtTypeHabit VARCHAR(50),
    ArtActivSecond VARCHAR(100),
    ArtEnseigne VARCHAR(100),
    ArtNomAgent VARCHAR(50),
    ArtDateRecens TIMESTAMP,
    TypeCollect VARCHAR(20),
    ArtIdMiseAJour VARCHAR(50),
    ArtDeclCode VARCHAR(12),
    ArtAgentDecl VARCHAR(30),
    ArtQualDecl VARCHAR(50),
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
