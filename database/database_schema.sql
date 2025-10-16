-- =====================================================
-- TCL MOBILE APP - COMPLETE DATABASE SCHEMA
-- =====================================================
-- Final database schema for TCL Mobile App
-- Includes: Users (agents), Citizens, and Articles (establishments)
-- =====================================================

-- =====================================================
-- 1. USERS TABLE (AGENTS)
-- =====================================================
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_code VARCHAR(8) UNIQUE NOT NULL CHECK (user_code ~ '^[0-9]{8}$'),
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    numero_telephone VARCHAR(8) CHECK (numero_telephone IS NULL OR numero_telephone ~ '^[0-9]{8}$'),
    agent_type VARCHAR(20) NOT NULL CHECK (agent_type IN ('collecteur', 'controle', 'superviseur', 'admin')),
    can_create_articles BOOLEAN DEFAULT TRUE,
    can_modify_articles BOOLEAN DEFAULT FALSE,
    can_delete_articles BOOLEAN DEFAULT FALSE,
    can_manage_users BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 2. CITIZENS TABLE
-- =====================================================
DROP TABLE IF EXISTS citizens CASCADE;

CREATE TABLE citizens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cin VARCHAR(8) UNIQUE NOT NULL CHECK (cin ~ '^[0-9]{8}$'),
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    numero_telephone VARCHAR(8) CHECK (numero_telephone IS NULL OR numero_telephone ~ '^[0-9]{8}$'),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE
);

-- =====================================================
-- 3. ARTICLES TABLE (ESTABLISHMENTS)
-- =====================================================
DROP TABLE IF EXISTS article CASCADE;

CREATE TABLE article (
    artnouvcode VARCHAR(255) PRIMARY KEY,
    artadresse VARCHAR(255),
    artagent VARCHAR(255),
    artoccup VARCHAR(255),
    artqualoccup VARCHAR(255),
    artproprietaire VARCHAR(255),
    artredcode VARCHAR(8),
    artteldecl INTEGER,
    artnomcommerce VARCHAR(255),
    artcatart VARCHAR(10),
    artsurcouv DECIMAL(10,2),
    artservitudesmunicipales INTEGER,
    artautresservitudes INTEGER,
    prixm2 DECIMAL(10,2),
    arttauxpres DECIMAL(5,2),
    artmnttaxe DECIMAL(10,2),
    artchiffreaffaireslocal DECIMAL(15,2),
    artexportations DECIMAL(15,2),
    arttaxeimmobiliere DECIMAL(15,2),
    artdebper VARCHAR(10),
    artfinper VARCHAR(10),
    artlatitude DECIMAL(10, 8),
    artlongitude DECIMAL(11, 8),
    artetat INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 4. INDEXES FOR PERFORMANCE
-- =====================================================
-- Users indexes
CREATE INDEX idx_users_user_code ON users(user_code);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_agent_type ON users(agent_type);

-- Citizens indexes
CREATE INDEX idx_citizens_cin ON citizens(cin);
CREATE INDEX idx_citizens_email ON citizens(email);
CREATE INDEX idx_citizens_nom_prenom ON citizens(nom, prenom);

-- Articles indexes
CREATE INDEX idx_article_artnouvcode ON article(artnouvcode);
CREATE INDEX idx_article_artnomcommerce ON article(artnomcommerce);
CREATE INDEX idx_article_artproprietaire ON article(artproprietaire);
CREATE INDEX idx_article_artredcode ON article(artredcode);
CREATE INDEX idx_article_artcatart ON article(artcatart);
CREATE INDEX idx_article_coordinates ON article(artlatitude, artlongitude);
CREATE INDEX idx_article_prixm2 ON article(prixm2);
CREATE INDEX idx_article_servitudes ON article(artservitudesmunicipales, artautresservitudes);

-- =====================================================
-- 5. TRIGGERS FOR UPDATED_AT
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_citizens_updated_at
    BEFORE UPDATE ON citizens
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_article_updated_at
    BEFORE UPDATE ON article
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 6. ROW LEVEL SECURITY (RLS)
-- =====================================================
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE citizens ENABLE ROW LEVEL SECURITY;
ALTER TABLE article ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Allow authenticated read" ON users
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated insert" ON users
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated update" ON users
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated delete" ON users
    FOR DELETE USING (auth.role() = 'authenticated');

-- Citizens policies (allow public registration)
CREATE POLICY "Allow public registration" ON citizens
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public read" ON citizens
    FOR SELECT USING (true);

CREATE POLICY "Allow public update" ON citizens
    FOR UPDATE USING (true);

-- Articles policies
CREATE POLICY "Allow authenticated read" ON article
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated insert" ON article
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated update" ON article
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated delete" ON article
    FOR DELETE USING (auth.role() = 'authenticated');

-- =====================================================
-- 7. SAMPLE DATA
-- =====================================================
-- Create admin user
INSERT INTO users (
    user_code,
    nom,
    prenom,
    email,
    password_hash,
    numero_telephone,
    agent_type,
    can_create_articles,
    can_modify_articles,
    can_delete_articles,
    can_manage_users,
    is_active
) VALUES (
    '00000001',
    'Admin',
    'TCL',
    'admin@tcl.tn',
    'admin123', -- Simple hash
    '12345678',
    'admin',
    true,
    true,
    true,
    true,
    true
);

-- Create test citizen
INSERT INTO citizens (
    cin,
    nom,
    prenom,
    email,
    password_hash,
    numero_telephone,
    is_active,
    is_verified
) VALUES (
    '12345678',
    'Test',
    'Citizen',
    'test.citizen@gmail.com',
    '123456', -- Simple hash for password "123456"
    '12345678',
    true,
    false
);

-- Create test establishment
INSERT INTO article (
    artnouvcode,
    artnomcommerce,
    artadresse,
    artproprietaire,
    artredcode,
    artteldecl,
    artcatart,
    artsurcouv,
    artmnttaxe,
    arttaxeimmobiliere,
    artdebper,
    artfinper,
    artetat,
    artlatitude,
    artlongitude
) VALUES (
    'TEST_001',
    'Magasin Test',
    '123 Rue de Test, Tunis',
    'Test Citizen',
    '12345678',
    '12345678',
    '256',
    50.0,
    150.0,
    100.0,
    '2025',
    '2026',
    1,
    36.8065,
    10.1815
);

-- =====================================================
-- 8. VERIFICATION
-- =====================================================
-- Verify tables were created
SELECT table_name 
FROM information_schema.tables 
WHERE table_name IN ('users', 'citizens', 'article')
ORDER BY table_name;

-- Verify sample data
SELECT 'Users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Citizens' as table_name, COUNT(*) as count FROM citizens
UNION ALL
SELECT 'Articles' as table_name, COUNT(*) as count FROM article;

-- =====================================================
-- SCHEMA COMPLETE
-- =====================================================

