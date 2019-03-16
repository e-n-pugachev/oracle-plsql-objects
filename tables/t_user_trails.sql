-- Create table
create table T_USER_TRAILS
(
  id          NUMBER(10) default "DUMMY"."S_T_USER_TRAILS_ID"."NEXTVAL" not null,
  user_id     NUMBER(10),
  action      VARCHAR2(100) not null,
  details     CLOB,
  create_time TIMESTAMP(6) default systimestamp,
  sessionid   NUMBER(20) default SYS_CONTEXT('USERENV', 'SESSIONID')
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
-- Add comments to the table 
comment on table T_USER_TRAILS
  is 'Логи пользователей';
-- Add comments to the columns 
comment on column T_USER_TRAILS.id
  is 'Идентификатор строки';
comment on column T_USER_TRAILS.user_id
  is 'Идентификатор пользователя системы';
comment on column T_USER_TRAILS.action
  is 'Действие пользователя';
comment on column T_USER_TRAILS.details
  is 'Подробности выполняемого действия';
comment on column T_USER_TRAILS.create_time
  is 'Дата и время выполнения действия';
comment on column T_USER_TRAILS.sessionid
  is 'Идентификатор сессии';
-- Create/Recreate primary, unique and foreign key constraints 
alter table T_USER_TRAILS
  add constraint T_USER_TRAILS_RK primary key (ID)
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
alter table T_USER_TRAILS
  add constraint T_USER_TRAILS_FR foreign key (USER_ID)
  references T_USERS (ID);
-- Create/Recreate check constraints 
alter table T_USER_TRAILS
  add constraint T_USER_TRAILS_C1
  check (action = upper(trim(action)));
