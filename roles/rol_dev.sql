-- Create the role 
create role ROL_DEV;
-- Grant/Revoke system privileges 
grant create database link to ROL_DEV;
grant create indextype to ROL_DEV;
grant create job to ROL_DEV;
grant create procedure to ROL_DEV;
grant create public synonym to ROL_DEV;
grant create sequence to ROL_DEV;
grant create session to ROL_DEV;
grant create table to ROL_DEV;
grant create trigger to ROL_DEV;
grant create type to ROL_DEV;
grant create view to ROL_DEV;
grant debug connect session to ROL_DEV;
grant select any sequence to ROL_DEV;
