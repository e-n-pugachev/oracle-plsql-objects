create or replace package pack_system_log is

  -- Author  : 
  -- Created : 27.06.2017 13:39:26
  -- Purpose :

  function LOG_LEVEL_INFO     return number; -- 0
  function LOG_LEVEL_WARNING  return number; -- 1
  function LOG_LEVEL_ERROR    return number; -- 2
  function LOG_LEVEL_CRITICAL return number; -- 3

  -- инициализация идентификатора процесса
  procedure new_batch;
  --------------------------------------------------------------------------------------------

  -- сброс идентификатора процесса
  procedure reset_batch;
  --------------------------------------------------------------------------------------------

  procedure log_info(i_package_name in varchar2
                   , i_proc_name    in varchar2
                   , i_line_num     in number
                   , i_msg_text     in varchar2
                   , i_in_params    in type_string_list := null
                   , i_in_values    in type_string_list := null
                   , i_out_params   in type_string_list := null
                   , i_out_values   in type_string_list := null);
  --------------------------------------------------------------------------------------------

  procedure log_warn(i_package_name in varchar2
                   , i_proc_name    in varchar2
                   , i_line_num     in number
                   , i_msg_text     in varchar2
                   , i_in_params    in type_string_list := null
                   , i_in_values    in type_string_list := null
                   , i_out_params   in type_string_list := null
                   , i_out_values   in type_string_list := null);
  --------------------------------------------------------------------------------------------

  procedure log_error(i_package_name    in varchar2
                    , i_proc_name       in varchar2
                    , i_line_num        in number
                    , i_msg_text        in varchar2
                    , i_call_stack      in varchar2
                    , i_error_stack     in varchar2
                    , i_error_backtrace in varchar2
                    , i_in_params       in type_string_list := null
                    , i_in_values       in type_string_list := null
                    , i_out_params      in type_string_list := null
                    , i_out_values      in type_string_list := null);
  --------------------------------------------------------------------------------------------

  procedure log_critical(i_package_name    in varchar2
                       , i_proc_name       in varchar2
                       , i_line_num        in number
                       , i_msg_text        in varchar2
                       , i_call_stack      in varchar2
                       , i_error_stack     in varchar2
                       , i_error_backtrace in varchar2
                       , i_in_params       in type_string_list := null
                       , i_in_values       in type_string_list := null
                       , i_out_params      in type_string_list := null
                       , i_out_values      in type_string_list := null);
  --------------------------------------------------------------------------------------------

end pack_system_log;
/
create or replace package body pack_system_log is

  g_batch_id number(20);

  function LOG_LEVEL_INFO     return number is begin return 0; end;
  function LOG_LEVEL_WARNING  return number is begin return 1; end;
  function LOG_LEVEL_ERROR    return number is begin return 2; end;
  function LOG_LEVEL_CRITICAL return number is begin return 3; end;
  --------------------------------------------------------------------------------------------

  procedure new_batch
  is
  begin
    g_batch_id := s_t_system_log_batch.nextval();
  end new_batch;
  --------------------------------------------------------------------------------------------

  procedure reset_batch
  is
  begin
    g_batch_id := null;
  end reset_batch;
  --------------------------------------------------------------------------------------------

  function concat_params(i_params in type_string_list
                       , i_values in type_string_list) return varchar2
  is
    v_result varchar2(32000);
  begin
    if (i_params is null or i_params.count() = 0) or
       (i_values is null or i_values.count() = 0) then
      return null;
    elsif (i_params.count() <> i_values.count()) then
      return 'invalid arguments';
    end if;

    for i in 1..i_params.count()
    loop
      v_result := v_result || '['||i_params(i)||'='||i_values(i)||']';
    end loop;

    return substr(v_result, 1, 4000);
  end concat_params;
  --------------------------------------------------------------------------------------------

  procedure write_log (i_package_name    in varchar2
                     , i_proc_name       in varchar2
                     , i_line_num        in number
                     , i_msg_level       in number
                     , i_msg_text        in varchar2
                     , i_call_stack      in varchar2 := null
                     , i_error_stack     in varchar2 := null
                     , i_error_backtrace in varchar2 := null
                     , i_in_params       in type_string_list := null
                     , i_in_values       in type_string_list := null
                     , i_out_params      in type_string_list := null
                     , i_out_values      in type_string_list := null)
  is pragma autonomous_transaction;
    v_log_row t_system_logs%rowtype;
  begin

    v_log_row.id              := s_t_system_log_id.nextval;
    v_log_row.log_time        := systimestamp;
    v_log_row.batch_id        := g_batch_id;
    v_log_row.package_name    := upper(i_package_name);
    v_log_row.proc_name       := upper(i_proc_name);
    v_log_row.line_num        := i_line_num;
    v_log_row.in_params       := concat_params(i_in_params, i_in_values);
    v_log_row.out_params      := concat_params(i_out_params, i_out_values);
    v_log_row.msg_level       := i_msg_level;
    v_log_row.msg_text        := i_msg_text;
    v_log_row.call_stack      := i_call_stack;
    v_log_row.error_stack     := i_error_stack;
    v_log_row.error_backtrace := i_error_backtrace;
    v_log_row.db_user         := sys_context('USERENV', 'CURRENT_USER');
    v_log_row.os_user         := sys_context('USERENV', 'OS_USER');

    insert into t_system_logs values v_log_row;
    commit;
  end write_log;
  --------------------------------------------------------------------------------------------

  procedure log_info(i_package_name in varchar2
                   , i_proc_name    in varchar2
                   , i_line_num     in number
                   , i_msg_text     in varchar2
                   , i_in_params    in type_string_list := null
                   , i_in_values    in type_string_list := null
                   , i_out_params   in type_string_list := null
                   , i_out_values   in type_string_list := null)
  is
  begin
    write_log(i_package_name => i_package_name
            , i_proc_name    => i_proc_name
            , i_line_num     => i_line_num
            , i_in_params    => i_in_params
            , i_in_values    => i_in_values
            , i_out_params   => i_out_params
            , i_out_values   => i_out_values
            , i_msg_level    => LOG_LEVEL_INFO
            , i_msg_text     => i_msg_text);
  end log_info;
  --------------------------------------------------------------------------------------------

  procedure log_warn(i_package_name in varchar2
                   , i_proc_name    in varchar2
                   , i_line_num     in number
                   , i_msg_text     in varchar2
                   , i_in_params    in type_string_list := null
                   , i_in_values    in type_string_list := null
                   , i_out_params   in type_string_list := null
                   , i_out_values   in type_string_list := null)
  is
  begin
    write_log(i_package_name => i_package_name
            , i_proc_name    => i_proc_name
            , i_line_num     => i_line_num
            , i_in_params    => i_in_params
            , i_in_values    => i_in_values
            , i_out_params   => i_out_params
            , i_out_values   => i_out_values
            , i_msg_level    => LOG_LEVEL_WARNING
            , i_msg_text     => i_msg_text);
  end log_warn;
  --------------------------------------------------------------------------------------------

  procedure log_error(i_package_name    in varchar2
                    , i_proc_name       in varchar2
                    , i_line_num        in number
                    , i_msg_text        in varchar2
                    , i_call_stack      in varchar2
                    , i_error_stack     in varchar2
                    , i_error_backtrace in varchar2
                    , i_in_params       in type_string_list := null
                    , i_in_values       in type_string_list := null
                    , i_out_params      in type_string_list := null
                    , i_out_values      in type_string_list := null)
  is
  begin
    write_log(i_package_name    => i_package_name
            , i_proc_name       => i_proc_name
            , i_line_num        => i_line_num
            , i_in_params       => i_in_params
            , i_in_values       => i_in_values
            , i_out_params      => i_out_params
            , i_out_values      => i_out_values
            , i_msg_level       => LOG_LEVEL_ERROR
            , i_msg_text        => i_msg_text
            , i_call_stack      => i_call_stack
            , i_error_stack     => i_error_stack
            , i_error_backtrace => i_error_backtrace);
  end log_error;
  --------------------------------------------------------------------------------------------

  procedure log_critical(i_package_name    in varchar2
                       , i_proc_name       in varchar2
                       , i_line_num        in number
                       , i_msg_text        in varchar2
                       , i_call_stack      in varchar2
                       , i_error_stack     in varchar2
                       , i_error_backtrace in varchar2
                       , i_in_params       in type_string_list := null
                       , i_in_values       in type_string_list := null
                       , i_out_params      in type_string_list := null
                       , i_out_values      in type_string_list := null)
  is
  begin
    write_log(i_package_name    => i_package_name
            , i_proc_name       => i_proc_name
            , i_line_num        => i_line_num
            , i_in_params       => i_in_params
            , i_in_values       => i_in_values
            , i_out_params      => i_out_params
            , i_out_values      => i_out_values
            , i_msg_level       => LOG_LEVEL_CRITICAL
            , i_msg_text        => i_msg_text
            , i_call_stack      => i_call_stack
            , i_error_stack     => i_error_stack
            , i_error_backtrace => i_error_backtrace);
  end log_critical;
  --------------------------------------------------------------------------------------------

end pack_system_log;
/
