import os
import csv
from collections import defaultdict

def read_csv_header_and_rows(csv_path):
    '''Return (header, rows) where header is a list of strings, rows is a list of lists.'''
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        rows = list(reader)
    if not rows:
        return None, []
    header = rows[0]
    data_rows = rows[1:]
    return header, data_rows

def main():
    input_dir = '.'
    # Find all CSV files
    csv_files = [f for f in os.listdir(input_dir) if f.lower().endswith('.csv')]
    print("Found {} CSV files".format(len(csv_files)))
    
    # Group CSV files by PDF name (remove _pageX.csv suffix)
    pdf_to_csvs = defaultdict(list)
    for csv_file in csv_files:
        # Remove the _pageX.csv part
        base = csv_file
        if '_page' in base:
            base = base.split('_page')[0]
        pdf_to_csvs[base].append(csv_file)
    
    # For each PDF, try to combine pages that have the same structure
    for pdf_name, csv_list in pdf_to_csvs.items():
        print("\n=== Processing {} ===".format(pdf_name))
        # Group by (num_columns, header_tuple)
        groups = defaultdict(list)  # key: (num_cols, header_tuple) -> list of csv files
        for csv_file in csv_list:
            header, data_rows = read_csv_header_and_rows(csv_file)
            if header is None:
                print("  Skipping {}: empty or unreadable".format(csv_file))
                continue
            key = (len(header), tuple(header))
            groups[key].append((csv_file, header, data_rows))
        
        # If there is only one group, we can combine all pages
        if len(groups) == 1:
            key, items = list(groups.items())[0]
            num_cols, header_tuple = key
            header = list(header_tuple)
            print("  All {} pages have the same structure: {} columns".format(len(items), num_cols))
            print("  Header: {}".format(header))
            # Combine all data rows
            combined_rows = []
            for csv_file, _, data_rows in items:
                combined_rows.extend(data_rows)
            # Write combined CSV
            output_csv = "{}_combined.csv".format(pdf_name)
            with open(output_csv, 'w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                writer.writerow(header)
                writer.writerows(combined_rows)
            print("  Combined into {} with {} data rows".format(output_csv, len(combined_rows)))
        else:
            print("  Found {} different structures:".format(len(groups)))
            for key, items in groups.items():
                num_cols, header_tuple = key
                header = list(header_tuple)
                total_rows = sum(len(data_rows) for _, _, data_rows in items)
                print("    Group: {} columns, header: {}".format(num_cols, header))
                print("      Files: {}".format([csv_file for csv_file, _, _ in items]))
                print("      Total data rows: {}".format(total_rows))
            # We do not combine; leave them as separate CSVs
            print("  Not combining due to differing structures.")
    
    print("\n=== Done ===")

if __name__ == '__main__':
    main()
