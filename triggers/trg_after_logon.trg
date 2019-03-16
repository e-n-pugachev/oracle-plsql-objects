create or replace trigger trg_after_logon after logon on database
when (user not in ('SYS', 'SYSTEM', 'DBSNMP', 'SYSMAN', 'XDB'))
declare
  v_user_name     varchar2(50);
  v_target_schema varchar2(50);
	v_user_id       number(10);
begin
  v_user_name     := SYS_CONTEXT('USERENV', 'SESSION_USER');
  v_target_schema := pack_user_utl.get_target_schema(v_user_name);
	v_user_id       := pack_user_utl.get_user_id(v_user_name);
  if v_target_schema is not null then
    execute immediate 'alter session set current_schema = '||v_target_schema;
  end if;
	if v_user_id is not null then
		pack_user_utl.trail_user( i_user_name => v_user_name
		                        , i_action    => 'LOGON'
														, i_details   => 'user logon, os login '||SYS_CONTEXT('USERENV', 'OS_USER')||', id address '||SYS_CONTEXT('USERENV', 'IP_ADDRESS'));
		commit;
	end if;
end;
/
