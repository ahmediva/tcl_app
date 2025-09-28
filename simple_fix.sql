-- Simple fix for common NULL issues in CSV import
-- Run this after importing your CSV file

-- Fix the most common timestamp columns
UPDATE article SET "ArtDateSaisie" = NULL WHERE "ArtDateSaisie"::text = 'NULL';
UPDATE article SET "ArtDateDebImp" = NULL WHERE "ArtDateDebImp"::text = 'NULL';
UPDATE article SET "ArtDateFinImp" = NULL WHERE "ArtDateFinImp"::text = 'NULL';
UPDATE article SET "ArtDateMaj" = NULL WHERE "ArtDateMaj"::text = 'NULL';
UPDATE article SET "ArtDateSour" = NULL WHERE "ArtDateSour"::text = 'NULL';
UPDATE article SET "ArtDateBlocage" = NULL WHERE "ArtDateBlocage"::text = 'NULL';
UPDATE article SET "ArtDatePoss" = NULL WHERE "ArtDatePoss"::text = 'NULL';
UPDATE article SET "ArtDateImp" = NULL WHERE "ArtDateImp"::text = 'NULL';
UPDATE article SET "ArtDateEtat" = NULL WHERE "ArtDateEtat"::text = 'NULL';
UPDATE article SET "ArtDateCont" = NULL WHERE "ArtDateCont"::text = 'NULL';
UPDATE article SET "ArtDateRecens" = NULL WHERE "ArtDateRecens"::text = 'NULL';

-- Fix numeric columns
UPDATE article SET "ArtLatitude" = NULL WHERE "ArtLatitude"::text = 'NULL';
UPDATE article SET "ArtLongitude" = NULL WHERE "ArtLongitude"::text = 'NULL';
UPDATE article SET "ArtDebPer" = NULL WHERE "ArtDebPer"::text = 'NULL';
UPDATE article SET "ArtFinPer" = NULL WHERE "ArtFinPer"::text = 'NULL';
UPDATE article SET "ArtImp" = NULL WHERE "ArtImp"::text = 'NULL';
UPDATE article SET "ArtTauxPres" = NULL WHERE "ArtTauxPres"::text = 'NULL';
UPDATE article SET "ArtMntTaxe" = NULL WHERE "ArtMntTaxe"::text = 'NULL';
UPDATE article SET "ArtSurTot" = NULL WHERE "ArtSurTot"::text = 'NULL';
UPDATE article SET "ArtSurCouv" = NULL WHERE "ArtSurCouv"::text = 'NULL';
UPDATE article SET "ArtPrixRef" = NULL WHERE "ArtPrixRef"::text = 'NULL';
UPDATE article SET "ArtSurCont" = NULL WHERE "ArtSurCont"::text = 'NULL';
UPDATE article SET "ArtSurDecl" = NULL WHERE "ArtSurDecl"::text = 'NULL';
UPDATE article SET "ArtPrixMetre" = NULL WHERE "ArtPrixMetre"::text = 'NULL';
UPDATE article SET "ArtBaseTaxe" = NULL WHERE "ArtBaseTaxe"::text = 'NULL';
UPDATE article SET "ArtEtat" = NULL WHERE "ArtEtat"::text = 'NULL';
UPDATE article SET "CodeGouv" = NULL WHERE "CodeGouv"::text = 'NULL';
UPDATE article SET "CodeDeleg" = NULL WHERE "CodeDeleg"::text = 'NULL';
UPDATE article SET "CodeImeda" = NULL WHERE "CodeImeda"::text = 'NULL';
UPDATE article SET "RedTypePrpor" = NULL WHERE "RedTypePrpor"::text = 'NULL';
UPDATE article SET "ArtCatActivite" = NULL WHERE "ArtCatActivite"::text = 'NULL';
UPDATE article SET "ArtOccupVoie" = NULL WHERE "ArtOccupVoie"::text = 'NULL';

-- Check results
SELECT 'Fixed NULL values successfully!' as status;
SELECT COUNT(*) as total_records FROM article;
