CREATE OR REPLACE PACKAGE audit_pkg AS
    PROCEDURE log_insert(p_table_name VARCHAR2, p_record_id RAW, p_new_values CLOB);
    PROCEDURE log_update(p_table_name VARCHAR2, p_record_id RAW, p_old_values CLOB, p_new_values CLOB);
    PROCEDURE log_delete(p_table_name VARCHAR2, p_record_id RAW, p_old_values CLOB);
END audit_pkg;
/

CREATE OR REPLACE PACKAGE BODY audit_pkg AS
    PROCEDURE log_insert(p_table_name VARCHAR2, p_record_id RAW, p_new_values CLOB) IS
    BEGIN
        INSERT INTO audit_log (table_name, operation_type, record_id, new_values)
        VALUES (p_table_name, 'INSERT', p_record_id, p_new_values);
    END log_insert;

    PROCEDURE log_update(p_table_name VARCHAR2, p_record_id RAW, p_old_values CLOB, p_new_values CLOB) IS
    BEGIN
        INSERT INTO audit_log (table_name, operation_type, record_id, old_values, new_values)
        VALUES (p_table_name, 'UPDATE', p_record_id, p_old_values, p_new_values);
    END log_update;

    PROCEDURE log_delete(p_table_name VARCHAR2, p_record_id RAW, p_old_values CLOB) IS
    BEGIN
        INSERT INTO audit_log (table_name, operation_type, record_id, old_values)
        VALUES (p_table_name, 'DELETE', p_record_id, p_old_values);
    END log_delete;
END audit_pkg;
/

CREATE OR REPLACE TRIGGER trg_audit_tb_patient
AFTER INSERT OR UPDATE OR DELETE ON tb_patient
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        audit_pkg.log_insert('tb_patient', :NEW.id, 'name=' || :NEW.name || ', birthday=' || TO_CHAR(:NEW.birthday, 'YYYY-MM-DD') || ', gender=' || :NEW.gender || ', risk_status=' || :NEW.risk_status);

    ELSIF UPDATING THEN
        audit_pkg.log_update('tb_patient', :NEW.id,
                             'name=' || :OLD.name || ', birthday=' || TO_CHAR(:OLD.birthday, 'YYYY-MM-DD') || ', gender=' || :OLD.gender || ', risk_status=' || :OLD.risk_status,
                             'name=' || :NEW.name || ', birthday=' || TO_CHAR(:NEW.birthday, 'YYYY-MM-DD') || ', gender=' || :NEW.gender || ', risk_status=' || :NEW.risk_status);

    ELSIF DELETING THEN
        audit_pkg.log_delete('tb_patient', :OLD.id, 'name=' || :OLD.name || ', birthday=' || TO_CHAR(:OLD.birthday, 'YYYY-MM-DD') || ', gender=' || :OLD.gender || ', risk_status=' || :OLD.risk_status);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_audit_tb_dentist
AFTER INSERT OR UPDATE OR DELETE ON tb_dentist
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        audit_pkg.log_insert('tb_dentist', :NEW.id, 'name=' || :NEW.name || ', specialty=' || :NEW.specialty || ', risk_status=' || :NEW.risk_status);

    ELSIF UPDATING THEN
        audit_pkg.log_update('tb_dentist', :NEW.id,
                             'name=' || :OLD.name || ', specialty=' || :OLD.specialty || ', risk_status=' || :OLD.risk_status,
                             'name=' || :NEW.name || ', specialty=' || :NEW.specialty || ', risk_status=' || :NEW.risk_status);

    ELSIF DELETING THEN
        audit_pkg.log_delete('tb_dentist', :OLD.id, 'name=' || :OLD.name || ', specialty=' || :OLD.specialty || ', risk_status=' || :OLD.risk_status);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_audit_tb_consultation
AFTER INSERT OR UPDATE OR DELETE ON tb_consultation
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        audit_pkg.log_insert('tb_consultation', :NEW.id, 'date=' || TO_CHAR(:NEW.consultation_date, 'YYYY-MM-DD') || ', value=' || :NEW.consultation_value || ', risk_status=' || :NEW.risk_status);

    ELSIF UPDATING THEN
        audit_pkg.log_update('tb_consultation', :NEW.id,
                             'date=' || TO_CHAR(:OLD.consultation_date, 'YYYY-MM-DD') || ', value=' || :OLD.consultation_value || ', risk_status=' || :OLD.risk_status,
                             'date=' || TO_CHAR(:NEW.consultation_date, 'YYYY-MM-DD') || ', value=' || :NEW.consultation_value || ', risk_status=' || :NEW.risk_status);

    ELSIF DELETING THEN
        audit_pkg.log_delete('tb_consultation', :OLD.id, 'date=' || TO_CHAR(:OLD.consultation_date, 'YYYY-MM-DD') || ', value=' || :OLD.consultation_value || ', risk_status=' || :OLD.risk_status);
    END IF;
END;
/
