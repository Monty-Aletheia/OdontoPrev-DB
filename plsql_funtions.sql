SET SERVEROUTPUT ON;

-- Blocos Anônimos com Consultas

-- consulta InnerJoin
DECLARE
  CURSOR cur_patient_claims IS
    SELECT p.name AS patient_name,
           SUM(cl.value) AS total_claims
    FROM tb_patient p
    INNER JOIN tb_consultation c
    ON p.id = c.patient_id
    INNER JOIN tb_claim cl
    ON c.id = cl.consultation_id
    GROUP BY p.name
    ORDER BY total_claims DESC;
BEGIN
  FOR record IN cur_patient_claims LOOP
    DBMS_OUTPUT.PUT_LINE('Paciente: ' || record.patient_name || ' | Total Sinistros: ' || record.total_claims);
  END LOOP;
END;
/

-- consulta left Join
DECLARE
  CURSOR cur_dentist_consultations IS
    SELECT d.name AS dentist_name,
           COUNT(cd.consultation_id) AS total_consultations
    FROM tb_dentist d
    LEFT JOIN consultation_dentist cd
    ON d.id = cd.dentist_id
    GROUP BY d.name
    ORDER BY total_consultations DESC;
BEGIN
  FOR record IN cur_dentist_consultations LOOP
    DBMS_OUTPUT.PUT_LINE('Dentista: ' || record.dentist_name || ' | Total Consultas: ' || record.total_consultations);
  END LOOP;
END;
/

--  consulta right Join
DECLARE
  CURSOR cur_patient_consultations IS
    SELECT p.name AS patient_name,
           COUNT(c.id) AS total_consultations
    FROM tb_patient p
    RIGHT JOIN tb_consultation c
    ON p.id = c.patient_id
    GROUP BY p.name
    ORDER BY total_consultations DESC;
BEGIN
  FOR record IN cur_patient_consultations LOOP
    DBMS_OUTPUT.PUT_LINE('Paciente: ' || NVL(record.patient_name, 'Sem Nome') || ' | Total Consultas: ' || record.total_consultations);
  END LOOP;
END;
/

-- Estruturas de Decisão e Operações DML em Blocos Anônimos 

-- UPDATE
DECLARE
  v_patient_id RAW(16) := 'SOME_PATIENT_ID'; 
  v_new_risk_status VARCHAR2(50) := 'ALTO RISCO';
  v_patient_exists NUMBER := 0;
BEGIN
  SELECT COUNT(*)
  INTO v_patient_exists
  FROM tb_patient
  WHERE id = v_patient_id;

  IF v_patient_exists > 0 THEN
    UPDATE tb_patient
    SET risk_status = v_new_risk_status,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = v_patient_id;

    DBMS_OUTPUT.PUT_LINE('Status de risco do paciente atualizado para: ' || v_new_risk_status);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Paciente não encontrado.');
  END IF;
END;
/

-- DELETE
DECLARE
  v_claim_id RAW(16) := 'SOME_CLAIM_ID'; 
  v_claim_value_limit NUMBER := 1000;
  v_claim_value NUMBER := 0;
BEGIN
  -- Recupera o valor do sinistro
  SELECT value
  INTO v_claim_value
  FROM tb_claim
  WHERE id = v_claim_id;

  IF v_claim_value > v_claim_value_limit THEN
    DELETE FROM tb_claim
    WHERE id = v_claim_id;

    DBMS_OUTPUT.PUT_LINE('Sinistro com ID ' || v_claim_id || ' deletado com sucesso.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Sinistro com valor abaixo do limite, não será deletado.');
  END IF;
END;
/


