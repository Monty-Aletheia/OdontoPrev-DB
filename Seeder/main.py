from db.db_config import get_connection
from db.seed import seed_patients, seed_dentists, seed_consultations, seed_claims, seed_consultation_dentist

cursor, connection = get_connection()

seed_patients(cursor, connection, 10)
print("Seed tb_patient com sucesso.")

seed_dentists(cursor, connection, 10)
print("Seed tb_dentist com sucesso.")

seed_consultations(cursor, connection, 10)
print("Seed tb_consultation com sucesso.")

seed_claims(cursor, connection, 10)
print("Seed tb_claim com sucesso.")

seed_consultation_dentist(cursor, connection, 10)
print("Seed consultation_dentist com sucesso.")

cursor.close()
connection.close()

print("Conexão fechada.")
