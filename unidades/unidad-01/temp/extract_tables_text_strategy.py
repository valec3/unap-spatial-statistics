import pdfplumber
import os
import csv as csv_module

def clean_table(table):
    """Remove rows that are all empty or all whitespace."""
    cleaned = []
    for row in table:
        # Convert each cell to string and strip, if cell is None make it empty string
        str_row = [str(cell).strip() if cell is not None else '' for cell in row]
        # Check if the row is not empty (at least one non-empty cell)
        if any(str_row):
            cleaned.append(str_row)
    return cleaned

def main():
    input_dir = 'Input'
    pdf_files = [f for f in os.listdir(input_dir) if f.lower().endswith('.pdf')]
    print(f"Found {len(pdf_files)} PDF files")
    
    all_csv_info = []  # list of (pdf_name, csv_name, num_rows, num_cols)
    
    for pdf_file in pdf_files:
        print(f"\nProcessing {pdf_file}")
        base_name = pdf_file.replace('.pdf', '')
        try:
            with pdfplumber.open(os.path.join(input_dir, pdf_file)) as pdf:
                for i, page in enumerate(pdf.pages):
                    # Extract table using text strategy for both vertical and horizontal
                    table = page.extract_table({
                        'vertical_strategy': 'text',
                        'horizontal_strategy': 'text'
                    })
                    if table:
                        cleaned = clean_table(table)
                        if cleaned:
                            csv_name = f"{base_name}_page{i+1}.csv"
                            with open(csv_name, 'w', newline='', encoding='utf-8') as csvfile:
                                writer = csv_module.writer(csvfile)
                                writer.writerows(cleaned)
                            rows_count = len(cleaned)
                            cols_count = len(cleaned[0]) if cleaned else 0
                            print(f"  Page {i+1}: {rows_count} rows, {cols_count} cols -> {csv_name}")
                            all_csv_info.append((pdf_file, csv_name, rows_count, cols_count))
                        else:
                            print(f"  Page {i+1}: Table found but all rows empty after cleaning")
                    else:
                        print(f"  Page {i+1}: No table found with text strategy")
        except Exception as e:
            print(f"  Error processing {pdf_file}: {e}")
    
    print("\n=== Summary ===")
    for pdf, csv_name, r, c in all_csv_info:
        print(f"{pdf} -> {csv_name}: {r} rows x {c} cols")
    
    # Group by column count to see which CSVs might be combinable
    from collections import defaultdict
    by_cols = defaultdict(list)
    for pdf, csv_name, r, c in all_csv_info:
        by_cols[c].append((pdf, csv_name, r))
    
    print("\n=== By Column Count ===")
    for col_count, entries in by_cols.items():
        print(f"Column count {col_count}: {len(entries)} CSV(s)")
        for pdf, csv_name, r in entries:
            print(f"  {pdf} -> {csv_name} ({r} rows)")
    
    # For each group with more than one CSV, check if headers match (first row)
    print("\n=== Header Matching within Column Groups ===")
    for col_count, entries in by_cols.items():
        if len(entries) > 1:
            print(f"\nGroup with {col_count} columns:")
            # Read the first row (header) of each CSV in this group
            headers = []
            for pdf, csv_name, r in entries:
                try:
                    with open(csv_name, 'r', encoding='utf-8') as f:
                        reader = csv_module.reader(f)
                        header = next(reader)
                        headers.append((csv_name, header))
                except Exception as e:
                    print(f"  Could not read header from {csv_name}: {e}")
            # Now compare headers
            if headers:
                first_header = headers[0][1]
                all_match = True
                for csv_name, header in headers[1:]:
                    if header != first_header:
                        all_match = False
                        break
                if all_match:
                    print(f"  All {len(headers)} CSVs have the same header: {first_header}")
                else:
                    print(f"  Headers differ:")
                    for csv_name, header in headers:
                        print(f"    {csv_name}: {header}")
        else:
            # Single CSV in group, just note
            pass

if __name__ == '__main__':
    main()
