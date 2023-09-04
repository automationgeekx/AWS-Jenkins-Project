FROM python:3.9-alpine

WORKDIR /flask_app

COPY requirements.txt .
COPY ./app /flask_app/app
COPY ./tests /flask_app/tests

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install pytest

CMD [ "python", "app/app.py" ]
