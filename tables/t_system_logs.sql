-- Create table
create table T_SYSTEM_LOGS
(
  id              NUMBER(20) not null,
  log_time        TIMESTAMP(6) not null,
  batch_id        NUMBER(20),
  package_name    VARCHAR2(30),
  proc_name       VARCHAR2(30),
  line_num        NUMBER,
  in_params       VARCHAR2(4000),
  out_params      VARCHAR2(4000),
  msg_level       NUMBER(1) default 0 not null,
  msg_text        VARCHAR2(2000),
  call_stack      VARCHAR2(2000),
  error_stack     VARCHAR2(2000),
  error_backtrace VARCHAR2(2000),
  db_user         VARCHAR2(50),
  os_user         VARCHAR2(50)
)
tablespace DUMMY_DATA
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the columns 
comment on column T_SYSTEM_LOGS.id
  is 'Уникальный идентификатор';
comment on column T_SYSTEM_LOGS.log_time
  is 'Дата и время логирования';
comment on column T_SYSTEM_LOGS.batch_id
  is 'Идентификатор процесса';
comment on column T_SYSTEM_LOGS.package_name
  is 'Пакет, иницииировавший запись в лог';
comment on column T_SYSTEM_LOGS.proc_name
  is 'Процедура, иницииировавшая запись в лог';
comment on column T_SYSTEM_LOGS.line_num
  is 'Номер строки в коде';
comment on column T_SYSTEM_LOGS.in_params
  is 'Набор входящих параметров';
comment on column T_SYSTEM_LOGS.out_params
  is 'Набор исходящих параметров';
comment on column T_SYSTEM_LOGS.msg_level
  is 'Уровень критичности: 0 - информационное, 1 - предупреждение, 2 - ошибка, 3 - критичная ошибка';
comment on column T_SYSTEM_LOGS.msg_text
  is 'Текст сообщения';
comment on column T_SYSTEM_LOGS.call_stack
  is 'Стек исключения (dbms_utility.format_call_stack)';
comment on column T_SYSTEM_LOGS.error_stack
  is 'Стек исключения (dbms_utility.format_error_stack)';
comment on column T_SYSTEM_LOGS.error_backtrace
  is 'Бактрейс исключения (dbms_utility.format_error_backtrace)';
comment on column T_SYSTEM_LOGS.db_user
  is 'sys_context(''USERENV'', ''db_user'')';
comment on column T_SYSTEM_LOGS.os_user
  is 'sys_context(''USERENV'', ''OS_USER'')';
-- Create/Recreate indexes 
create unique index T_SYSTEM_LOGS_UI01 on T_SYSTEM_LOGS (ID, LOG_TIME)
  tablespace DUMMY_DATA
  pctfree 10
  initrans 2
  maxtrans 255;
-- Create/Recreate primary, unique and foreign key constraints 
alter table T_SYSTEM_LOGS
  add constraint T_SYSTEM_LOGS_PK primary key (ID, LOG_TIME);
-- Create/Recreate check constraints 
alter table T_SYSTEM_LOGS
  add constraint T_SYSTEM_LOGS_C1
  check (MSG_LEVEL between 0 and 3);
