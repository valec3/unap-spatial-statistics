# PDF to CSV Conversion Summary

## Process
1. Extracted tables from each PDF in the `Input/` directory using pdfplumber with text strategy for both vertical and horizontal text extraction.
2. Saved each table as a separate CSV file named `<pdfname>_pageX.csv` in the `Input/` directory.
3. Attempted to combine pages of the same PDF that had the same structure (same number of columns and identical header row).
4. For PDFs where all pages had the same structure, created a combined CSV named `<pdfname>_combined.csv` in the current directory.
5. For PDFs with varying page structures, left the per-page CSV files in `Input/` and did not combine.

## Results

### Combined CSV Files (in current directory)
The following PDFs had consistent structure across all pages and were combined:

- `PRODUCCI�N DE LECHE_combined.csv` (5 pages, 266 data rows, 12 columns)
- `result-01_combined.csv` (1 page, 4 data rows, 9 columns) [Note: result-01.pdf was already present in temp]
- `VACAS GESTANTES_combined.csv` (2 pages, 106 data rows, 10 columns)
- `VACAS INSEMINADAS_combined.csv` (1 page, 53 data rows, 14 columns)
- `VACAS PROBLEMA_combined.csv` (1 page, 21 data rows, 9 columns)
- `VACAS PROXIMAS AL PARTO_combined.csv` (1 page, 29 data rows, 11 columns)
- `VACAS SECAS_combined.csv` (1 page, 20 data rows, 10 columns)
- `VAQUILLAS PARA TEST DE PRE�EZ_combined.csv` (1 page, 32 data rows, 10 columns)
- `VAQUILLAS PROXIMAS AL PARTO_combined.csv` (1 page, 23 data rows, 11 columns)

### Per-Page CSV Files (in Input/ directory)
The following PDFs had pages with different structures (different column counts or headers) and were not combined. Each page remains as a separate CSV:

- `MASTITIS.pdf`: 
  - Pages 1,3,4,5: 9 columns (59 rows each for pages 1-4, 9 rows for page 5)
  - Page 2: 10 columns (59 rows)
- `ORDE�O.pdf`:
  - Page 1: 9 columns (59 rows)
  - Pages 2,4,5,6,7: 10 columns (60 rows each for pages 2,4,5,6,7)
  - Page 3: 9 columns (59 rows)
  - Page 8: 9 columns (6 rows)
- `TEST DE PRE�EZ VACAS.pdf`:
  - Page 1: 10 columns (53 rows)
  - Page 2: 7 columns (7 rows)
- `TEST DE PRE�EZ.pdf`:
  - Page 1: 10 columns (53 rows)
  - Page 2: 7 columns (7 rows)
- `VACAS PARA SECAR.pdf`:
  - Page 1: 10 columns (59 rows)
  - Page 2: 11 columns (48 rows)
- `VAQUILLAS.pdf`:
  - Page 1: 15 columns (52 rows)
  - Page 2: 24 columns (52 rows)
  - Page 3: 12 columns (62 rows)
  - Page 4: 13 columns (13 rows)

## Notes on Data Quality
- The extracted headers are fragmented due to the text-based table extraction algorithm splitting on visual gaps rather than logical column boundaries. For example, a header like "N� Edad -Lactaci�n- leche D�as Fecha Comentario 1 Comentario 2" was split into multiple columns such as ['N�', 'Edad -L', 'acta', 'ci�n-', 'leche', 'D�as', 'Fecha Co', 'mentario 1 C', 'omentario 2'].
- Users may need to post-process the CSV files to merge fragmented header fields and clean the data.
- The data rows appear to be correctly extracted, but verification against the original PDFs is recommended.

## Next Steps
1. For combined CSV files, consider cleaning the header by merging appropriate columns (e.g., merge 'N�', 'Edad -L', 'acta', 'ci�n-' into a single column "N� Edad -Lactaci�n-").
2. For per-page CSVs with inconsistent structure, decide whether to:
   - Manually adjust each page to have a common structure (e.g., by adding empty columns or splitting columns) and then combine.
   - Analyze each page separately if they represent different tables.
3. Validate a sample of rows against the original PDFs to ensure accuracy.
4. Consider using other tabular extraction methods (like tabula-py or manual定位) if the current results are insufficient.
