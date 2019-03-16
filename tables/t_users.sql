-- Create table
create table T_USERS
(
  id            NUMBER(10) default "DUMMY"."S_T_USERS_ID"."NEXTVAL" not null,
  user_name     VARCHAR2(50) not null,
  target_schema VARCHAR2(50) not null,
  create_time   TIMESTAMP(6) default systimestamp not null,
  password      VARCHAR2(200),
  status        VARCHAR2(1) not null
)
tablespace DUMMY_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column T_USERS.id
  is 'Идентификатор строки';
comment on column T_USERS.user_name
  is 'Пользователь системы';
comment on column T_USERS.target_schema
  is 'Схема, на которую будет переадресован пользователь';
comment on column T_USERS.create_time
  is 'Дата и время создания пользователя';
comment on column T_USERS.status
  is 'Статус пользователя (''E'' - enable, ''D'' - disable)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table T_USERS
  add constraint T_USERS_PK primary key (ID)
  using index 
  tablespace DUMMY_DATA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table T_USERS
  add constraint T_USERS_UK1 unique (USER_NAME)
  using index 
  tablespace DUMMY_DATA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate check constraints 
alter table T_USERS
  add constraint T_USERS_C1
  check (user_name = upper(user_name));
alter table T_USERS
  add constraint T_USERS_C2
  check (target_schema = upper(target_schema));
alter table T_USERS
  add constraint T_USERS_C3
  check (status in ('E','D'));
