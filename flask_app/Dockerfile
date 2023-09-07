#
FROM python:3.11

#
WORKDIR /code/

#
COPY ./requirements.txt /code/requirements.txt
CMD echo Hello Adi
CMD cat /code/requirements.txt


RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

#
COPY ./ /code/
CMD echo Hello Adi





#
CMD ["python", "app.py", "--host", "0.0.0.0", "--port", "80"]
