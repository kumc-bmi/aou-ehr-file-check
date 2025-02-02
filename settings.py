import inspect
import os
from os import environ

base_path = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
resource_path = os.path.join(base_path, 'resources')
html_boilerplate = os.path.join(resource_path, 'html_boilerplate.txt')
test_path = os.path.join(base_path, 'tests')
test_resource_path = os.path.join(test_path, 'resources')
example_path = os.path.join(test_resource_path, 'examples_erroneous')
cdm_metadata_path = os.path.join(resource_path, 'omop')

# Configuration
csv_path = environ['csv_path']
print(csv_path)
csv_dir = csv_path  # location of files to validate, evaluate
