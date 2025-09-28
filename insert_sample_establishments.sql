-- SQL INSERT statements for sample establishments from JSON data
-- This will populate the article table with real establishment data

-- Insert sample establishments from the JSON data
INSERT INTO article (
    "ArtNouvCode",
    "ArtDebPer",
    "ArtFinPer", 
    "ArtImp",
    "ArtTauxPres",
    "ArtDateDebImp",
    "ArtMntTaxe",
    "ArtArrond",
    "ArtRue",
    "ArtTexteAdresse",
    "ArtSurTot",
    "ArtSurCouv",
    "ArtPrixRef",
    "ArtCatArt",
    "ArtQualOccup",
    "ArtSurCont",
    "ArtSurDecl",
    "ArtPrixMetre",
    "ArtBaseTaxe",
    "ArtEtat",
    "ArtTaxeOffice",
    "ArtNumRole",
    "ArtPresNet",
    "ArtPresEcl",
    "ArtPresCh",
    "ArtPresTr",
    "ArtPresEauU",
    "ArtPresEauP",
    "ArtPresAut",
    "ArtSurTotCont",
    "ArtSurCouvCont",
    "ArtConstArt",
    "ArtCompArt",
    "ArtUtilArt",
    "ArtTitreFonc",
    "ArtValVen",
    "ArtDens",
    "ArtDateEtat",
    "ArtCodeAvTrans",
    "ArtCodeApTrans",
    "ArtDerAnneeRole",
    "ArtDerAnnee_1Role",
    "ArtDeclCode",
    "created_at",
    "updated_at"
) VALUES 
-- Sample establishment 1
('063130060001', 2016, 2016, 1, 0.14, '2017-01-01 00:00:00.000', 1601.4, '6', '03130', 'عدد 60 نهــج 3130شــارع علــي البلهــوان_ 06وسط المدينة_ 8090', 1020, 1020, 190, '1', '1', 1020, 1020, NULL, 3, 1, '0', '325010', 1, 1, 1, 1, 1, 1, 1, 1020, 1020, '0', NULL, '81', NULL, 0.00, NULL, '2016-11-02 19:31:30.290', '063130060001', '063130060001', NULL, NULL, '9404', NOW(), NOW()),

-- Sample establishment 2  
('104280101001', 2016, 2016, 1, 0.12, '2017-01-01 00:00:00.000', 3845.355, '10', '06050', 'عدد 1 نهــج 6050نهــج حمــادي الصيــد_ 10حي الشاطئ_ 8090', 2859, 2859, 190, '1', '0', 2859, 2859, 0.00, 1, 1, '0', '325010', 1, 1, 1, 1, 1, 0, NULL, 2859, 2859, '0', NULL, '1000', NULL, 0.00, NULL, '2016-11-02 19:31:30.290', '104280101001', '104280101001', NULL, NULL, '16463', NOW(), NOW()),

-- Sample establishment 3
('107100002001', 2017, 2026, 1, 0.12, '2017-01-01 00:00:00.000', 32543.62, '7', '07100', 'عدد 2 نهــج 7100شــارع الرياض_ 07حي الرياض_ 8090', 4500, 4500, 190, '1', '1', 4500, 4500, 0.00, 1, 1, '0', '325010', 1, 1, 1, 1, 1, 1, NULL, 4500, 4500, '0', NULL, '2000', NULL, 0.00, NULL, '2017-03-16 00:00:00.000', '107100002001', '107100002001', NULL, NULL, '17514', NOW(), NOW());

-- Verify the insertions
SELECT COUNT(*) as total_establishments FROM article WHERE "ArtNouvCode" IN ('063130060001', '104280101001', '107100002001');

-- Show sample data
SELECT "ArtNouvCode", "ArtTexteAdresse", "ArtArrond", "ArtRue", "ArtEtat", "ArtMntTaxe" 
FROM article 
WHERE "ArtNouvCode" IN ('063130060001', '104280101001', '107100002001')
ORDER BY "ArtNouvCode";

