create or replace package pack_user_utl is

  -- Author  : 
  -- Created : 10.12.2017 04:22:00
  -- Purpose :

  procedure add_user( i_user_name     in varchar2
                    , i_target_schema in varchar2
									  , i_user_password in varchar2);
  --------------------------------------------------------------------------------------------

  function get_target_schema(i_user_name in varchar2) return varchar2 result_cache;
  --------------------------------------------------------------------------------------------
	
	function get_user_id(i_user_name in varchar2) return varchar2 result_cache;
  --------------------------------------------------------------------------------------------
	
  procedure enable_user(i_user_name in varchar2);
  --------------------------------------------------------------------------------------------

  procedure disable_user(i_user_name in varchar2);
  --------------------------------------------------------------------------------------------

  procedure delete_user(i_user_name in varchar2);
  --------------------------------------------------------------------------------------------
	
	procedure create_user( i_user_name     in varchar2
			                 , i_user_password in varchar2);
	--------------------------------------------------------------------------------------------
	
	procedure trail_user( i_user_name     in varchar2
			                , i_action        in varchar2
											, i_details       in clob);											
  -------------------------------------------------------------------------------------------
end pack_user_utl;
/
create or replace package body pack_user_utl is

  function get_user_id(i_user_name in varchar2) return varchar2 result_cache
  is
    v_user_name varchar2(50) := upper(trim(i_user_name));
    v_result    varchar2(50);
  begin
    if v_user_name is null then
      pack_utl.raise_error('Не указано имя пользователя');
    end if;

    select t.id
      into v_result
      from t_users t
     where t.user_name = v_user_name;

    return v_result;
  exception
    when no_data_found then
      return null;
  end get_user_id;
  --------------------------------------------------------------------------------------------
  procedure add_user(i_user_name     in varchar2
                   , i_target_schema in varchar2
									 , i_user_password in varchar2)
  is
    v_user_name     varchar2(50) := upper(trim(i_user_name));
		v_user_password varchar2(50) := trim(i_user_password);
    v_target_schema varchar2(50) := upper(trim(i_target_schema));
  begin
    if v_user_name is null then
      pack_utl.raise_error('Не указано имя пользователя');
    end if;

    if v_target_schema is null then
      pack_utl.raise_error('Не указана рабочая схема пользователя');
    end if;

    insert into t_users
      (user_name, target_schema, password, status)
    values
      (v_user_name, v_target_schema, v_user_password, 'E');
  exception
    when dup_val_on_index then
      pack_utl.raise_error('Пользователь '||v_user_name||' уже существует');
  end add_user;
  --------------------------------------------------------------------------------------------

  function get_target_schema(i_user_name in varchar2) return varchar2 result_cache
  is
    v_user_name varchar2(50) := upper(trim(i_user_name));
    v_result    varchar2(50);
  begin
    if v_user_name is null then
      pack_utl.raise_error('Не указано имя пользователя');
    end if;

    select t.target_schema
      into v_result
      from t_users t
     where t.user_name = v_user_name;

    return v_result;
  exception
    when no_data_found then
      return null;
  end get_target_schema;
  --------------------------------------------------------------------------------------------

  procedure enable_user(i_user_name in varchar2)
  is
    v_user_name varchar2(50) := upper(trim(i_user_name));
  begin
    if v_user_name is null then
      pack_utl.raise_error('Не указано имя пользователя');
    end if;

    update t_users t
       set t.status = 'E'
     where t.user_name = v_user_name;

    if sql%rowcount = 0 then
      pack_utl.raise_error('Пользователь '||v_user_name||' не найден');
    end if;
  end enable_user;
  --------------------------------------------------------------------------------------------

  procedure disable_user(i_user_name in varchar2)
  is
    v_user_name varchar2(50) := upper(trim(i_user_name));
  begin
    if v_user_name is null then
      pack_utl.raise_error('Не указано имя пользователя');
    end if;

    update t_users t
       set t.status = 'E'
     where t.user_name = v_user_name;

    if sql%rowcount = 0 then
      pack_utl.raise_error('Пользователь '||v_user_name||' не найден');
    end if;
  end disable_user;
  --------------------------------------------------------------------------------------------

  procedure delete_user(i_user_name in varchar2)
  is
    v_user_name varchar2(50) := upper(trim(i_user_name));
  begin
    if v_user_name is null then
      pack_utl.raise_error('Не указано имя пользователя');
    end if;

    delete t_users t
     where t.user_name = v_user_name;

  end delete_user;
  --------------------------------------------------------------------------------------------
	
  procedure create_user( i_user_name     in varchar2
			                 , i_user_password in varchar2)
  is
    v_user_name     varchar2(50) := upper(trim(i_user_name));
		v_user_password varchar2(50) := trim(i_user_password);
  begin
    if v_user_name is null then
      pack_utl.raise_error('Не указано имя пользователя');
    end if;
		
		if v_user_password is null then
      pack_utl.raise_error('Не указан пароль пользователя');
    end if;
				
		execute immediate 'create user '||v_user_name||' identified by '||v_user_password||' '
		||'default tablespace DUMMY_DATA temporary tablespace TEMP profile NO_LIMIT';
		execute immediate 'grant role_dev to '||v_user_name;
		
		pack_user_utl.add_user(v_user_name, v_user_name, v_user_password);
  end create_user;
  --------------------------------------------------------------------------------------------
	procedure trail_user( i_user_name     in varchar2
			                , i_action        in varchar2
											, i_details       in clob)
  is
    v_user_id       number       := pack_user_utl.get_user_id(i_user_name);
		v_action       varchar2(100) := trim(i_action);
  begin
	  if v_user_id is null then
      pack_utl.raise_error('Пользователь не найден');
    end if;
		
		if i_action is null then
      pack_utl.raise_error('Не указано действие пользователя');
    end if;
		
		insert into t_user_trails
		  (user_id, action, details)
		values (v_user_id, v_action, i_details);
  end trail_user;
  --------------------------------------------------------------------------------------------

end pack_user_utl;
/
