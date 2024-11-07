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

    IF p_gender IS NULL OR NOT (p_gender IN ('M', 'F')) THEN
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
    p_password VARCHAR2,
    p_registration_number IN VARCHAR2,
    p_risk_status IN VARCHAR2
) RETURN BOOLEAN AS
    v_count INTEGER;
BEGIN
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        RETURN FALSE;
    END IF;

    IF p_password IS NULL OR TRIM(p_password) = '' THEN
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
    p_associated_claims CLOB,
    p_patient_id OUT RAW 
) AS
BEGIN
    IF NOT validate_patient(p_name, p_birthday, p_gender, p_risk_status) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Dados inválidos para inserção de paciente.');
    END IF;

    INSERT INTO tb_patient (name, birthday, gender, risk_status, consultation_frequency, associated_claims)
    VALUES (p_name, p_birthday, p_gender, p_risk_status, p_consultation_frequency, p_associated_claims)
    RETURNING id INTO p_patient_id; 
    
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
    p_associated_claims CLOB,
    p_patient_id OUT RAW 
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
    WHERE id = p_id
    RETURNING id INTO p_patient_id; 


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
    p_password VARCHAR2,
    p_specialty VARCHAR2,
    p_registration_number VARCHAR2,
    p_risk_status VARCHAR2,
    p_dentist_id OUT RAW 
) AS
BEGIN
    IF NOT validate_dentist(p_name, p_password, p_registration_number, p_risk_status) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Dados inválidos para inserção de dentista.');
    END IF;

    INSERT INTO tb_dentist (name, password, specialty, registration_number, risk_status)
    VALUES (p_name, p_password, p_specialty, p_registration_number, p_risk_status)
    RETURNING id INTO p_dentist_id; 

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
    p_password VARCHAR2,
    p_specialty VARCHAR2,
    p_registration_number VARCHAR2,
    p_risk_status VARCHAR2,
    p_dentist_id OUT RAW 
) AS
BEGIN
    IF NOT validate_dentist(p_name, p_password, p_registration_number, p_risk_status) THEN
        RAISE_APPLICATION_ERROR(-20010, 'Dados inválidos para atualização de dentista.');
    END IF;

    UPDATE tb_dentist
    SET name = p_name,
        password = p_password,
        specialty = p_specialty,
        registration_number = p_registration_number,
        risk_status = p_risk_status,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id
    RETURNING id INTO p_dentist_id; 

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
    p_patient_id RAW,
    p_dentist_ids IN SYS.ODCIVARCHAR2LIST, 
    p_consultation_id OUT RAW
) AS
BEGIN
    IF p_consultation_date IS NULL OR p_consultation_value IS NULL OR p_patient_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20015, 'Data, valor da consulta e ID do paciente são obrigatórios.');
    END IF;

    IF p_risk_status IS NULL OR NOT (p_risk_status IN ('BAIXO', 'MEDIO', 'ALTO')) THEN
        RAISE_APPLICATION_ERROR(-20016, 'Status de risco inválido.');
    END IF;

    INSERT INTO tb_consultation (consultation_date, consultation_value, risk_status, description, patient_id)
    VALUES (p_consultation_date, p_consultation_value, p_risk_status, p_description, p_patient_id)
    RETURNING id INTO p_consultation_id; 

    FOR i IN 1 .. p_dentist_ids.COUNT LOOP
        INSERT INTO consultation_dentist (consultation_id, dentist_id)
        VALUES (p_consultation_id, p_dentist_ids(i)); 
    END LOOP;

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
    p_description VARCHAR2,  
    p_dentist_ids IN SYS.ODCIVARCHAR2LIST,  
    p_consultation_id OUT RAW 
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
    WHERE id = p_id
    RETURNING id INTO p_consultation_id;  

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Consulta não encontrada para atualização.');
    END IF;

    DELETE FROM consultation_dentist
    WHERE consultation_id = p_id;

    FOR i IN 1 .. p_dentist_ids.COUNT LOOP
        INSERT INTO consultation_dentist (consultation_id, dentist_id)
        VALUES (p_consultation_id, p_dentist_ids(i));  
    END LOOP;

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
    p_consultation_id IN RAW,
    p_claim_id OUT RAW 
) AS
BEGIN
    IF p_occurrence_date IS NULL OR p_value IS NULL OR p_consultation_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20025, 'Data de ocorrência, valor e ID da consulta são obrigatórios.');
    END IF;

    IF p_claim_type IS NULL OR LENGTH(p_claim_type) > 50 THEN
        RAISE_APPLICATION_ERROR(-20026, 'Tipo de Sinistro inválido ou excede 50 caracteres.');
    END IF;

    INSERT INTO tb_claim (occurrence_date, value, claim_type, suggested_preventive_action, consultation_id)
    VALUES (p_occurrence_date, p_value, p_claim_type, p_suggested_preventive_action, p_consultation_id)
    RETURNING id INTO p_claim_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20027, 'Erro ao inserir Sinistro: ' || SQLERRM);
END insert_claim;
/

CREATE OR REPLACE PROCEDURE update_claim (
    p_id IN RAW,
    p_occurrence_date IN DATE,
    p_value IN NUMBER,
    p_claim_type IN VARCHAR2,
    p_suggested_preventive_action IN CLOB,
    p_consultation_id IN RAW,
    p_claim_id OUT RAW 
) AS
BEGIN
    IF p_id IS NULL OR p_occurrence_date IS NULL OR p_value IS NULL OR p_consultation_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20028, 'ID, data de ocorrência, valor e ID da consulta são obrigatórios.');
    END IF;

    IF p_claim_type IS NULL OR LENGTH(p_claim_type) > 50 THEN
        RAISE_APPLICATION_ERROR(-20029, 'Tipo de Sinistro inválido ou excede 50 caracteres.');
    END IF;

    UPDATE tb_claim
    SET occurrence_date = p_occurrence_date,
        value = p_value,
        claim_type = p_claim_type,
        suggested_preventive_action = p_suggested_preventive_action,
        consultation_id = p_consultation_id,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id
    RETURNING id INTO p_claim_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20030, 'Sinistro não encontrada para atualização.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20031, 'Erro ao atualizar Sinistro: ' || SQLERRM);
END update_claim;
/

CREATE OR REPLACE PROCEDURE delete_claim (
    p_id IN RAW
) AS
BEGIN
    DELETE FROM tb_claim
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20032, 'Sinistro não encontrada para exclusão.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20033, 'Erro ao excluir Sinistro: ' || SQLERRM);
END delete_claim;
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

CREATE OR REPLACE TYPE report_row FORCE AS OBJECT (
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
    FOR rec IN (
        SELECT 
            d.name AS dentist_name,
            p.name AS patient_name,
            c.consultation_date,
            SUM(c.consultation_value) AS consultation_value,
            COUNT(cl.id) AS claim_count,
            p.risk_status
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
            d.name, c.consultation_date
    ) LOOP
        v_report.EXTEND; 
        v_report(v_report.LAST) := report_row(
            rec.dentist_name,
            rec.patient_name,
            rec.consultation_date,
            rec.consultation_value,
            rec.claim_count,
            rec.risk_status
        );
    END LOOP;

    RETURN v_report;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20050, 'Erro ao gerar relatório: ' || SQLERRM);
END generate_report;
/

-- Executando o codigo

--Patient
DECLARE
    v_patient_id RAW(16);
    v_name VARCHAR2(100) := 'João da Silva';
    v_birthday DATE := TO_DATE('1980-05-15', 'YYYY-MM-DD');
    v_gender VARCHAR2(1) := 'M';  
    v_risk_status VARCHAR2(20) := 'ALTO';
    v_consultation_frequency NUMBER := 3;  
    v_associated_claims CLOB := 'Plano de saúde XYZ';  
BEGIN
    insert_patient(
        p_name => v_name,
        p_birthday => v_birthday,
        p_gender => v_gender,
        p_risk_status => v_risk_status,
        p_consultation_frequency => v_consultation_frequency,
        p_associated_claims => v_associated_claims,
        p_patient_id => v_patient_id
    );

    DBMS_OUTPUT.PUT_LINE('Paciente inserido com ID: ' || RAWTOHEX(v_patient_id));

    update_patient(
        p_id => v_patient_id, 
        p_name => 'seila',
        p_birthday => v_birthday,
        p_gender => v_gender,
        p_risk_status => v_risk_status,
        p_consultation_frequency => v_consultation_frequency,
        p_associated_claims => v_associated_claims,
        p_patient_id => v_patient_id
    );

    DBMS_OUTPUT.PUT_LINE('Paciente atualizado com ID: ' || RAWTOHEX(v_patient_id));

    delete_patient(
        p_id => v_patient_id
    );

    DBMS_OUTPUT.PUT_LINE('Paciente com ID ' || RAWTOHEX(v_patient_id) || ' excluído com sucesso.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao executar as procedures: ' || SQLERRM);
END;
/

--Dentist

DECLARE
    v_dentist_id RAW(16);
    v_name VARCHAR2(100) := 'Dr.João Silva';
    v_password VARCHAR2(50) := '12345678';
    v_specialty VARCHAR2(50) := 'Ortodontia';
    v_registration_number VARCHAR2(20) := '1234543rasda';
    v_risk_status VARCHAR2(20) := 'BAIXO';
BEGIN
    insert_dentist(
        p_name => v_name,
        p_password => v_password,
        p_specialty => v_specialty,
        p_registration_number => v_registration_number,
        p_risk_status => v_risk_status,
        p_dentist_id => v_dentist_id
    );

    DBMS_OUTPUT.PUT_LINE('Dentista inserido com ID: ' || RAWTOHEX(v_dentist_id));

    update_dentist(
        p_id => v_dentist_id,
        p_name => v_name,
        p_password => v_password,
        p_specialty => v_specialty,
        p_registration_number => '123324325', 
        p_risk_status => v_risk_status,
        p_dentist_id => v_dentist_id  
    );

    DBMS_OUTPUT.PUT_LINE('Dentista atualizado com ID: ' || RAWTOHEX(v_dentist_id));

    delete_dentist(
        p_id => v_dentist_id
    );

    DBMS_OUTPUT.PUT_LINE('Dentista com ID ' || RAWTOHEX(v_dentist_id) || ' excluído com sucesso.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao executar as procedures: ' || SQLERRM);
END;
/

-- Consultation
DECLARE
    v_consultation_id RAW(16);
    v_consultation_date DATE := TO_DATE('2024-11-07', 'YYYY-MM-DD');
    v_consultation_value NUMBER := 200;
    v_risk_status VARCHAR2(20) := 'BAIXO';
    v_description VARCHAR2(200) := 'Consulta de rotina';
    v_patient_id RAW(16) := HEXTORAW('2654CCF6150CA708E063103CA8C0E207');
    v_dentist_ids SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('2654CCF61509A708E063103CA8C0E207','2654CCF6150AA708E063103CA8C0E207');
BEGIN
    insert_consultation(
        p_consultation_date => v_consultation_date,
        p_consultation_value => v_consultation_value,
        p_risk_status => v_risk_status,
        p_description => v_description,
        p_patient_id => v_patient_id,
        p_dentist_ids => v_dentist_ids,
        p_consultation_id => v_consultation_id
    );

    DBMS_OUTPUT.PUT_LINE('Consulta inserida com ID: ' || RAWTOHEX(v_consultation_id));

    update_consultation(
        p_id => v_consultation_id,
        p_consultation_date => v_consultation_date,
        p_consultation_value => v_consultation_value,
        p_risk_status => v_risk_status,
        p_description => v_description,
        p_dentist_ids => v_dentist_ids,
        p_consultation_id => v_consultation_id
    );

    DBMS_OUTPUT.PUT_LINE('Consulta atualizada com ID: ' || RAWTOHEX(v_consultation_id));

    delete_consultation(
        p_id => v_consultation_id
    );

    DBMS_OUTPUT.PUT_LINE('Consulta com ID ' || RAWTOHEX(v_consultation_id) || ' excluída com sucesso.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao executar as procedures: ' || SQLERRM);
END;
/

-- Claim
DECLARE
    v_claim_id RAW(16);
    v_occurrence_date DATE := TO_DATE('2024-11-07', 'YYYY-MM-DD');
    v_value NUMBER := 500;
    v_claim_type VARCHAR2(50) := 'Dano material';
    v_suggested_preventive_action CLOB := 'Revisar procedimento';
    v_consultation_id RAW(16) := HEXTORAW('8F63C73C33634CB7A2DD0F0727E41497');
BEGIN
    insert_claim(
        p_occurrence_date => v_occurrence_date,
        p_value => v_value,
        p_claim_type => v_claim_type,
        p_suggested_preventive_action => v_suggested_preventive_action,
        p_consultation_id => v_consultation_id,
        p_claim_id => v_claim_id
    );

    DBMS_OUTPUT.PUT_LINE('Sinistro inserido com ID: ' || RAWTOHEX(v_claim_id));

    update_claim(
        p_id => v_claim_id,
        p_occurrence_date => v_occurrence_date,
        p_value => v_value,
        p_claim_type => v_claim_type,
        p_suggested_preventive_action => v_suggested_preventive_action,
        p_consultation_id => v_consultation_id,
        p_claim_id => v_claim_id
    );

    DBMS_OUTPUT.PUT_LINE('Sinistro atualizado com ID: ' || RAWTOHEX(v_claim_id));

    delete_claim(
        p_id => v_claim_id
    );

    DBMS_OUTPUT.PUT_LINE('Sinistro com ID ' || RAWTOHEX(v_claim_id) || ' excluído com sucesso.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao executar as procedures: ' || SQLERRM);
END;
/

-- Função com Cursor e Joins para Relatório Formatado
DECLARE
    v_cursor SYS_REFCURSOR;
    v_consultation_id RAW(16);
    v_consultation_date VARCHAR2(10);
    v_patient_name VARCHAR2(100);
    v_patient_gender VARCHAR2(1);
    v_consultation_value NUMBER;
    v_consultation_risk_status VARCHAR2(10);
    v_dentist_name VARCHAR2(100);
    v_dentist_registration_number VARCHAR2(50);
BEGIN
    v_cursor := report_consultations;

    LOOP
        FETCH v_cursor INTO v_consultation_id, v_consultation_date, v_patient_name, v_patient_gender, 
                           v_consultation_value, v_consultation_risk_status, v_dentist_name, v_dentist_registration_number;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID da consulta: ' || RAWTOHEX(v_consultation_id));
        DBMS_OUTPUT.PUT_LINE('Data da consulta: ' || v_consultation_date);
        DBMS_OUTPUT.PUT_LINE('Nome do paciente: ' || v_patient_name);
        DBMS_OUTPUT.PUT_LINE('Genero: ' || v_patient_gender);
        DBMS_OUTPUT.PUT_LINE('Valor da consulta: ' || v_consultation_value);
        DBMS_OUTPUT.PUT_LINE('Risk Status: ' || v_consultation_risk_status);
        DBMS_OUTPUT.PUT_LINE('Nome do dentista: ' || v_dentist_name);
        DBMS_OUTPUT.PUT_LINE('Numero de registro: ' || v_dentist_registration_number);
        DBMS_OUTPUT.PUT_LINE('----------------------------------');
    END LOOP;

    CLOSE v_cursor;
END;
/

-- Função regra de negocio
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


