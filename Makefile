export csv_path := /u01/omop/export/
psql=psql -v ON_ERROR_STOP=1 -c "set role fh_phi_admin;"

all: .make.ehr_check

.make.ehr_check:.make.venv
	# run ehr check file validation on OMOP tables in CSV
	. ./venv/bin/activate && \
	python3 omop_file_validator.py
	touch $@

## export tables to csv
.make.export_tables: .make.export_person .make.visit_occurrence .make.condition_occurrence .make.drug_exposure
.make.export_tables: .make.measurement .make.procedure_occurrence .make.observation .make.device_exposure
.make.export_tables: .make.death make.fact_relationship .make.specimen

.make.export_person:
	$(psql)  -c "COPY omop_id_allofus.person TO '$(csv_path)person.csv' WITH CSV HEADER;"

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
