# ARTICLE Table Migration Summary

## Changes Made

### 1. Database Structure (SQL)
Created `supabase_migrations/001_create_article_table.sql` with:
- Complete ARTICLE table structure matching the SQL Server schema
- PostgreSQL-compatible data types
- Row Level Security (RLS) policies for authenticated users
- Automatic timestamp updates via trigger

### 2. Dart Model Updates
Updated `lib/models/etablissement_model.dart` to:
- Match the ARTICLE table structure with 40+ fields
- Proper data type conversions (DateTime for timestamps, double for numeric fields)
- Updated `fromJson()` and `toJson()` methods for Supabase compatibility

### 3. Database Service Updates
Updated `lib/services/database_service.dart` to:
- Use 'article' table instead of 'etablissements'
- Changed primary key from 'id' to 'art_nouv_code'
- Updated all CRUD operations to work with new field names

### 4. Provider Updates
Updated `lib/providers/establishment_provider.dart` to:
- Use 'artNouvCode' instead of 'id' for all operations
- Maintain the same provider interface but with new field names

### 5. UI Form Updates
Updated `lib/screens/establishment/establishment_form.dart` to:
- Map existing form fields to new ARTICLE table fields
- Maintain backward compatibility with existing user inputs
- Convert boolean status to integer (1 for true, 0 for false)

## SQL Code for ARTICLE Table

```sql
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
```

## Next Steps

1. **Run the SQL migration** in your Supabase dashboard to create the ARTICLE table
2. **Test the application** to ensure all CRUD operations work correctly
3. **Update any other screens** that display establishment data to use the new field names
4. **Consider data migration** if you have existing data in the old 'etablissements' table

## Field Mappings from Old to New

| Old Field | New Field | Notes |
|-----------|-----------|-------|
| id | artNouvCode | Now uses matricule as primary key |
| matricule | artNouvCode | Becomes the primary key |
| address | artTexteAdresse | |
| superficie | artSurTot | |
| categorie | artCatArt | |
| status | artEtat | Converted to integer (1/0) |
| ownerName | artNomCommerce | |
| ownerCin | artRedCode + artTelDecl | |
| tenantName | artMond | |
| tenantActivity | artOccup | |
| latitude | artLatitude | |
| longitude | artLongitude | |
| createdBy | artAgent | |
| createdAt | createdAt | |
| updatedAt | updatedAt | |
