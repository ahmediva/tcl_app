-- Fix NULL timestamp values in article table
-- This script converts string 'NULL' values to actual NULL for timestamp columns
-- Updated to match actual table schema

-- Update timestamp columns that have 'NULL' string values
UPDATE article 
SET 
  "ArtDateDebImp" = NULL 
WHERE "ArtDateDebImp"::text = 'NULL' OR "ArtDateDebImp"::text = '';

UPDATE article 
SET 
  "ArtDateFinImp" = NULL 
WHERE "ArtDateFinImp"::text = 'NULL' OR "ArtDateFinImp"::text = '';

UPDATE article 
SET 
  "ArtDateSaisie" = NULL 
WHERE "ArtDateSaisie"::text = 'NULL' OR "ArtDateSaisie"::text = '';

UPDATE article 
SET 
  "ArtDateMaj" = NULL 
WHERE "ArtDateMaj"::text = 'NULL' OR "ArtDateMaj"::text = '';

UPDATE article 
SET 
  "ArtDateSour" = NULL 
WHERE "ArtDateSour"::text = 'NULL' OR "ArtDateSour"::text = '';

UPDATE article 
SET 
  "ArtDateBlocage" = NULL 
WHERE "ArtDateBlocage"::text = 'NULL' OR "ArtDateBlocage"::text = '';

UPDATE article 
SET 
  "ArtDatePoss" = NULL 
WHERE "ArtDatePoss"::text = 'NULL' OR "ArtDatePoss"::text = '';

UPDATE article 
SET 
  "ArtDateImp" = NULL 
WHERE "ArtDateImp"::text = 'NULL' OR "ArtDateImp"::text = '';

UPDATE article 
SET 
  "ArtDateEtat" = NULL 
WHERE "ArtDateEtat"::text = 'NULL' OR "ArtDateEtat"::text = '';

UPDATE article 
SET 
  "ArtDateCont" = NULL 
WHERE "ArtDateCont"::text = 'NULL' OR "ArtDateCont"::text = '';

UPDATE article 
SET 
  "ArtDateRecens" = NULL 
WHERE "ArtDateRecens"::text = 'NULL' OR "ArtDateRecens"::text = '';

-- Fix numeric columns that might have 'NULL' strings
UPDATE article 
SET 
  "ArtDebPer" = NULL 
WHERE "ArtDebPer"::text = 'NULL' OR "ArtDebPer"::text = '';

UPDATE article 
SET 
  "ArtFinPer" = NULL 
WHERE "ArtFinPer"::text = 'NULL' OR "ArtFinPer"::text = '';

UPDATE article 
SET 
  "ArtImp" = NULL 
WHERE "ArtImp"::text = 'NULL' OR "ArtImp"::text = '';

UPDATE article 
SET 
  "ArtTauxPres" = NULL 
WHERE "ArtTauxPres"::text = 'NULL' OR "ArtTauxPres"::text = '';

UPDATE article 
SET 
  "ArtMntTaxe" = NULL 
WHERE "ArtMntTaxe"::text = 'NULL' OR "ArtMntTaxe"::text = '';

UPDATE article 
SET 
  "ArtSurTot" = NULL 
WHERE "ArtSurTot"::text = 'NULL' OR "ArtSurTot"::text = '';

UPDATE article 
SET 
  "ArtSurCouv" = NULL 
WHERE "ArtSurCouv"::text = 'NULL' OR "ArtSurCouv"::text = '';

UPDATE article 
SET 
  "ArtPrixRef" = NULL 
WHERE "ArtPrixRef"::text = 'NULL' OR "ArtPrixRef"::text = '';

UPDATE article 
SET 
  "ArtSurCont" = NULL 
WHERE "ArtSurCont"::text = 'NULL' OR "ArtSurCont"::text = '';

UPDATE article 
SET 
  "ArtSurDecl" = NULL 
WHERE "ArtSurDecl"::text = 'NULL' OR "ArtSurDecl"::text = '';

UPDATE article 
SET 
  "ArtPrixMetre" = NULL 
WHERE "ArtPrixMetre"::text = 'NULL' OR "ArtPrixMetre"::text = '';

UPDATE article 
SET 
  "ArtBaseTaxe" = NULL 
WHERE "ArtBaseTaxe"::text = 'NULL' OR "ArtBaseTaxe"::text = '';

UPDATE article 
SET 
  "ArtEtat" = NULL 
WHERE "ArtEtat"::text = 'NULL' OR "ArtEtat"::text = '';

UPDATE article 
SET 
  "CodeGouv" = NULL 
WHERE "CodeGouv"::text = 'NULL' OR "CodeGouv"::text = '';

UPDATE article 
SET 
  "CodeDeleg" = NULL 
WHERE "CodeDeleg"::text = 'NULL' OR "CodeDeleg"::text = '';

UPDATE article 
SET 
  "CodeImeda" = NULL 
WHERE "CodeImeda"::text = 'NULL' OR "CodeImeda"::text = '';

UPDATE article 
SET 
  "RedTypePrpor" = NULL 
WHERE "RedTypePrpor"::text = 'NULL' OR "RedTypePrpor"::text = '';

UPDATE article 
SET 
  "ArtCatActivite" = NULL 
WHERE "ArtCatActivite"::text = 'NULL' OR "ArtCatActivite"::text = '';

UPDATE article 
SET 
  "ArtOccupVoie" = NULL 
WHERE "ArtOccupVoie"::text = 'NULL' OR "ArtOccupVoie"::text = '';

UPDATE article 
SET 
  "ArtLatitude" = NULL 
WHERE "ArtLatitude"::text = 'NULL' OR "ArtLatitude"::text = '';

UPDATE article 
SET 
  "ArtLongitude" = NULL 
WHERE "ArtLongitude"::text = 'NULL' OR "ArtLongitude"::text = '';

UPDATE article 
SET 
  "ArtMntTaxeTib" = NULL 
WHERE "ArtMntTaxeTib"::text = 'NULL' OR "ArtMntTaxeTib"::text = '';

UPDATE article 
SET 
  "ArtMntTaxeFnah" = NULL 
WHERE "ArtMntTaxeFnah"::text = 'NULL' OR "ArtMntTaxeFnah"::text = '';

UPDATE article 
SET 
  "ArtImpFNAH" = NULL 
WHERE "ArtImpFNAH"::text = 'NULL' OR "ArtImpFNAH"::text = '';

UPDATE article 
SET 
  "ArtSurTotCont" = NULL 
WHERE "ArtSurTotCont"::text = 'NULL' OR "ArtSurTotCont"::text = '';

UPDATE article 
SET 
  "ArtSurCouvCont" = NULL 
WHERE "ArtSurCouvCont"::text = 'NULL' OR "ArtSurCouvCont"::text = '';

UPDATE article 
SET 
  "ArtLoyeeAnn" = NULL 
WHERE "ArtLoyeeAnn"::text = 'NULL' OR "ArtLoyeeAnn"::text = '';

UPDATE article 
SET 
  "ArtConstArt" = NULL 
WHERE "ArtConstArt"::text = 'NULL' OR "ArtConstArt"::text = '';

UPDATE article 
SET 
  "ArtCompArt" = NULL 
WHERE "ArtCompArt"::text = 'NULL' OR "ArtCompArt"::text = '';

UPDATE article 
SET 
  "ArtUtilArt" = NULL 
WHERE "ArtUtilArt"::text = 'NULL' OR "ArtUtilArt"::text = '';

UPDATE article 
SET 
  "ArtValVen" = NULL 
WHERE "ArtValVen"::text = 'NULL' OR "ArtValVen"::text = '';

UPDATE article 
SET 
  "ArtDens" = NULL 
WHERE "ArtDens"::text = 'NULL' OR "ArtDens"::text = '';

UPDATE article 
SET 
  "ArtFrontNord" = NULL 
WHERE "ArtFrontNord"::text = 'NULL' OR "ArtFrontNord"::text = '';

UPDATE article 
SET 
  "ArtFrontSud" = NULL 
WHERE "ArtFrontSud"::text = 'NULL' OR "ArtFrontSud"::text = '';

UPDATE article 
SET 
  "ArtFrontEst" = NULL 
WHERE "ArtFrontEst"::text = 'NULL' OR "ArtFrontEst"::text = '';

UPDATE article 
SET 
  "ArtFrontOuest" = NULL 
WHERE "ArtFrontOuest"::text = 'NULL' OR "ArtFrontOuest"::text = '';

UPDATE article 
SET 
  "ArtDerAnneeRole" = NULL 
WHERE "ArtDerAnneeRole"::text = 'NULL' OR "ArtDerAnneeRole"::text = '';

UPDATE article 
SET 
  "ArtDerAnnee_1Role" = NULL 
WHERE "ArtDerAnnee_1Role"::text = 'NULL' OR "ArtDerAnnee_1Role"::text = '';

-- Show results
SELECT COUNT(*) as total_records FROM article;
SELECT COUNT(*) as records_with_null_timestamps FROM article WHERE "ArtDateSaisie" IS NULL;
SELECT COUNT(*) as records_with_null_latitude FROM article WHERE "ArtLatitude" IS NULL;
SELECT COUNT(*) as records_with_null_longitude FROM article WHERE "ArtLongitude" IS NULL;
