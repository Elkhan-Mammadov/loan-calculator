
--  Calling inside an anonymous PL/SQL block
BEGIN
    loan_calculator(10000, 12, 15);
END;
/

-- Calling with EXECUTE command
EXECUTE loan_calculator(10000, 12, 15);

--Calling with the short EXEC command
EXEC loan_calculator(10000, 12, 15);
