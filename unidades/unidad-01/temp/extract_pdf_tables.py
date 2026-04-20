import pdfplumber
import os
import csv
import re

def clean_filename(name):
    # Remove .pdf and replace problematic characters for filesystem
    name = name.replace('.pdf', '')
    return name

def extract_tables_from_pdf(pdf_path):
    tables = []
    with pdfplumber.open(pdf_path) as pdf:
        for i, page in enumerate(pdf.pages):
            # Try to extract table
            table = page.extract_table()
            if table:
                # Clean table: remove empty rows and rows that are all None
                cleaned = []
                for row in table:
                    if any(cell is not None and str(cell).strip() != '' for cell in row):
                        cleaned.append([str(cell).strip() if cell is not None else '' for cell in row])
                if cleaned:
                    tables.append((i, cleaned))
    return tables

def save_table_as_csv(table_data, base_name, page_num):
    csv_name = f"{base_name}_page{page_num+1}.csv"
    with open(csv_name, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(table_data)
    return csv_name

def main():
    input_dir = '.'
    pdf_files = [f for f in os.listdir(input_dir) if f.lower().endswith('.pdf')]
    print(f"Found {len(pdf_files)} PDF files")
    
    all_csv_info = []  # list of (pdf_name, csv_name, num_rows, num_cols)
    
    for pdf_file in pdf_files:
        print(f"\nProcessing {pdf_file}")
        base_name = clean_filename(pdf_file)
        tables = extract_tables_from_pdf(pdf_file)
        if not tables:
            print(f"  No tables found in {pdf_file}")
            continue
        for page_num, table_data in tables:
            csv_name = save_table_as_csv(table_data, base_name, page_num)
            rows = len(table_data)
            cols = len(table_data[0]) if table_data else 0
            print(f"  Page {page_num+1}: {rows} rows, {cols} cols -> {csv_name}")
            all_csv_info.append((pdf_file, csv_name, rows, cols))
    
    print("\n=== Summary ===")
    for pdf, csv, r, c in all_csv_info:
        print(f"{pdf} -> {csv}: {r} rows x {c} cols")
    
    # Now, let's check if we can combine CSVs: they must have same number of columns and similar headers?
    # We'll group by column count and then check header similarity.
    from collections import defaultdict
    by_cols = defaultdict(list)
    for pdf, csv, r, c in all_csv_info:
        by_cols[c].append((pdf, csv, r))
    
    print("\n=== By Column Count ===")
    for col_count, entries in by_cols.items():
        print(f"Column count {col_count}: {len(entries)} CSV(s)")
        for pdf, csv, r in entries:
            print(f"  {pdf} -> {csv} ({r} rows)")
    
    # For each group, try to see if headers match (first row)
    # We'll only attempt to combine if all CSVs in group have same header (or we can standardize)
    # But note: the user might want to keep separate if they are different tables.
    # We'll just report and let user decide.

if __name__ == '__main__':
    main()
