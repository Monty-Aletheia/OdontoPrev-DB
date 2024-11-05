SET SERVEROUTPUT ON;


-- Funções de Validação de Entrada de Dados (10 pontos):

CREATE OR REPLACE FUNCTION validate_patient (
    p_name IN VARCHAR2,
    p_birthday IN DATE,
    p_gender IN VARCHAR2,
    p_risk_status IN VARCHAR2
) RETURN BOOLEAN AS
BEGIN
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        RETURN FALSE;
    END IF;

    IF p_birthday > SYSDATE THEN
        RETURN FALSE;
    END IF;

    IF p_gender IS NULL OR NOT (p_gender IN ('Masculino', 'Feminino', 'Outro')) THEN
        RETURN FALSE;
    END IF;

    IF p_risk_status IS NULL OR NOT (p_risk_status IN ('BAIXO', 'MEDIO', 'ALTO')) THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE; 
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE; 
END validate_patient;

/

CREATE OR REPLACE FUNCTION validate_dentist (
    p_name IN VARCHAR2,
    p_registration_number IN VARCHAR2,
    p_risk_status IN VARCHAR2
) RETURN BOOLEAN AS
BEGIN
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        RETURN FALSE;
    END IF;

    IF p_registration_number IS NULL OR TRIM(p_registration_number) = '' THEN
        RETURN FALSE;
    END IF;

    IF LENGTH(p_registration_number) < 5 THEN
        RETURN FALSE;
    END IF;

    IF p_risk_status IS NULL OR NOT (p_risk_status IN ('BAIXO', 'MEDIO', 'ALTO')) THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END validate_dentist;

/

--  Procedures para Operações CRUD (20 pontos):

-- Patient

CREATE OR REPLACE PROCEDURE insert_patient(
    p_name VARCHAR2,
    p_birthday DATE,
    p_gender VARCHAR2,
    p_risk_status VARCHAR2,
    p_consultation_frequency NUMBER DEFAULT 0,
    p_associated_claims CLOB
) AS
BEGIN
    IF NOT validate_patient(p_name, p_birthday, p_gender, p_risk_status) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Dados inválidos para inserção de paciente.');
    END IF;

    INSERT INTO tb_patient (name, birthday, gender, risk_status, consultation_frequency, associated_claims)
    VALUES (p_name, p_birthday, p_gender, p_risk_status, p_consultation_frequency, p_associated_claims);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Erro ao inserir paciente: ' || SQLERRM);
END;

/

CREATE OR REPLACE PROCEDURE update_patient(
    p_id RAW,
    p_name VARCHAR2,
    p_birthday DATE,
    p_gender VARCHAR2,
    p_risk_status VARCHAR2,
    p_consultation_frequency NUMBER,
    p_associated_claims CLOB
) AS
BEGIN
    IF NOT validate_patient(p_name, p_birthday, p_gender, p_risk_status) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Dados inválidos para atualização de paciente.');
    END IF;

    UPDATE tb_patient
    SET name = p_name,
        birthday = p_birthday,
        gender = p_gender,
        risk_status = p_risk_status,
        consultation_frequency = p_consultation_frequency,
        associated_claims = p_associated_claims,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Paciente não encontrado para atualização.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Erro ao atualizar paciente: ' || SQLERRM);
END;

/

CREATE OR REPLACE PROCEDURE delete_patient(
    p_id RAW
) AS
BEGIN
    DELETE FROM tb_patient
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Paciente não encontrado para exclusão.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20007, 'Erro ao excluir paciente: ' || SQLERRM);
END;

/

-- Dentist

CREATE OR REPLACE PROCEDURE insert_dentist(
    p_name VARCHAR2,
    p_specialty VARCHAR2,
    p_registration_number VARCHAR2,
    p_risk_status VARCHAR2
) AS
BEGIN
    IF NOT validate_dentist(p_name, p_registration_number, p_risk_status) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Dados inválidos para inserção de dentista.');
    END IF;

    INSERT INTO tb_dentist (name, specialty, registration_number, risk_status)
    VALUES (p_name, p_specialty, p_registration_number, p_risk_status);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20009, 'Erro ao inserir dentista: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE update_dentist(
    p_id RAW,
    p_name VARCHAR2,
    p_specialty VARCHAR2,
    p_registration_number VARCHAR2,
    p_risk_status VARCHAR2
) AS
BEGIN
    IF NOT validate_dentist(p_name, p_registration_number, p_risk_status) THEN
        RAISE_APPLICATION_ERROR(-20010, 'Dados inválidos para atualização de dentista.');
    END IF;

    UPDATE tb_dentist
    SET name = p_name,
        specialty = p_specialty,
        registration_number = p_registration_number,
        risk_status = p_risk_status,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Dentista não encontrado para atualização.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20012, 'Erro ao atualizar dentista: ' || SQLERRM);
END;

/

CREATE OR REPLACE PROCEDURE delete_dentist(
    p_id RAW
) AS
BEGIN
    DELETE FROM tb_dentist
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Dentista não encontrado para exclusão.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20014, 'Erro ao excluir dentista: ' || SQLERRM);
END;

/

-- Consultation

CREATE OR REPLACE PROCEDURE insert_consultation(
    p_consultation_date DATE,
    p_consultation_value NUMBER,
    p_risk_status VARCHAR2,
    p_description VARCHAR2,
    p_patient_id RAW
) AS
BEGIN
    IF p_consultation_date IS NULL OR p_consultation_value IS NULL OR p_patient_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20015, 'Data, valor da consulta e ID do paciente são obrigatórios.');
    END IF;

    IF p_risk_status IS NULL OR NOT (p_risk_status IN ('BAIXO', 'MEDIO', 'ALTO')) THEN
        RAISE_APPLICATION_ERROR(-20016, 'Status de risco inválido.');
    END IF;

    INSERT INTO tb_consultation (consultation_date, consultation_value, risk_status, description, patient_id)
    VALUES (p_consultation_date, p_consultation_value, p_risk_status, p_description, p_patient_id);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20017, 'Erro ao inserir consulta: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE update_consultation(
    p_id RAW,
    p_consultation_date DATE,
    p_consultation_value NUMBER,
    p_risk_status VARCHAR2,
    p_description VARCHAR2
) AS
BEGIN
    IF p_consultation_date IS NULL OR p_consultation_value IS NULL THEN
        RAISE_APPLICATION_ERROR(-20018, 'Data e valor da consulta são obrigatórios.');
    END IF;

    IF p_risk_status IS NULL OR NOT (p_risk_status IN ('BAIXO', 'MEDIO', 'ALTO')) THEN
        RAISE_APPLICATION_ERROR(-20019, 'Status de risco inválido.');
    END IF;

    UPDATE tb_consultation
    SET consultation_date = p_consultation_date,
        consultation_value = p_consultation_value,
        risk_status = p_risk_status,
        description = p_description,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Consulta não encontrada para atualização.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20021, 'Erro ao atualizar consulta: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE delete_consultation(
    p_id RAW
) AS
BEGIN
    DELETE FROM tb_consultation
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20022, 'Consulta não encontrada para exclusão.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20023, 'Erro ao excluir consulta: ' || SQLERRM);
END;
/

-- Claim

CREATE OR REPLACE PROCEDURE insert_claim (
    p_occurrence_date IN DATE,
    p_value IN NUMBER,
    p_claim_type IN VARCHAR2,
    p_suggested_preventive_action IN CLOB,
    p_consultation_id IN RAW
) AS
BEGIN
    IF p_occurrence_date IS NULL OR p_value IS NULL OR p_consultation_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20025, 'Data de ocorrência, valor e ID da consulta são obrigatórios.');
    END IF;

    IF p_claim_type IS NULL OR LENGTH(p_claim_type) > 50 THEN
        RAISE_APPLICATION_ERROR(-20026, 'Tipo de reclamação inválido ou excede 50 caracteres.');
    END IF;

    INSERT INTO tb_claim (occurrence_date, value, claim_type, suggested_preventive_action, consultation_id)
    VALUES (p_occurrence_date, p_value, p_claim_type, p_suggested_preventive_action, p_consultation_id);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20027, 'Erro ao inserir reclamação: ' || SQLERRM);
END insert_tb_claim;
/

CREATE OR REPLACE PROCEDURE update_claim (
    p_id IN RAW,
    p_occurrence_date IN DATE,
    p_value IN NUMBER,
    p_claim_type IN VARCHAR2,
    p_suggested_preventive_action IN CLOB,
    p_consultation_id IN RAW
) AS
BEGIN
    IF p_id IS NULL OR p_occurrence_date IS NULL OR p_value IS NULL OR p_consultation_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20028, 'ID, data de ocorrência, valor e ID da consulta são obrigatórios.');
    END IF;

    IF p_claim_type IS NULL OR LENGTH(p_claim_type) > 50 THEN
        RAISE_APPLICATION_ERROR(-20029, 'Tipo de reclamação inválido ou excede 50 caracteres.');
    END IF;

    UPDATE tb_claim
    SET occurrence_date = p_occurrence_date,
        value = p_value,
        claim_type = p_claim_type,
        suggested_preventive_action = p_suggested_preventive_action,
        consultation_id = p_consultation_id,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20030, 'Reclamação não encontrada para atualização.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20031, 'Erro ao atualizar reclamação: ' || SQLERRM);
END update_tb_claim;
/

CREATE OR REPLACE PROCEDURE delete_claim (
    p_id IN RAW
) AS
BEGIN
    DELETE FROM tb_claim
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20032, 'Reclamação não encontrada para exclusão.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20033, 'Erro ao excluir reclamação: ' || SQLERRM);
END delete_tb_claim;
/


-- Função com Cursor e Joins para Relatório Formatado (20 pontos):

CREATE OR REPLACE FUNCTION report_consultations RETURN SYS_REFCURSOR AS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT 
            c.id AS consultation_id,
            TO_CHAR(c.consultation_date, 'DD-MM-YYYY') AS consultation_date,
            p.name AS patient_name,
            p.gender AS patient_gender,
            c.consultation_value AS consultation_value,
            c.risk_status AS consultation_risk_status,
            d.name AS dentist_name,
            d.registration_number AS dentist_registration_number
        FROM 
            tb_consultation c
        JOIN 
            tb_patient p ON c.patient_id = p.id
        LEFT JOIN 
            consultation_dentist cd ON c.id = cd.consultation_id
        LEFT JOIN 
            tb_dentist d ON cd.dentist_id = d.id
        ORDER BY 
            c.consultation_date;
    RETURN v_cursor;
END report_consultations;
/

-- Função para Relatório com Regra de Negócio:

CREATE OR REPLACE TYPE report_row AS OBJECT (
    dentist_name VARCHAR2(255),
    patient_name VARCHAR2(255),
    consultation_date DATE,
    consultation_value NUMBER,
    claim_count NUMBER,
    risk_status VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE report_table AS TABLE OF report_row;
/

CREATE OR REPLACE FUNCTION generate_report (
    p_start_date IN DATE,
    p_end_date IN DATE
) RETURN report_table AS
    v_report report_table := report_table();
BEGIN
    SELECT 
        d.name AS dentist_name,
        p.name AS patient_name,
        c.consultation_date,
        SUM(c.consultation_value) AS consultation_value,
        COUNT(cl.id) AS claim_count,
        p.risk_status
    BULK COLLECT INTO v_report
    FROM 
        tb_consultation c
    INNER JOIN 
        tb_patient p ON c.patient_id = p.id
    INNER JOIN 
        consultation_dentist cd ON c.id = cd.consultation_id
    INNER JOIN 
        tb_dentist d ON cd.dentist_id = d.id
    LEFT JOIN 
        tb_claim cl ON c.id = cl.consultation_id
    WHERE 
        c.consultation_date BETWEEN p_start_date AND p_end_date
    GROUP BY 
        d.name, p.name, c.consultation_date, p.risk_status
    ORDER BY 
        d.name, c.consultation_date;

    RETURN v_report;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20050, 'Erro ao gerar relatório: ' || SQLERRM);
END generate_report;
/

-- Execultando o codigo
DECLARE
    v_report report_table;
BEGIN
    v_report := generate_report(TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));
    
    FOR i IN 1 .. v_report.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Dentista: ' || v_report(i).dentist_name || 
                             ', Paciente: ' || v_report(i).patient_name || 
                             ', Data da Consulta: ' || v_report(i).consultation_date || 
                             ', Valor da Consulta: ' || v_report(i).consultation_value || 
                             ', Número de Reclamações: ' || v_report(i).claim_count || 
                             ', Status de Risco: ' || v_report(i).risk_status);
    END LOOP;
END;
/
