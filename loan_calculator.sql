CREATE OR REPLACE PROCEDURE loan_calculator (
    p_loan_amount       NUMBER,
    p_loan_term_months  NUMBER,
    p_annual_interest_rate NUMBER
) IS
    v_remaining_principal    NUMBER := p_loan_amount;
    v_monthly_interest_rate  NUMBER := (p_annual_interest_rate / 12) / 100;
    v_monthly_payment        NUMBER;
    v_interest_payment       NUMBER;
    v_principal_payment      NUMBER;
    v_total_payment          NUMBER := 0;
    v_total_interest         NUMBER := 0;
    v_total_principal        NUMBER := 0;
    f                        UTL_FILE.FILE_TYPE;
BEGIN
    v_monthly_payment := (p_loan_amount * v_monthly_interest_rate * POWER(1 + v_monthly_interest_rate, p_loan_term_months)) /
                         (POWER(1 + v_monthly_interest_rate, p_loan_term_months) - 1);

    f := UTL_FILE.FOPEN('CREDIT_DIR', 'loan_schedule.csv', 'W', 32767);

    UTL_FILE.PUT_LINE(f, 'NO,MONTHLY_PAYMENT,PRINCIPAL_PAYMENT,INTEREST_PAYMENT,REMAINING_BALANCE');

    FOR i IN 1..p_loan_term_months LOOP
        v_interest_payment := v_remaining_principal * v_monthly_interest_rate;
        v_principal_payment := v_monthly_payment - v_interest_payment;
        v_remaining_principal := v_remaining_principal - v_principal_payment;

        v_total_payment := v_total_payment + v_monthly_payment;
        v_total_interest := v_total_interest + v_interest_payment;
        v_total_principal := v_total_principal + v_principal_payment;

        UTL_FILE.PUT_LINE(f,
            i || ',' ||
            ROUND(v_monthly_payment, 2) || ',' ||
            ROUND(v_principal_payment, 2) || ',' ||
            ROUND(v_interest_payment, 2) || ',' ||
            ROUND(GREATEST(v_remaining_principal, 0), 2)
        );
    END LOOP;

    UTL_FILE.PUT_LINE(f,
        'TOTAL,' ||
        ROUND(v_total_payment, 2) || ',' ||
        ROUND(v_total_principal, 2) || ',' ||
        ROUND(v_total_interest, 2) || ',' ||
        '0'
    );

    UTL_FILE.FCLOSE(f);
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(f) THEN
            UTL_FILE.FCLOSE(f);
        END IF;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RAISE;
END;
/
