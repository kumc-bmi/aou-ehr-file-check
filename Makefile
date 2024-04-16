all: .make.ehr_check

.make.get_pip:.make.venv
	rm -rf get-pip.py || true
	wget https://bootstrap.pypa.io/get-pip.py
	. ./.env &&\
	. ./venv/bin/activate && python3 get-pip.py

.make.ehr_check:.make.get_pip
	# run ehr check file validation on OMOP tables in CSV
	. ./.env && \
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
