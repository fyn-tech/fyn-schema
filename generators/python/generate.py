import shutil
import os
from pathlib import Path
from datamodel_code_generator import generate

def generate_python_models():
    # Get the directory where this script is located
    script_dir = Path(os.path.dirname(os.path.abspath(__file__)))
    
    # Define paths relative to the script location
    schema_dir = (script_dir.parent).parent / "schema"
    package_root = (script_dir.parent).parent / "generated" / "python"
    package_dir = package_root / "fyn_schema"

    # Nuke (completely remove) the output directory if it exists
    if package_root.exists():
        shutil.rmtree(package_root)
    
    # Create fresh output directory
    package_dir.mkdir(parents=True, exist_ok=True)
    
    # Create an __init__.py file to make it a proper package
    with open(package_dir / "__init__.py", "w") as f:
        f.write("# Generated package\n")
    
    # Generate the Python models
    for schema_file in schema_dir.glob("**/*.json"):
        output_file = (package_dir / 
                       f"{schema_file.parent.name}_{schema_file.stem}.py")
        print(f"Generating: {output_file}")
        output_file.parent.mkdir(parents=True, exist_ok=True)
        generate(
            input_=schema_file,
            input_file_type="jsonschema",
            output=output_file
        )
    
    # Create pyproject.toml
    print(f"Creating: {package_root / 'pyproject.toml'}")
    with open(package_root / "pyproject.toml", "w") as f:
        f.write("""
[build-system]
requires = ["setuptools>=42", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "fyn-schema"
version = "0.1.0"
description = "Generated Python models from JSON schemas"
requires-python = ">=3.7"
dependencies = [
    "pydantic"
]

[tool.setuptools]
packages = [""]
        """.strip())

if __name__ == "__main__":
    generate_python_models()