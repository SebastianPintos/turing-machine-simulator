# turing-machine-simulator

## Steps to run the scripts

Access to postgreSQL

`psql -h localhost -U USERNAME`

Create new database

`CREATE DATABASE "turingmachine";`

Connect to the new database

`\c turingmachine`

Execute initialization script

`\i scripts/initdb.sql`

Create the store procedure to generate the turing machine

`\i scripts/turing_machine.sql`

Run any of the 3 programs (example with binary_palindrome.sql)

`\i scripts/binary_palindrome.sql`

Then you can call the function like this

`SELECT simuladorMT('101101');`