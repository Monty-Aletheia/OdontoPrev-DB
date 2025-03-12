-- Tabela tb_patient
CREATE TABLE tb_patient (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    birthday DATE NOT NULL,
    gender VARCHAR2(50) NOT NULL, 
    risk_status VARCHAR2(50) NOT NULL, 
    consultation_frequency NUMBER DEFAULT 0,
    associated_claims CLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela tb_dentist
CREATE TABLE tb_dentist (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    password VARCHAR2(255) NOT NULL,
    specialty VARCHAR2(255),
    registration_number VARCHAR2(50) UNIQUE NOT NULL,
    claims_rate NUMBER(5, 2) DEFAULT 0.00,
    risk_status VARCHAR2(50) NOT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela tb_consultation
CREATE TABLE tb_consultation (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    consultation_date DATE NOT NULL, 
    consultation_value NUMBER(10, 2) NOT NULL,
    risk_status VARCHAR2(50) NOT NULL,
    description VARCHAR2(255),
    patient_id RAW(16) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES tb_patient(id)
);


-- Tabela tb_claim
CREATE TABLE tb_claim (
    id RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    occurrence_date DATE NOT NULL,
    value NUMBER(10, 2) NOT NULL,
    claim_type VARCHAR2(50) NOT NULL, 
    suggested_preventive_action CLOB,
    consultation_id RAW(16) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consultation_id) REFERENCES tb_consultation(id)
);

-- Tabela de associa��o entre tb_consultation e tb_dentist (Many-to-Many)
CREATE TABLE consultation_dentist (
    consultation_id RAW(16) NOT NULL,
    dentist_id RAW(16) NOT NULL,
    PRIMARY KEY (consultation_id, dentist_id),
    FOREIGN KEY (consultation_id) REFERENCES tb_consultation(id) ON DELETE CASCADE,
    FOREIGN KEY (dentist_id) REFERENCES tb_dentist(id) ON DELETE CASCADE
);

CREATE TABLE audit_log (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name VARCHAR2(50) NOT NULL,
    operation_type VARCHAR2(10) NOT NULL,
    record_id RAW(16) NOT NULL,
    old_values CLOB,
    new_values CLOB,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- DROP TABLE consultation_dentist;
-- DROP TABLE tb_claim;
-- DROP TABLE tb_consultation;
-- DROP TABLE tb_dentist;
-- DROP TABLE tb_patient;
-- DROP TABLE audit_log;

Select * from consultation_dentist;
Select * from tb_claim;
Select * from tb_consultation;
Select * from tb_dentist;
Select * from tb_patient;
Select * from audit_log;
