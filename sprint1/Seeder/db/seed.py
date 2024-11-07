import uuid
from faker import Faker

fake = Faker()

def generate_uuid():
    return uuid.uuid4().bytes

def seed_patients(cursor, connection, n):
    for _ in range(n):
        id = generate_uuid()
        name = fake.name()
        birthday = fake.date_of_birth(minimum_age=18, maximum_age=80)
        gender = fake.random_element(elements=("M", "F"))
        risk_status = fake.random_element(elements=("Low", "Medium", "High"))
        consultation_frequency = fake.random_int(min=0, max=20)
        associated_claims = fake.text(max_nb_chars=200)
        
        cursor.execute("""
            INSERT INTO tb_patient (id, name, birthday, gender, risk_status, consultation_frequency, associated_claims)
            VALUES (:1, :2, :3, :4, :5, :6, :7)
        """, (id, name, birthday, gender, risk_status, consultation_frequency, associated_claims))
        
    connection.commit()

def seed_dentists(cursor, connection, n):
    for _ in range(n):
        id = generate_uuid()
        name = fake.name()
        specialty = fake.job()
        registration_number = fake.unique.random_number(digits=10)
        claims_rate = fake.random_number(digits=2)
        risk_status = fake.random_element(elements=("Low", "Medium", "High"))
        
        cursor.execute("""
            INSERT INTO tb_dentist (id, name, specialty, registration_number, claims_rate, risk_status)
            VALUES (:1, :2, :3, :4, :5, :6)
        """, (id, name, specialty, registration_number, claims_rate, risk_status))
        
    connection.commit()

def seed_consultations(cursor, connection, n):
    for _ in range(n):
        id = generate_uuid()
        consultation_date = fake.date_this_year()
        consultation_value = fake.random_number(digits=4)
        risk_status = fake.random_element(elements=("Low", "Medium", "High"))
        description = fake.text(max_nb_chars=100)
        patient_id = fake.random_element(elements=fetch_patient_ids(cursor))
        
        cursor.execute("""
            INSERT INTO tb_consultation (id, consultation_date, consultation_value, risk_status, description, patient_id)
            VALUES (:1, :2, :3, :4, :5, :6)
        """, (id, consultation_date, consultation_value, risk_status, description, patient_id))
        
    connection.commit()

def seed_claims(cursor, connection, n):
    for _ in range(n):
        id = generate_uuid()
        occurrence_date = fake.date_this_year()
        value = fake.random_number(digits=4)
        claim_type = fake.random_element(elements=("Type A", "Type B", "Type C"))
        suggested_preventive_action = fake.text(max_nb_chars=200)
        consultation_id = fake.random_element(elements=fetch_consultation_ids(cursor))
        
        cursor.execute("""
            INSERT INTO tb_claim (id, occurrence_date, value, claim_type, suggested_preventive_action, consultation_id)
            VALUES (:1, :2, :3, :4, :5, :6)
        """, (id, occurrence_date, value, claim_type, suggested_preventive_action, consultation_id))
        
    connection.commit()

def seed_consultation_dentist(cursor, connection, n):
    for _ in range(n):
        consultation_id = fake.random_element(elements=fetch_consultation_ids(cursor))
        dentist_id = fake.random_element(elements=fetch_dentist_ids(cursor))
        
        cursor.execute("""
            INSERT INTO consultation_dentist (consultation_id, dentist_id)
            VALUES (:1, :2)
        """, (consultation_id, dentist_id))
        
    connection.commit()

def fetch_patient_ids(cursor):
    cursor.execute("SELECT id FROM tb_patient")
    return [row[0] for row in cursor.fetchall()]

def fetch_consultation_ids(cursor):
    cursor.execute("SELECT id FROM tb_consultation")
    return [row[0] for row in cursor.fetchall()]

def fetch_dentist_ids(cursor):
    cursor.execute("SELECT id FROM tb_dentist")
    return [row[0] for row in cursor.fetchall()]
