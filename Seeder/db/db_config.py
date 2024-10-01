import oracledb
from dotenv import load_dotenv
import os

load_dotenv()

def get_connection():
    user = os.getenv("USER_BD")
    password = os.getenv("USER_PW")

    if not all([user, password]):
        raise ValueError("Alguma das variáveis de ambiente não está definida.")
    
    dsn_str = oracledb.makedsn("oracle.fiap.com.br", 1521, "ORCL")
    connection = oracledb.connect(user=user, password=password, dsn=dsn_str)
    cursor = connection.cursor()
    
    return cursor, connection
