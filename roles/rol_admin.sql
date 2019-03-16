-- Create the role 
create role ROL_ADMIN;
-- Grant/Revoke role privileges 
grant rol_dev to ROL_ADMIN;
-- Grant/Revoke system privileges 
grant administer database trigger to ROL_ADMIN;
grant alter user to ROL_ADMIN;
grant dequeue any queue to ROL_ADMIN with admin option;
grant drop any index to ROL_ADMIN;
grant drop any indextype to ROL_ADMIN;
grant drop any procedure to ROL_ADMIN;
grant drop any sequence to ROL_ADMIN;
grant drop any table to ROL_ADMIN;
grant drop any trigger to ROL_ADMIN;
grant drop any type to ROL_ADMIN;
grant drop any view to ROL_ADMIN;
grant enqueue any queue to ROL_ADMIN with admin option;
grant manage any queue to ROL_ADMIN with admin option;
