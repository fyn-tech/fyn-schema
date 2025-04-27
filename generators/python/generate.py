# generators/python/generate.py

from pathlib import Path
from datamodel_code_generator import generate

def generate_python_models():
    schema_dir = Path("schema")
    output_dir = Path("generated/python")
    output_dir.mkdir(parents=True, exist_ok=True)
    
    for schema_file in schema_dir.glob("**/*.json"):
        
        output_file = (output_dir / 
                       f"{schema_file.parent.name}_{schema_file.stem}.py")
        print(output_file)
        output_file.parent.mkdir(parents=True, exist_ok=True)
        generate(
            input_=schema_file,
            input_file_type="jsonschema",
            output=output_file
        )

if __name__ == "__main__":
    generate_python_models()