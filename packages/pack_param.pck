create or replace package pack_param is

  --%usage сохраняет строковое значение параметра
  --%param i_section раздел
  --%param i_item параметр
  --%param i_value значение
  
  procedure set_string( i_section in t_params.section%type
                      , i_item    in t_params.item%type
                      , i_value   in varchar2
                      , i_contur  in t_params.contur%type);
  --------------------------------------------------------------------------------------------
  --%usage возвращает строковое значение параметра
  --%param i_section раздел
  --%param i_item параметр
  --%param i_value значение
  --%return varchar2
  
  function get_string( i_section in t_params.section%type
                     , i_item    in t_params.item%type
                     , i_contur  in t_params.contur%type) return varchar2;
  --------------------------------------------------------------------------------------------

  --%usage сохраняет числовое значение параметра
  --%param i_section раздел
  --%param i_item параметр
  --%param i_value значение
  
  procedure set_number( i_section in t_params.section%type
                      , i_item    in t_params.item%type
                      , i_value   in number
                      , i_contur  in t_params.contur%type);
  --------------------------------------------------------------------------------------------
  --%usage возвращает числовое значение параметра
  --%param i_section раздел
  --%param i_item параметр
  --%return number
  
  function get_number( i_section in t_params.section%type
                     , i_item    in t_params.item%type
                     , i_contur  in t_params.contur%type) return number;
  --------------------------------------------------------------------------------------------
  --%usage сохраняет значение параметра типа date с обрезкой времени
  --%param i_section раздел
  --%param i_item параметр
  --%param i_value значение
  
  procedure set_date( i_section in t_params.section%type
                    , i_item    in t_params.item%type
                    , i_value   in date
                    , i_contur  in t_params.contur%type);
  --------------------------------------------------------------------------------------------
  --%usage возвращает значение параметра типа date с обрезкой времени
  --%param i_section раздел
  --%param i_item параметр
  --%return date

  function get_date( i_section in t_params.section%type
                   , i_item    in t_params.item%type
                   , i_contur  in t_params.contur%type) return date;
  --------------------------------------------------------------------------------------------
  --%usage сохраняет значение параметра типа date не обрезая время
  --%param i_section раздел
  --%param i_item параметр
  --%param i_value значение

  procedure set_datetime( i_section in t_params.section%type
                        , i_item    in t_params.item%type
                        , i_value   in date
                        , i_contur  in t_params.contur%type);
  --------------------------------------------------------------------------------------------
  --%usage возвращает значение параметра типа date не обрезая время
  --%param i_section раздел
  --%param i_item параметр
  --%return date

  function get_datetime( i_section in t_params.section%type
                       , i_item    in t_params.item%type
                       , i_contur  in t_params.contur%type) return date;
  --------------------------------------------------------------------------------------------
  --%usage сохраняет логическое значение параметра
  --%param i_section раздел
  --%param i_item параметр
  --%param i_value значение

  procedure set_bool( i_section in t_params.section%type
                    , i_item    in t_params.item%type
                    , i_value   in boolean
                    , i_contur  in t_params.contur%type);
  --------------------------------------------------------------------------------------------
  --%usage возвращает логическое значение параметра. генерирует ошибку, если значение параметра не удалось преобразовать к логическому типу
  --%param i_section раздел
  --%param i_item параметр
  --%return boolean

  function get_bool( i_section in t_params.section%type
                   , i_item    in t_params.item%type
                   , i_contur  in t_params.contur%type) return boolean;
  --------------------------------------------------------------------------------------------
  --%usage возвращает true если параметр существует и false - в противном случае
  --%param i_section раздел
  --%param i_item параметр
  --%return boolean

  function exists( i_section in t_params.section%type
                 , i_item    in t_params.item%type
                 , i_contur  in t_params.contur%type) return boolean;
  --------------------------------------------------------------------------------------------
  --%usage удаление параметра
  --%param i_section раздел
  --%param i_item параметр

  procedure remove( i_section in t_params.section%type
                  , i_item    in t_params.item%type
                  , i_contur  in t_params.contur%type);
  --------------------------------------------------------------------------------------------

end pack_param;
/
create or replace package body pack_param is

  procedure set_value( i_section    in t_params.section%type
                     , i_item       in t_params.item%type
                     , i_value      in t_params.value%type
                     , i_value_type in t_params.value_type%type
                     , i_contur     in t_params.contur%type)
  is
  begin
    merge into t_params t
    using (select upper(trim(i_section)) as section
                , upper(trim(i_item))    as item
                , upper(trim(i_contur))  as contur
             from dual) x
    on (t.section = x.section and t.item = x.item and t.contur = x.contur)
    when matched then
      update
         set t.value = i_value
    when not matched then
      insert
        (id, section, item, value, value_type, contur)
      values
        (s_t_params_id.nextval, upper(trim(i_section)), upper(trim(i_item)), i_value, upper(trim(i_value_type)), upper(trim(i_contur)));
  end set_value;
  --------------------------------------------------------------------------------------------

  function get_value ( i_section in t_params.section%type
                     , i_item    in t_params.item%type
                     , i_contur  in t_params.contur%type) return varchar2 result_cache
  is
    v_result t_params.value%type;
  begin
    select t.value
      into v_result
      from t_params t
     where t.section = upper(trim(i_section))
       and t.item    = upper(trim(i_item))
       and t.contur  = upper(trim(i_contur));
    return v_result;
  exception
    when no_data_found then
      return null;
  end get_value;
  --------------------------------------------------------------------------------------------

  procedure set_string( i_section in t_params.section%type
                      , i_item    in t_params.item%type
                      , i_value   in varchar2
                      , i_contur  in t_params.contur%type)
  is
  begin
    set_value( i_section    => i_section
             , i_item       => i_item
             , i_value      => i_value
             , i_value_type => 'C'
             , i_contur     => i_contur);
  end set_string;
  --------------------------------------------------------------------------------------------

  function get_string ( i_section in t_params.section%type
                      , i_item    in t_params.item%type
                      , i_contur  in t_params.contur%type) return varchar2
  is
  begin
    return get_value( i_section => i_section
                    , i_item    => i_item
                    , i_contur  => i_contur);
  end get_string;
  --------------------------------------------------------------------------------------------

  procedure set_number( i_section in t_params.section%type
                      , i_item    in t_params.item%type
                      , i_value   in number
                      , i_contur  in t_params.contur%type)
  is
  begin
    set_value( i_section     => i_section
             , i_item        => i_item
             , i_value       => pack_utl.number_to_string(i_value)
             , i_value_type  => 'N'
             , i_contur      => i_contur);
  end set_number;
  --------------------------------------------------------------------------------------------

  function get_number( i_section in t_params.section%type
                     , i_item    in t_params.item%type
                     , i_contur  in t_params.contur%type) return number
  is
    v_result t_params.value%type;
  begin
    v_result := get_value( i_section => i_section
                         , i_item    => i_item
                         , i_contur  => i_contur);
    return pack_utl.string_to_number(v_result);
  end get_number;
  --------------------------------------------------------------------------------------------

  procedure set_date( i_section in t_params.section%type
                    , i_item    in t_params.item%type
                    , i_value   in date
                    , i_contur  in t_params.contur%type)
  is
  begin
    set_value( i_section     => i_section
             , i_item        => i_item
             , i_value       => pack_utl.date_to_string(i_value)
             , i_value_type  => 'D'
             , i_contur      => i_contur);
  end set_date;
  --------------------------------------------------------------------------------------------

  function get_date( i_section in t_params.section%type
                   , i_item    in t_params.item%type
                   , i_contur  in t_params.contur%type) return date
  is
    v_result t_params.value%type;
  begin
    v_result := get_value( i_section => i_section
                         , i_item    => i_item
                         , i_contur  => i_contur);
    return pack_utl.string_to_date(v_result);
  end get_date;
  --------------------------------------------------------------------------------------------

  procedure set_datetime( i_section in t_params.section%type
                        , i_item    in t_params.item%type
                        , i_value   in date
                        , i_contur  in t_params.contur%type)
  is
  begin
    set_value( i_section    => i_section
             , i_item       => i_item
             , i_value      => pack_utl.datetime_to_string(i_value)
             , i_value_type => 'D'
             , i_contur     => i_contur);
  end set_datetime;
  --------------------------------------------------------------------------------------------

  function get_datetime( i_section in t_params.section%type
                       , i_item    in t_params.item%type
                       , i_contur  in t_params.contur%type) return date
  is
    v_result t_params.value%type;
  begin
    v_result := get_value( i_section => i_section
                         , i_item    => i_item
                         , i_contur  => i_contur);
    return pack_utl.string_to_datetime(v_result);
  end get_datetime;
  --------------------------------------------------------------------------------------------

  procedure set_bool( i_section in t_params.section%type
                    , i_item    in t_params.item%type
                    , i_value   in boolean
                    , i_contur  in t_params.contur%type)
  is
  begin
    set_value( i_section     => i_section
             , i_item        => i_item
             , i_value       => sys.diutil.bool_to_int(i_value)
             , i_value_type  => 'B'
             , i_contur      => i_contur);
  end set_bool;
  --------------------------------------------------------------------------------------------

  function get_bool( i_section in t_params.section%type
                   , i_item    in t_params.item%type
                   , i_contur  in t_params.contur%type) return boolean
  is
    EXPT_BOOL_VALUE exception;
    pragma exception_init (EXPT_BOOL_VALUE, -6502);
    v_result number;
  begin
    v_result := get_number( i_section => i_section
                          , i_item    => i_item
                          , i_contur  => i_contur);
    return sys.diutil.int_to_bool(v_result);
  exception
    when EXPT_BOOL_VALUE then
      pack_utl.raise_error('Значение '|| v_result ||' параметра '||i_section||'.'||i_item||' не является логическим');
  end get_bool;
  --------------------------------------------------------------------------------------------

  function exists( i_section in t_params.section%type
                 , i_item    in t_params.item%type
                 , i_contur  in t_params.contur%type) return boolean
  is
    v_count number;
  begin
    select count(*)
      into v_count
      from t_params t
     where t.section = i_section
       and t.item    = i_item
       and t.contur  = i_contur;
    return v_count > 0;
  end exists;
  --------------------------------------------------------------------------------------------

  procedure remove( i_section in t_params.section%type
                  , i_item    in t_params.item%type
                  , i_contur  in t_params.contur%type)
  is
  begin
    delete t_params t
     where t.section = i_section
       and t.item    = i_item
       and t.contur  = i_contur;
  end remove;
  --------------------------------------------------------------------------------------------

end pack_param;
/
