export csv_path := "/u01/omop/export/"

all: .make.ehr_check

.make.ehr_check:.make.venv
	# run ehr check file validation on OMOP tables in CSV
	. ./venv/bin/activate && \
	python3 omop_file_validator.py
	touch $@

.make.venv:
	# create python3 virtual environment
	python3 -m pip install --upgrade pip
	python3 -m pip install virtualenv
	python3 -m virtualenv venv
	. ./venv/bin/activate && \
	pip3 install --upgrade pip  && \
	pip3 install -r requirements.txt  && \
	pip3 freeze >  requirements_pip_freeze.txt  && \
	which pip3 && which python3 && python3 --version
	touch $@

clean:
	rm -rf venv
	rm -rf .make.*
