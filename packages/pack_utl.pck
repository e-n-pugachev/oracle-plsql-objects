create or replace package pack_utl is

  -- Вспомогательные функции общего назначения

  function FORMAT_NUMBER      return varchar2;
  function FORMAT_NUMBER2     return varchar2;
  function FORMAT_NLS_NUMBER  return varchar2;
  function FORMAT_DATE        return varchar2;
  function FORMAT_DATETIME    return varchar2;
  function FORMAT_TIMESTAMP   return varchar2; 
  function FORMAT_TIMESTAMPTZ return varchar2;


  -- Пользовательский эксепшн
  
  EXPT_USER_ERROR exception;
  pragma exception_init (EXPT_USER_ERROR, -20770);
  --------------------------------------------------------------------------------------------

  EXPT_USER_LOCK_FAIL exception;
  pragma exception_init (EXPT_USER_LOCK_FAIL, -20771);
  --------------------------------------------------------------------------------------------

  -- Конвертация строки в число по формату
  -- %param i_value Число в текстовом виде
  
  function string_to_number(i_value      in varchar2
                          , i_format     in varchar2 := FORMAT_NUMBER2
                          , i_format_nls in varchar2 := FORMAT_NLS_NUMBER) return number;
  --------------------------------------------------------------------------------------------

  -- Конвертация числа в строку по формату
  -- %param i_value Конвертируемое число
  
  function number_to_string(i_value      in number
                          , i_format     in varchar2 := FORMAT_NUMBER
                          , i_format_nls in varchar2 := FORMAT_NLS_NUMBER) return varchar2;
  --------------------------------------------------------------------------------------------

  -- Конвертация строки в дату по формату
  -- %param i_value Дата в текстовом виде
  
  function string_to_date(i_value  in varchar2
                        , i_format in varchar2 := FORMAT_DATE) return date;
  --------------------------------------------------------------------------------------------

  -- Конвертация строки в дату по формату
  -- %param i_value Дата в текстовом виде
  
  function string_to_datetime(i_value  in varchar2
                            , i_format in varchar2 := FORMAT_DATETIME) return date;
  --------------------------------------------------------------------------------------------

  -- Конвертация строки в дату по формату
  -- %param i_value Дата в текстовом виде
  
  function string_to_timestamp(i_value  in varchar2
                             , i_format in varchar2 := FORMAT_TIMESTAMP) return timestamp;
  --------------------------------------------------------------------------------------------

  -- Конвертация строки в дату по формату
  -- %param i_value Дата в текстовом виде
  
  function string_to_timestamp_tz(i_value  in varchar2
                               , i_format in varchar2 := FORMAT_TIMESTAMPTZ) return timestamp with time zone;
  --------------------------------------------------------------------------------------------

  -- Конвертация даты в строку по формату
  -- %param i_value Конвертируемое значение даты
  
  function date_to_string(i_value  in date
                        , i_format in varchar2 := FORMAT_DATE) return varchar2;
  --------------------------------------------------------------------------------------------

  -- Конвертация даты в строку по формату
  -- %param i_value Конвертируемое значение даты
  
  function datetime_to_string(i_value  in date
                            , i_format in varchar2 := FORMAT_DATETIME) return varchar2;
  --------------------------------------------------------------------------------------------
  
  -- Конвертация даты в строку по формату
  -- %param i_value Конвертируемое значение даты
  
  function timestamp_to_string(i_value in timestamp
                             , i_format in varchar2 := FORMAT_TIMESTAMP) return varchar2;
  --------------------------------------------------------------------------------------------

  -- Конвертация даты в строку по формату
  -- %param i_value Конвертируемое значение даты
  
  function timestamp_tz_to_string(i_value in timestamp with time zone
                                , i_format in varchar2 := FORMAT_TIMESTAMPTZ) return varchar2;
  --------------------------------------------------------------------------------------------

  -- Форматирование сообщения об ошибке Oracle. Удаляет из сообщения фрагменты типа ORA-XXXXX:
  -- %param i_err_msg Сообщение об ошибке
  
  function fix_err_msg(i_err_msg in varchar2) return varchar2;
  --------------------------------------------------------------------------------------------

  -- Генерация пользовательского исключения с кодом -20746
  -- %param i_err_msg Сообщение об ошибке
  
  procedure raise_error(i_err_msg in varchar2);
  --------------------------------------------------------------------------------------------

  -- Возвращает имя пользователя ОС
  
  function get_os_username return varchar2;
  --------------------------------------------------------------------------------------------

  -- Возвращает имя пользователя БД
  
  function get_db_username return varchar2;
  --------------------------------------------------------------------------------------------

  -- %usage вычисляет контрольную сумму числовой строки по алгоритму Луна
  -- %param строка из последовательности чисел
  -- %return number
  
  function get_luhn_key(i_num_str in varchar2) return number deterministic;
  --------------------------------------------------------------------------------------------
  
  -- Возвращает к какому контуру относится база. Return: "prod", "tst", "dev"
  
  function get_db return varchar2 deterministic;
  --------------------------------------------------------------------------------------------

  --%usage возвращает разницу в минутах между двумя датами
  --%param i_from_date начальная дата
  --%param i_to_date конечная дата
  --%return number
  
  function get_minutes_diff(i_from_date in date
                          , i_to_date   in date) return pls_integer deterministic;
  --------------------------------------------------------------------------------------------

  --%usage установка "правильных" nls-параметров 
  
  procedure set_american_nls;
  --------------------------------------------------------------------------------------------

  --%usage Пытается установить пользовательскую блокировку. Возвращает статус согласно документации в Oracle
  --       {*} 0 Success
  --       {*} 1 Timeout
  --       {*} 2 Deadlock
  --       {*} 3 Parameter error
  --       {*} 4 Already own lock specified by id or lockhandle
  --       {*} 5 Illegal lock handle
  --%param i_lock_prefix   префикс идентификатора блокировки(напр. название процедуры)
  --%param i_entity_code   идентификатор блокируемой сущности(напр. serno)
  --%param i_time_out      время ожидания
  --%param i_release_on_commit
  --       {*} true  блокировка будет снята автоматически после коммита/роллбэка
  --       {*} false блокировка останется после коммита/роллбэка(для снятия блокировки использовать release_lock)
  --%result number
  
  function request_lock(i_lock_prefix       in varchar2
                      , i_entity_code       in varchar2
                      , i_time_out          in number  := 0
                      , i_release_on_commit in boolean := true) return number;
  --------------------------------------------------------------------------------------------

  --%usage Пытается установить пользовательскую блокировку. Если не получается - генерируется ошибка TCS_UTL.EXPT_USER_LOCK_FAIL (-20750)
  --%param i_lock_prefix   префикс идентификатора блокировки(напр. название процедуры)
  --%param i_entity_code   идентификатор блокируемой сущности(напр. serno)
  --%param i_time_out      время ожидания
  --%param i_release_on_commit
  --       {*} true  блокировка будет снята автоматически после коммита/роллбэка
  --       {*} false блокировка останется после коммита/роллбэка(для снятия блокировки использовать release_lock)
  
  procedure request_lock(i_lock_prefix       in varchar2
                       , i_entity_code       in varchar2
                       , i_time_out          in number  := 0
                       , i_release_on_commit in boolean := true);
  --------------------------------------------------------------------------------------------

  --%usage Освобождает ранее установленную пользовательскую блокировку. Возвращает статус согласно документации в Oracle
  --       {*} 3 Parameter error
  --       {*} 4 Already own lock specified by id or lockhandle
  --       {*} 5 Illegal lock handle
  --%param i_lock_prefix   префикс идентификатора блокировки(напр. название процедуры)
  --%param i_entity_code   идентификатор блокируемой сущности(напр. serno)
  
  function release_lock(i_lock_prefix       in varchar2
                      , i_entity_code       in varchar2) return number;
  --------------------------------------------------------------------------------------------

  --%usage Освобождает ранее установленную пользовательскую блокировку. Если не получается - генерируется ошибка TCS_UTL.EXPT_USER_LOCK_FAIL (-20750)
  --%param i_lock_prefix   префикс идентификатора блокировки(напр. название процедуры)
  --%param i_entity_code   идентификатор блокируемой сущности(напр. serno)
  
  procedure release_lock(i_lock_prefix in varchar2
                       , i_entity_code in varchar2);
  --------------------------------------------------------------------------------------------
    -- Конвертация даты в unix
	-- %param i_timestamp Конвертируемое значение даты

	function timestamp_to_unix_timestamp(i_timestamp in timestamp) return number;
	--------------------------------------------------------------------------------------------
end pack_utl;
/
create or replace package body pack_utl is

  function FORMAT_NUMBER      return varchar2 is begin return 'FM9999999999999999999999990D99';  end;
  function FORMAT_NUMBER2     return varchar2 is begin return 'FM9999999999999999999999999D99';  end;
  function FORMAT_NLS_NUMBER  return varchar2 is begin return 'NLS_NUMERIC_CHARACTERS=''.,''';    end;
  function FORMAT_DATE        return varchar2 is begin return 'dd.mm.yyyy';                       end;
  function FORMAT_DATETIME    return varchar2 is begin return 'dd.mm.yyyy hh24:mi:ss';            end;
  function FORMAT_TIMESTAMP   return varchar2 is begin return 'dd.mm.yyyy hh24:mi:ssxff';         end; 
  function FORMAT_TIMESTAMPTZ return varchar2 is begin return 'dd.mm.yyyy hh24:mi:ssxff tzh:tzm'; end;
  
  --------------------------------------------------------------------------------------------
  function string_to_number(i_value      in varchar2
                          , i_format     in varchar2 := FORMAT_NUMBER2
                          , i_format_nls in varchar2 := FORMAT_NLS_NUMBER) return number
  is
  begin
    if i_value is null then
      return null;
    end if;

    return to_number(trim(i_value), i_format, i_format_nls);
  end string_to_number;
  --------------------------------------------------------------------------------------------

  function number_to_string(i_value      in number
                          , i_format     in varchar2 := FORMAT_NUMBER
                          , i_format_nls in varchar2 := FORMAT_NLS_NUMBER) return varchar2
  is
  begin
    if i_value is null then
      return null;
    end if;

    return rtrim(rtrim(to_char(i_value, i_format, i_format_nls), '.'), ',');
  end number_to_string;
  --------------------------------------------------------------------------------------------

  function string_to_date(i_value  in varchar2
                        , i_format in varchar2 := FORMAT_DATE) return date
  is
  begin
    if i_value is null then
      return null;
    end if;

    return to_date(trim(i_value), i_format);
  end string_to_date;
  --------------------------------------------------------------------------------------------

  function string_to_datetime(i_value  in varchar2
                            , i_format in varchar2 := FORMAT_DATETIME) return date
  is
  begin
    if i_value is null then
      return null;
    end if;

    return to_date(trim(i_value), i_format);
  end string_to_datetime;
  --------------------------------------------------------------------------------------------
 
  function string_to_timestamp(i_value  in varchar2
                             , i_format in varchar2 := FORMAT_TIMESTAMP) return timestamp
  is
  begin
    if i_value is null then
      return null;
    end if;

    return to_timestamp(trim(i_value), i_format);
  end string_to_timestamp;
  --------------------------------------------------------------------------------------------

 function string_to_timestamp_tz(i_value  in varchar2
                               , i_format in varchar2 := FORMAT_TIMESTAMPTZ) return timestamp with time zone
  is
  begin
    if i_value is null then
      return null;
    end if;

    return to_timestamp_tz(trim(i_value), i_format);
  end string_to_timestamp_tz;
  --------------------------------------------------------------------------------------------

  function date_to_string(i_value in date
                        , i_format in varchar2 := FORMAT_DATE) return varchar2
  is
  begin
    if i_value is null then
      return null;
    end if;

    return to_char(i_value, i_format);
  end date_to_string;
  --------------------------------------------------------------------------------------------

  function datetime_to_string(i_value in date
                            , i_format in varchar2 := FORMAT_DATETIME) return varchar2
  is
  begin
    if i_value is null then
      return null;
    end if;

    return to_char(i_value, i_format);
  end datetime_to_string;
  --------------------------------------------------------------------------------------------

  function timestamp_to_string(i_value in timestamp
                             , i_format in varchar2 := FORMAT_TIMESTAMP) return varchar2
  is
  begin
    if i_value is null then
      return null;
    end if;

    return to_char(i_value, i_format);
  end timestamp_to_string;
  --------------------------------------------------------------------------------------------

  function timestamp_tz_to_string(i_value in timestamp with time zone
                                , i_format in varchar2 := FORMAT_TIMESTAMPTZ) return varchar2
  is
  begin
    if i_value is null then
      return null;
    end if;

    return to_char(i_value, i_format);
  end timestamp_tz_to_string;
  --------------------------------------------------------------------------------------------

  function fix_err_msg(i_err_msg in varchar2) return varchar2
  is
  begin
    return regexp_replace(i_err_msg, '(ORA-[[:digit:]]{5}(:?)([[:space:]]*))', '');
  end fix_err_msg;
  --------------------------------------------------------------------------------------------

  procedure raise_error(i_err_msg in varchar2)
  is
  begin
    raise_application_error(-20770, i_err_msg);
  end raise_error;
  --------------------------------------------------------------------------------------------

  function get_os_username return varchar2
  is
  begin
    return sys_context('userenv', 'os_user');
  end get_os_username;
  --------------------------------------------------------------------------------------------

  function get_db_username return varchar2
  is
  begin
    return sys_context('userenv', 'session_user');
  end get_db_username;
  --------------------------------------------------------------------------------------------

  function get_luhn_key(i_num_str in varchar2) return number deterministic
  is
    v_num_str varchar2(2000) := i_num_str;
    v_digit   pls_integer;
    v_result  number := 0;
  begin
    if v_num_str is null then
      return null;
    end if;

    if not regexp_like(v_num_str, '^[[:digit:]]*$') then
      pack_utl.raise_error('Контрольный ключ можно посчитать для строки, состоящих только из чисел');
    end if;

    if mod(length(v_num_str),2) <> 0 then
      v_num_str := '0'||v_num_str;
    end if;

    for i in reverse 1..length(v_num_str)
    loop
      v_digit := substr(v_num_str, i, 1);
      if mod(i, 2) = 0 then
        v_digit := v_digit * 2;
      end if;

      if v_digit > 9 then
        v_digit := v_digit - 9;
      end if;

      v_result := v_result + v_digit;
    end loop;

    v_result := 10 - mod(v_result, 10);
    if v_result = 10 then
      v_result := 0;
    end if;

    return v_result;
  end get_luhn_key;
  --------------------------------------------------------------------------------------------

  function get_db return varchar2 deterministic
  is
    v_server varchar2(100) := lower(sys_context('USERENV','SERVER_HOST'));
  begin
    return case
             when v_server = 'ds-mvno-db01-prod'     then 'prod'
             when v_server = 'db-fwb-test-2-forward' then 'tst'
             when v_server = 'db-fwb-dev-forward'    then 'dev'
             else 'unknown'
           end;
  end get_db;
  --------------------------------------------------------------------------------------------

  function get_minutes_diff(i_from_date in date
                          , i_to_date   in date) return pls_integer deterministic
  is
    v_result pls_integer;
  begin
    if i_from_date is null or i_to_date is null then
      return null;
    elsif i_from_date = i_to_date then
      return 0;
    end if;

    select t.days * 1440 + t.hours * 24 + t.minutes
      into v_result
      from (select extract(day    from numtodsinterval(i_to_date - i_from_date, 'day')) as days
                 , extract(hour   from numtodsinterval(i_to_date - i_from_date, 'day')) as hours
                 , extract(minute from numtodsinterval(i_to_date - i_from_date, 'day')) as minutes
              from dual) t;

    return v_result;
  end get_minutes_diff;
  --------------------------------------------------------------------------------------------

  procedure set_american_nls
  is
  begin
    execute immediate q'[alter session set NLS_LANGUAGE='AMERICAN' NLS_TERRITORY='AMERICA' NLS_CURRENCY='$' NLS_ISO_CURRENCY='AMERICA' NLS_NUMERIC_CHARACTERS='.,' NLS_DATE_FORMAT='DD-MON-RR' NLS_DATE_LANGUAGE='AMERICAN' NLS_SORT='BINARY']';
  end set_american_nls;
  --------------------------------------------------------------------------------------------

  procedure raise_lock_error(i_err_msg in varchar2)
  is
  begin
    raise_application_error(-20771, i_err_msg);
  end raise_lock_error;
  --------------------------------------------------------------------------------------------

  function get_lock_id (i_lock_prefix in varchar2
                      , i_entity_code in varchar2) return number deterministic
  is
    c_lock_hash_size constant number := 1024 * 1024 * 1024 / 2;
  begin
    return dbms_utility.get_hash_value(name      => i_lock_prefix || i_entity_code
                                     , base      => 0
                                     , hash_size => c_lock_hash_size);
  end get_lock_id;
  --------------------------------------------------------------------------------------------

  function request_lock(i_lock_prefix       in varchar2
                      , i_entity_code       in varchar2
                      , i_time_out          in number  := 0
                      , i_release_on_commit in boolean := true) return number
  is
    v_lock_id number;
  begin
    v_lock_id := get_lock_id(i_lock_prefix => i_lock_prefix
                           , i_entity_code => i_entity_code);

    return dbms_lock.request(id                => v_lock_id
                           , lockmode          => dbms_lock.x_mode
                           , timeout           => i_time_out
                           , release_on_commit => i_release_on_commit);
  end request_lock;
  --------------------------------------------------------------------------------------------

  procedure request_lock(i_lock_prefix       in varchar2
                       , i_entity_code       in varchar2
                       , i_time_out          in number  := 0
                       , i_release_on_commit in boolean := true)
  is
    v_result number;
  begin
    v_result := request_lock(i_lock_prefix       => i_lock_prefix
                           , i_entity_code       => i_entity_code
                           , i_time_out          => i_time_out
                           , i_release_on_commit => i_release_on_commit);
   if v_result <> 0 then
     raise_lock_error('Не удалось получить эксклюзивную блокировку для lock_prefix:<'||i_lock_prefix||'> entity_code:<'||i_entity_code||'> Ошибка:'||
     case v_result
        when 1 then '(1) Timeout'
        when 2 then '(2) Deadlock'
        when 3 then '(3) Parameter error'
        when 4 then '(4) Already own lock specified by id or lockhandle'
        when 5 then '(5) Illegal lock handle'
        else '(' || to_char(v_result) || ') Unknown error'
       end);

   end if;
  end request_lock;
  --------------------------------------------------------------------------------------------

  function release_lock(i_lock_prefix       in varchar2
                      , i_entity_code       in varchar2) return number
  is
    v_lock_id number;
  begin
    v_lock_id := get_lock_id(i_lock_prefix => i_lock_prefix
                           , i_entity_code => i_entity_code);

    return dbms_lock.release(id                => v_lock_id);
  end release_lock;
  --------------------------------------------------------------------------------------------
  procedure release_lock(i_lock_prefix in varchar2
                       , i_entity_code in varchar2)
  is
    v_result  number;
  begin
    v_result := release_lock(i_lock_prefix => i_lock_prefix
                           , i_entity_code => i_entity_code);
    if v_result!=0 then
      raise_lock_error('Не удалось снять блокировку, lock_prefix:<'||i_lock_prefix||'> entity_code:<'||i_entity_code||'> Ошибка:'||
      case v_result
        when 3 then '(3) Parameter error'
        when 4 then '(4) Already own lock specified by id or lockhandle'
        when 5 then '(5) Illegal lock handle'
        else '(' || to_char(v_result) || ') Unknown error'
       end);
    end if;
  end release_lock;
  --------------------------------------------------------------------------------------------
  function timestamp_to_unix_timestamp(i_timestamp in timestamp) return number
  is
	 v_time timestamp;
  begin
		if i_timestamp is null then
			v_time := current_timestamp;
		else
			v_time := i_timestamp;
		end if;

		return trunc((cast(v_time as date)- to_date('01-01-1970','DD-MM-YYYY')) * (86400) * 1000 + (To_Char(v_time, 'FF')/1000), 0);
  end timestamp_to_unix_timestamp;
	--------------------------------------------------------------------------------------------

end pack_utl;
/
