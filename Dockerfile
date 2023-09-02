# start by pulling the python image
FROM python:3.8-alpine

# copy the requirements file into the image
COPY ./requirements.txt /app/requirements.txt

# switch working directory
WORKDIR /app

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

RUN pip install pytest

# copy every content from the local file to the image
COPY . /app

COPY tests/ app/tests/

CMD ["python","view.py" ]
