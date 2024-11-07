
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


