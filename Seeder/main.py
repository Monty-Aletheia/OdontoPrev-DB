from db.db_config import get_connection
from db.seed import seed_patients, seed_dentists, seed_consultations, seed_claims, seed_consultation_dentist

cursor, connection = get_connection()

seed_patients(cursor, connection, 10)
seed_dentists(cursor, connection, 10)
seed_consultations(cursor, connection, 10)
seed_claims(cursor, connection, 10)
seed_consultation_dentist(cursor, connection, 10)

cursor.close()
connection.close()
