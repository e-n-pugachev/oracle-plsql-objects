-- Create table
create table T_PARAMS
(
  id         NUMBER(10) default "DUMMY"."S_T_PARAMS_ID"."NEXTVAL" not null,
  section    VARCHAR2(50) not null,
  item       VARCHAR2(50) not null,
  value      VARCHAR2(250),
  value_type VARCHAR2(1) not null,
  contur     VARCHAR2(1) not null
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
comment on table T_PARAMS
  is 'Параметры системы';
-- Add comments to the columns 
comment on column T_PARAMS.id
  is 'Уникальный идентификатор параметра';
comment on column T_PARAMS.section
  is 'Наименование раздела';
comment on column T_PARAMS.item
  is 'Наименование параметра';
comment on column T_PARAMS.value
  is 'Значение параметра';
comment on column T_PARAMS.value_type
  is 'Тип параметра: C - строковый, N - числовой, B - логический, D - дата/время';
comment on column T_PARAMS.contur
  is 'Контур: T - тестовый, P - продуктовый, D - разработки';
-- Create/Recreate primary, unique and foreign key constraints 
alter table T_PARAMS
  add constraint T_PARAMS_PK primary key (ID)
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
alter table T_PARAMS
  add constraint T_PARAMS_UK1 unique (SECTION, ITEM, CONTUR)
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
alter table T_PARAMS
  add constraint T_PARAMS_C1
  check (section = upper(trim(section)));
alter table T_PARAMS
  add constraint T_PARAMS_C2
  check (item = upper(trim(item)));
alter table T_PARAMS
  add constraint T_PARAMS_C3
  check (value_type in ('C','N','D','T','B'));
alter table T_PARAMS
  add constraint T_PARAMS_C4
  check (contur in ('T','P','D'));
