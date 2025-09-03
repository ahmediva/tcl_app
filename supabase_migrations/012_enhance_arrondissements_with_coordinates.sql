-- Enhance arrondissements table with Google Maps coordinates
-- This migration adds geographic coordinates and boundary information for arrondissements

-- Add new coordinate columns to arrondissement table
ALTER TABLE arrondissement 
ADD COLUMN IF NOT EXISTS center_latitude DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS center_longitude DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS zoom_level DOUBLE PRECISION DEFAULT 12.0,
ADD COLUMN IF NOT EXISTS boundary_coordinates JSONB;

-- Create index on coordinates for better performance
CREATE INDEX IF NOT EXISTS idx_arrondissement_coordinates 
ON arrondissement(center_latitude, center_longitude);

-- Create index on boundary coordinates for spatial queries
CREATE INDEX IF NOT EXISTS idx_arrondissement_boundaries 
ON arrondissement USING GIN(boundary_coordinates);

-- Add sample coordinate data for existing arrondissements (Tunisia coordinates)
-- You should update these with actual coordinates for your arrondissements
UPDATE arrondissement 
SET 
    center_latitude = CASE 
        WHEN code = '01' THEN 36.8065  -- Tunis
        WHEN code = '02' THEN 36.8065  -- Tunis
        WHEN code = '03' THEN 36.8065  -- Tunis
        WHEN code = '04' THEN 36.8065  -- Tunis
        WHEN code = '05' THEN 36.8065  -- Tunis
        WHEN code = '06' THEN 36.8065  -- Tunis
        WHEN code = '07' THEN 36.8065  -- Tunis
        WHEN code = '08' THEN 36.8065  -- Tunis
        WHEN code = '09' THEN 36.8065  -- Tunis
        WHEN code = '10' THEN 36.8065  -- Tunis
        ELSE 36.8065  -- Default to Tunis center
    END,
    center_longitude = CASE 
        WHEN code = '01' THEN 10.1815  -- Tunis
        WHEN code = '02' THEN 10.1815  -- Tunis
        WHEN code = '03' THEN 10.1815  -- Tunis
        WHEN code = '04' THEN 10.1815  -- Tunis
        WHEN code = '05' THEN 10.1815  -- Tunis
        WHEN code = '06' THEN 10.1815  -- Tunis
        WHEN code = '07' THEN 10.1815  -- Tunis
        WHEN code = '08' THEN 10.1815  -- Tunis
        WHEN code = '09' THEN 10.1815  -- Tunis
        WHEN code = '10' THEN 10.1815  -- Tunis
        ELSE 10.1815  -- Default to Tunis center
    END,
    zoom_level = CASE 
        WHEN code IN ('01', '02', '03', '04', '05') THEN 13.0  -- City center arrondissements
        WHEN code IN ('06', '07', '08', '09', '10') THEN 12.0  -- Suburban arrondissements
        ELSE 12.0  -- Default zoom level
    END;

-- Create a function to get arrondissements within a certain distance from a point
CREATE OR REPLACE FUNCTION get_arrondissements_near_point(
    lat DOUBLE PRECISION,
    lon DOUBLE PRECISION,
    radius_km DOUBLE PRECISION DEFAULT 10.0
)
RETURNS TABLE(
    code VARCHAR(2),
    libelle VARCHAR(255),
    distance_km DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.code,
        a.libelle,
        (
            6371 * acos(
                cos(radians(lat)) * 
                cos(radians(a.center_latitude)) * 
                cos(radians(a.center_longitude) - radians(lon)) + 
                sin(radians(lat)) * 
                sin(radians(a.center_latitude))
            )
        ) AS distance_km
    FROM arrondissement a
    WHERE a.center_latitude IS NOT NULL 
        AND a.center_longitude IS NOT NULL
        AND a.code_etat = 'A'  -- Only active arrondissements
    HAVING (
        6371 * acos(
            cos(radians(lat)) * 
            cos(radians(a.center_latitude)) * 
            cos(radians(a.center_longitude) - radians(lon)) + 
            sin(radians(lat)) * 
            sin(radians(a.center_latitude))
        )
    ) <= radius_km
    ORDER BY distance_km;
END;
$$ LANGUAGE plpgsql;

-- Create a function to get arrondissement boundaries as GeoJSON
CREATE OR REPLACE FUNCTION get_arrondissement_boundaries_as_geojson()
RETURNS TABLE(
    code VARCHAR(2),
    libelle VARCHAR(255),
    geojson JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.code,
        a.libelle,
        jsonb_build_object(
            'type', 'Feature',
            'geometry', jsonb_build_object(
                'type', 'Polygon',
                'coordinates', jsonb_build_array(
                    CASE 
                        WHEN a.boundary_coordinates IS NOT NULL THEN
                            (SELECT jsonb_agg(
                                jsonb_build_array(
                                    (value->>'longitude')::double precision,
                                    (value->>'latitude')::double precision
                                )
                            ) FROM jsonb_array_elements(a.boundary_coordinates))
                        ELSE NULL
                    END
                )
            ),
            'properties', jsonb_build_object(
                'code', a.code,
                'libelle', a.libelle,
                'code_etat', a.code_etat
            )
        ) AS geojson
    FROM arrondissement a
    WHERE a.boundary_coordinates IS NOT NULL
        AND a.code_etat = 'A';
END;
$$ LANGUAGE plpgsql;

-- Grant execute permissions on the new functions
GRANT EXECUTE ON FUNCTION get_arrondissements_near_point(DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION) TO authenticated;
GRANT EXECUTE ON FUNCTION get_arrondissement_boundaries_as_geojson() TO authenticated;

-- Create a view for arrondissements with coordinates
CREATE OR REPLACE VIEW arrondissements_with_coordinates AS
SELECT 
    code,
    libelle,
    date_etat,
    code_etat,
    center_latitude,
    center_longitude,
    zoom_level,
    boundary_coordinates,
    created_at,
    updated_at
FROM arrondissement
WHERE center_latitude IS NOT NULL 
    AND center_longitude IS NOT NULL
    AND code_etat = 'A';

-- Grant access to the view
GRANT SELECT ON arrondissements_with_coordinates TO authenticated;

-- Add comments to document the new columns
COMMENT ON COLUMN arrondissement.center_latitude IS 'Latitude du centre de l\'arrondissement pour Google Maps';
COMMENT ON COLUMN arrondissement.center_longitude IS 'Longitude du centre de l\'arrondissement pour Google Maps';
COMMENT ON COLUMN arrondissement.zoom_level IS 'Niveau de zoom recommandé pour afficher l\'arrondissement sur la carte';
COMMENT ON COLUMN arrondissement.boundary_coordinates IS 'Coordonnées des limites de l\'arrondissement au format JSONB';

-- Update RLS policies to allow access to coordinate data
-- Users can view arrondissement coordinates for mapping purposes
CREATE POLICY IF NOT EXISTS "Users can view arrondissement coordinates" 
ON arrondissement FOR SELECT 
TO authenticated 
USING (true);
