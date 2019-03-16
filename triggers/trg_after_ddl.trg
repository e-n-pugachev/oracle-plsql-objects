create or replace trigger trg_after_ddl after ddl on database
when (user not in ('SYS', 'SYSTEM', 'DBSNMP', 'SYSMAN', 'XDB'))
declare
  v_user_name     varchar2(50);
	v_user_id       number(10);
	v_text          ora_name_list_t;
  v_num           number;
	v_body          clob;	
begin
  v_user_name     := SYS_CONTEXT('USERENV', 'SESSION_USER');
	v_user_id       := pack_user_utl.get_user_id(v_user_name);

	if v_user_id is not null then
		v_num := ora_sql_txt(v_text);
		for i in 1 .. v_num 
			loop
		   v_body := v_body ||chr(13)||v_text(i);
			end loop;			 
		pack_user_utl.trail_user( i_user_name => v_user_name
		                        , i_action    => 'DDL'
														, i_details   => v_body);												
	end if;
end;
/
