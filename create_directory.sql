-- Create the directory object (only SYS or users with DBA privileges can do this)
CREATE OR REPLACE DIRECTORY CREDIT_DIR AS 'C:\oracle\loan_output';

-- Grant read and write privileges on the directory to the desired user
GRANT READ, WRITE ON DIRECTORY CREDIT_DIR TO your_username;
