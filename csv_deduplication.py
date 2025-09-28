-- CSV Preprocessing to Remove Duplicates
-- Use this Python script to clean your CSV before importing

import pandas as pd

# Read the CSV file
df = pd.read_csv('your_file.csv')

print(f"Original CSV has {len(df)} rows")

# Check for duplicates based on ArtNouvCode (primary key)
duplicates = df.duplicated(subset=['ArtNouvCode'], keep='first')
print(f"Found {duplicates.sum()} duplicate rows")

# Remove duplicates, keeping the first occurrence
df_cleaned = df.drop_duplicates(subset=['ArtNouvCode'], keep='first')

print(f"Cleaned CSV has {len(df_cleaned)} rows")
print(f"Removed {len(df) - len(df_cleaned)} duplicate rows")

# Save the cleaned CSV
df_cleaned.to_csv('cleaned_file.csv', index=False)

print("Cleaned CSV saved as 'cleaned_file.csv'")

# Alternative: Remove duplicates in Excel
# 1. Select all data
# 2. Go to Data > Remove Duplicates
# 3. Select the column that contains your primary key (ArtNouvCode)
# 4. Click OK
# 5. Save the file
