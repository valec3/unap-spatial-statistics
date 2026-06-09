import libpysal
import geopandas as gpd
import os
import glob

# Check stlouis, south, and Bostonhsg
for dataset_name in ['stlouis', 'south', 'Bostonhsg']:
    try:
        # Get the example directory
        example_dir = libpysal.examples.get_path(dataset_name)
        print(f"\n--- Dataset: {dataset_name} ---")
        print(f"Directory: {example_dir}")
        print("Files in directory:")
        for file in os.listdir(example_dir):
            print(f"  - {file}")
        
        # Find shp files
        shp_files = glob.glob(os.path.join(example_dir, "*.shp"))
        if shp_files:
            print(f"\nFound shapefiles: {shp_files}")
            gdf = gpd.read_file(shp_files[0])
            print("Columns:", list(gdf.columns))
    except Exception as e:
        print(f"\n--- Dataset: {dataset_name} ---")
        print("Error:", str(e))
        import traceback
        traceback.print_exc()
