export csv_path := /u01/omop/export/
psql=psql -v "ON_ERROR_STOP=1"

all: .make.counts

.make.counts: .make.ehr_check
	cd $(csv_path) &&\
	wc -l * | sort -n &&\
	wc -l errors/* | sort -n
	touch $@

.make.ehr_check:.make.venv .make.export_tables
	# run ehr check file validation on OMOP tables in CSV
	. ./venv/bin/activate && \
	python3 omop_file_validator.py
	touch $@

## export tables to csv
.make.export_tables: .make.person .make.visit_occurrence .make.condition_occurrence .make.drug_exposure
.make.export_tables: .make.measurement .make.procedure_occurrence .make.observation .make.device_exposure
.make.export_tables: .make.death .make.fact_relationship .make.specimen
	touch $@

.make.person:
	$(psql)  -c "\COPY (select * from omop_id_allofus.person) TO '$(csv_path)person.csv' WITH (FORMAT CSV, HEADER);"
	touch $@

.make.visit_occurrence:
	$(psql) -c "\COPY (select * from omop_id_allofus.visit_occurrence) TO '$(csv_path)visit_occurrence.csv' WITH (FORMAT CSV, HEADER);"
	touch $@
.make.condition_occurrence:
	$(psql) -c "\COPY (select * from omop_id_allofus.condition_occurrence) TO '$(csv_path)condition_occurrence.csv' WITH (FORMAT CSV, HEADER);"
	touch $@

.make.drug_exposure:
	$(psql) -c "\COPY (select * from omop_id_allofus.drug_exposure) TO '$(csv_path)drug_exposure.csv' WITH (FORMAT CSV, HEADER);"
	touch $@

.make.measurement:
	$(psql) -c "\COPY (select * from omop_id_allofus.measurement) TO '$(csv_path)measurement.csv' WITH (FORMAT CSV, HEADER);"
	touch $@

.make.procedure_occurrence:
	$(psql) -c "\COPY (select * from omop_id_allofus.procedure_occurrence) TO '$(csv_path)procedure_occurrence.csv' WITH (FORMAT CSV, HEADER);"
	touch $@

.make.observation:
	$(psql) -c "\COPY (select * from omop_id_allofus.observation) TO '$(csv_path)observation.csv' WITH (FORMAT CSV, HEADER);"
	touch $@

.make.device_exposure:
	$(psql) -c "\COPY (select * from omop_id_allofus.device_exposure) TO '$(csv_path)device_exposure.csv' WITH (FORMAT CSV, HEADER);"
	touch $@

.make.death:
	$(psql) -c "\COPY (select * from omop_id_allofus.death) TO '$(csv_path)death.csv' WITH (FORMAT CSV, HEADER);"
	touch $@

.make.fact_relationship:
	$(psql) -c "\COPY (select * from omop_id_allofus.fact_relationship) TO '$(csv_path)fact_relationship.csv' WITH (FORMAT CSV, HEADER);"
	touch $@

.make.specimen:
	$(psql) -c "\COPY (select * from omop_id_allofus.specimen) TO '$(csv_path)specimen.csv' WITH (FORMAT CSV, HEADER);"
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
