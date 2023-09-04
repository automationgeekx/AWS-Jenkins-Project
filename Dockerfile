FROM python:3.9-alpine

WORKDIR /flask_app

COPY requirements.txt .
COPY ./app /flask_app

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install pytest

COPY app/ .

COPY tests/ app/tests/

CMD [ "python", "app.py" ]