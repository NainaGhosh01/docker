import boto3
import pymysql

def read_from_s3(bucket_name, file_key):
    s3 = boto3.client('s3')
    response = s3.get_object(Bucket=bucket_name, Key=file_key)
    return response['Body'].read().decode('utf-8')

def write_to_rds(data):
    try:
        connection = pymysql.connect(
            host='your-rds-endpoint',
            user='admin',
            password='password123',
            database='mydatabase'
        )
        with connection.cursor() as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS Data (content TEXT)")
            cursor.execute("INSERT INTO Data (content) VALUES (%s)", (data,))
        connection.commit()
        print("Data inserted into RDS.")
    except Exception as e:
        print("Failed to insert into RDS:", str(e))
        raise
    finally:
        connection.close()

def write_to_glue(data):
    glue = boto3.client('glue')
    print("Write logic to Glue here. Data:", data)

if __name__ == "__main__":
    bucket_name = "my-s3-bucket"
    file_key = "data.txt"
    try:
        data = read_from_s3(bucket_name, file_key)
        write_to_rds(data)
    except Exception:
        write_to_glue(data)
