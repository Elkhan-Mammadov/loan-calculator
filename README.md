# Loan Calculator Procedure

This repository contains an Oracle PL/SQL procedure named `loan_calculator`.  
The procedure calculates a loan amortization schedule and writes it to a CSV file.

## Files

- `loan_calculator.sql` — The main loan calculator procedure  
- `call_procedure.sql` — Script to call the procedure with sample parameters  
- `create_directory.sql` — Script to create the Oracle directory object needed for file output  

## Usage

1. Run `create_directory.sql` (requires DBA privileges).  
2. Run `loan_calculator.sql` to create the procedure.  
3. Use `call_procedure.sql` or directly execute the procedure to generate the schedule.  

Example to execute the procedure:
```sql
EXEC loan_calculator(100000, 12, 15);

