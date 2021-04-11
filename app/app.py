import boto3
import psycopg2

ssm = boto3.client('ssm')
ENDPOINT=ssm.get_parameter(Name='DB_ENDPOINT', WithDecryption=True)['Parameter']['Value']
PORT=ssm.get_parameter(Name='DB_PORT', WithDecryption=True)['Parameter']['Value']
USER=ssm.get_parameter(Name='DB_USER', WithDecryption=True)['Parameter']['Value']
PASSWORD=ssm.get_parameter(Name='DB_PASSWORD', WithDecryption=True)['Parameter']['Value']
REGION=ssm.get_parameter(Name='DB_REGION', WithDecryption=True)['Parameter']['Value']
DBNAME=ssm.get_parameter(Name='DB_DBNAME', WithDecryption=True)['Parameter']['Value']

try:
    conn = psycopg2.connect(host=ENDPOINT, port=PORT, database=DBNAME, user=USER, password=PASSWORD)
    cur = conn.cursor()
    cur.execute("""SELECT current_database(), current_user, version()""")
    query_results = cur.fetchall()
    print(f"Connected to {query_results[0][0]} database with {query_results[0][1]} as user")
    print(f"Version information: {query_results[0][2]}")
except Exception as e:
    print(f"Database connection failed due to {e}")