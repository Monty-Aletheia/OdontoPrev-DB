CREATE OR REPLACE PACKAGE dental_clinic_pkg AS
    PROCEDURE generate_patient_report;
    PROCEDURE generate_dentist_claim_report;
END dental_clinic_pkg;
/

CREATE OR REPLACE PACKAGE BODY dental_clinic_pkg AS
    PROCEDURE generate_patient_report IS
        CURSOR patient_cursor IS
            SELECT p.name AS patient_name,
                   p.birthday,
                   c.consultation_date,
                   c.description,
                   d.name AS dentist_name
            FROM tb_patient p
            INNER JOIN tb_consultation c ON p.id = c.patient_id
            LEFT JOIN consultation_dentist cd ON c.id = cd.consultation_id
            LEFT JOIN tb_dentist d ON cd.dentist_id = d.id
            ORDER BY p.name, c.consultation_date DESC;
        
        v_patient_row patient_cursor%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Paciente | Data Consulta | Descrição | Dentista');
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------');

        OPEN patient_cursor;
        LOOP
            FETCH patient_cursor INTO v_patient_row;
            EXIT WHEN patient_cursor%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE(
                v_patient_row.patient_name || ' | ' ||
                TO_CHAR(v_patient_row.consultation_date, 'DD/MM/YYYY') || ' | ' ||
                v_patient_row.description || ' | ' ||
                NVL(v_patient_row.dentist_name, 'Sem dentista')
            );
        END LOOP;
        CLOSE patient_cursor;
    END generate_patient_report;

    PROCEDURE generate_dentist_claim_report IS
        CURSOR dentist_cursor IS
            SELECT d.name AS dentist_name,
                   COUNT(cl.id) AS total_claims,
                   ROUND(AVG(cl.value), 2) AS avg_claim_value
            FROM tb_dentist d
            INNER JOIN consultation_dentist cd ON d.id = cd.dentist_id
            INNER JOIN tb_consultation c ON cd.consultation_id = c.id
            RIGHT JOIN tb_claim cl ON c.id = cl.consultation_id
            GROUP BY d.name
            ORDER BY total_claims DESC;
        
        v_dentist_row dentist_cursor%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Dentista | Total Sinistros | Média Valor (R$)');
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');

        OPEN dentist_cursor;
        LOOP
            FETCH dentist_cursor INTO v_dentist_row;
            EXIT WHEN dentist_cursor%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE(
                v_dentist_row.dentist_name || ' | ' ||
                v_dentist_row.total_claims || ' | R$ ' ||
                v_dentist_row.avg_claim_value
            );
        END LOOP;
        CLOSE dentist_cursor;
    END generate_dentist_claim_report;

END dental_clinic_pkg;
/
