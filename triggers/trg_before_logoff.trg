create or replace trigger trg_before_logoff before logoff on database
when (user not in ('SYS', 'SYSTEM', 'DBSNMP', 'SYSMAN', 'XDB'))
declare
  v_user_name     varchar2(50);
	v_user_id       number(10);
begin
  v_user_name     := SYS_CONTEXT('USERENV', 'SESSION_USER');
	v_user_id       := pack_user_utl.get_user_id(v_user_name);

	if v_user_id is not null then
		pack_user_utl.trail_user( i_user_name => v_user_name
		                        , i_action    => 'LOGOFF'
														, i_details   => 'user logoff, os login '||SYS_CONTEXT('USERENV', 'OS_USER')||', id address '||SYS_CONTEXT('USERENV', 'IP_ADDRESS'));
	end if;
end;
/
