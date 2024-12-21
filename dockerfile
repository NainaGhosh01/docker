FROM python:3.9-slim

WORKDIR /app

COPY s3_to_rds_glue.py /app/

RUN pip install boto3 pymysql

CMD ["python", "s3_to_rds_glue.py"]
