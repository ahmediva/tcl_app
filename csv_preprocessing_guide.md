-- CSV Preprocessing Instructions
-- Before importing your CSV file into Supabase, follow these steps:

-- 1. Open your CSV file in Excel or a text editor
-- 2. Use Find & Replace (Ctrl+H) to replace:
--    - Find: "NULL"
--    - Replace: (leave empty)
--    - Make sure to replace ALL occurrences

-- 3. Alternative: Use this Python script to clean your CSV:

import pandas as pd
import numpy as np

# Read the CSV file
df = pd.read_csv('your_file.csv')

# Replace 'NULL' strings with actual NaN (null) values
df = df.replace('NULL', np.nan)
df = df.replace('', np.nan)

# Save the cleaned CSV
df.to_csv('cleaned_file.csv', index=False)

print("CSV file cleaned successfully!")
print(f"Original shape: {df.shape}")
print(f"Null values per column:")
print(df.isnull().sum())

-- 4. Import the cleaned CSV file into Supabase

-- 5. If you still get errors, try importing with these settings:
--    - Delimiter: Comma (,)
--    - Quote character: Double quote (")
--    - Header: Yes
--    - Encoding: UTF-8
