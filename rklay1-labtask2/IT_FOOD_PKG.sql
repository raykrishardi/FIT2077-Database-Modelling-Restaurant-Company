/*
RAY KRISHARDI LAYADI
RKLAY1 - 26445549
*/

CREATE OR REPLACE package it_food
as

  procedure add_diner(
      arg_diner_payment_due in diner.diner_payment_due%type,
      arg_diner_seat_no     in diner.diner_seat_no%type,
      arg_diner_completed   in diner.diner_completed%type,
      arg_table_no          in diner.table_no%type,
      arg_diner_no out diner.diner_no%type );

  procedure add_order(
      arg_diner_no           in fs_diner.diner_no%type,
      arg_food_item_no       in fs_diner.food_item_no%type,
      arg_food_serve_size    in fs_diner.food_serve_size%type,
      arg_fs_diner_no_serves in fs_diner.fs_diner_no_serves%type,
      arg_order_success out char );

  procedure add_fooditem(
      arg_food_name        in fooditem.food_name%type,
      arg_food_description in fooditem.food_description%type,
      arg_food_type        in fooditem.food_type%type,
      arg_relevant_data1   in char,
      arg_relevant_data2   in char,
      arg_food_item_no out fooditem.food_item_no%type );

  procedure add_foodserve(
      arg_food_item_no         in food_serve.food_item_no%type,
      arg_food_serve_size      in food_serve.food_serve_size%type,
      arg_food_serve_kilojules in food_serve.food_serve_kilojules%type,
      arg_food_serve_cost      in food_serve.food_serve_cost%type,
      arg_add_foodserve_success out char );

  procedure get_diner_details(
      arg_diner_no in diner.diner_no%type,
      arg_table_no out diner.table_no%type,
      arg_diner_seat_no out diner.diner_seat_no%type,
      arg_diner_seated out char,
      arg_diner_payment_due out diner.diner_payment_due%type,
      fooditem_cursor out sys_refcursor );

end it_food;
/


CREATE OR REPLACE package body it_food
as
--------------------------------------------------------------------------------
                                --FUNCTION--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
                              --valid_table--
--------------------------------------------------------------------------------

  -- determine whether the given table number is valid or invalid
  function valid_table(
      table_no_in in it_table.table_no%type)
    return boolean
  as
    checkcount number;
  begin
    -- check the existence of the given table number
    select
      count(table_no)
    into
      checkcount
    from
      it_table
    where
      table_no=table_no_in;

    -- check if the table exist or not
    -- checkcount = 1 means that the table exist
    if(checkcount=1) then
      return true;
    else
      return false;
    end if;

  end valid_table;

--------------------------------------------------------------------------------
                                --available_seat--
--------------------------------------------------------------------------------

  -- determine whether the given seat number is available or unavailable
  function available_seat(
      seat_no_in  in diner.diner_seat_no%type,
      table_no_in in diner.table_no%type)
    return boolean
  as
    checkcount number;
  begin

    -- check the existence of the given seat number in a particular table
    -- number
    select
      count(diner_seat_no)
    into
      checkcount
    from
      diner
    where
      diner_seat_no=seat_no_in
    and table_no   =table_no_in;

    -- check if the seat is occupied or not
    -- checkcount = 0 means that the seat is NOT occupied
    if (checkcount = 0) then
      return true;
    else
      return false;
    end if;

  end available_seat;

--------------------------------------------------------------------------------
                                  --valid_diner--
--------------------------------------------------------------------------------

  -- determine whether the given diner number is valid or invalid
  function valid_diner(
      diner_no_in in diner.diner_no%type)
    return boolean
  as
    checkcount number;
  begin
    -- check the existence of the given diner number
    select
      count(diner_no)
    into
      checkcount
    from
      diner
    where
      diner_no=diner_no_in;

    -- check if the diner exist or not
    -- checkcount = 1 means that the diner exist
    if (checkcount=1) then
      return true;
    else
      return false;
    end if;

  end valid_diner;

--------------------------------------------------------------------------------
                              --valid_food_item--
--------------------------------------------------------------------------------

  -- determine whether the given food item number is valid or invalid
  function valid_food_item(
      food_item_no_in in fooditem.food_item_no%type)
    return boolean
  as
    checkcount number;
  begin
    -- check the existence of the given food item number
    select
      count(food_item_no)
    into
      checkcount
    from
      fooditem
    where
      food_item_no=food_item_no_in;

    -- check if the food item exist or not
    -- checkcount = 1 means that the food item exist
    if(checkcount =1) then
      return true;
    else
      return false;
    end if;

  end valid_food_item;

--------------------------------------------------------------------------------
                              --valid_food_type--
--------------------------------------------------------------------------------

  -- determine whether the given food type is valid or invalid
  function valid_food_type(
      food_type_in in fooditem.food_type%type)
    return boolean
  as
  begin
    -- check whether the given food type is one of the valid types
    -- 'B' or 'E' or 'M' or 'D' only
    if(food_type_in='B' or food_type_in='E' or food_type_in='M' or food_type_in
                   ='D') then
      return true;
    else
      return false;
    end if;

  end valid_food_type;

--------------------------------------------------------------------------------
                          --valid_main_detail_value--
--------------------------------------------------------------------------------

  -- determine whether the given details for a main food item is
  -- valid or invalid
  function valid_main_detail_value(
      relevant_data1_in in char,
      relevant_data2_in in char )
    return boolean
  as
  begin

    -- check whether the details required for a main food item type
    -- are fully specified
    -- MAIN_VEGETARIAN and MAIN_GLUTEN_FREE need to be specified
    -- with a valid value (Y/N)
    if((relevant_data1_in='Y' or relevant_data1_in='N') and
      (relevant_data2_in='Y' or relevant_data2_in='N')) then
      return true;
    else
      return false;
    end if;

  end valid_main_detail_value;

--------------------------------------------------------------------------------
                            --invalid_serve_size--
--------------------------------------------------------------------------------

  -- determine whether the given serve size for the particular food item type
  -- is valid or invalid
  function invalid_serve_size(
      food_item_no_in    in fs_diner.food_item_no%type,
      food_serve_size_in in fs_diner.food_serve_size%type)
    return boolean
  as
    food_type fooditem.food_type%type;
  begin
    -- determine the type of the particular food item
    select
      food_type
    into
      food_type
    from
      fooditem
    where
      food_item_no = food_item_no_in;

    -- check that only main food type can have small and large serve size
    -- if other food types have small or large serve size then the serve size
    -- is invalid
    if ((food_type <> 'M' and food_serve_size_in = 'SM') or
      (food_type <> 'M' and food_serve_size_in = 'LG')) then
      return true;
    else
      return false;
    end if;

  end invalid_serve_size;

--------------------------------------------------------------------------------
                                  --is_numeric--
--------------------------------------------------------------------------------

  -- determine whether the given string parameter is numeric or not
  function is_numeric(
      parameter_in in char)
    return boolean
  as
    -- local variable to check whether the parameter can be numeric or not
    check_num number;
  begin
    -- return true if the given string parameter is a numeric value
    check_num := to_number(parameter_in);
    return true;

  -- return false if the given string parameter is NOT a numeric value
  exception
  when others then
    return false;

  end is_numeric;

--------------------------------------------------------------------------------
                          --valid_bev_alcohol_level--
--------------------------------------------------------------------------------

  -- determine whether the beverage alcohol level is valid or invalid
  function valid_bev_alcohol_level(
      relevant_data1_in in char)
    return boolean
  as
  begin
    -- beverage alcohol level is valid if the value is between the range
    -- and the scale does NOT exceed the max allowed scale
    if (to_number(relevant_data1_in)       >= 0 and to_number(relevant_data1_in) <
      100 and to_number(relevant_data1_in) <= trunc(relevant_data1_in,1)) then
      return true;
    else
      return false;
    end if;

  end valid_bev_alcohol_level;

--------------------------------------------------------------------------------
                                  --PROCEDURE--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
                                  --add_diner--
--------------------------------------------------------------------------------

  procedure add_diner(
      arg_diner_payment_due in diner.diner_payment_due%type,
      arg_diner_seat_no     in diner.diner_seat_no%type,
      arg_diner_completed   in diner.diner_completed%type,
      arg_table_no          in diner.table_no%type,
      arg_diner_no out diner.diner_no%type )
  as
    -- exception to be raised when the table is invalid
    invalid_table exception;
    -- exception to be raised when the seat is unavailable or invalid
    invalid_seat exception;
    -- exception to be raised when the payment due amount is invalid
    invalid_payment_amount exception;
  begin
  
    -- raise the exception when the table is invalid
    if (not valid_table(arg_table_no)) then
      raise invalid_table;
    -- raise the exception when the seat is unavailable (occupied)
    -- or the seat number is out of range
    elsif (not available_seat(arg_diner_seat_no,arg_table_no) or
      arg_diner_seat_no<=0 or arg_diner_seat_no>=100) then
      raise invalid_seat;
    -- raise the exception when the payment due amount is invalid
    -- the value is out of range or the scale exceeds the max allowed scale
    elsif (arg_diner_payment_due < 0 or arg_diner_payment_due >= 10000 or
      arg_diner_payment_due      > trunc(arg_diner_payment_due,2)) then
      raise invalid_payment_amount;
    end if;

    -- insert the appropriate data if all arguments are valid
    insert
    into
      diner values
      (
        diner_diner_no_seq.nextval,
        arg_diner_payment_due,
        arg_diner_seat_no,
        sysdate,
        arg_diner_completed,
        arg_table_no
      );

    -- assign the unique diner number generated by the sequence
    -- to the out parameter
    arg_diner_no := diner_diner_no_seq.currval;

    commit;

  -- error message to be displayed when a particular exception is raised
  exception
  when invalid_table then
    raise_application_error(-20001, 'Invalid table - Action failed');
  when invalid_seat then
    raise_application_error(-20002, 'Invalid seat - Action failed');
  when invalid_payment_amount then
    raise_application_error(-20003,
    'Invalid payment due amount - Action failed');

  end add_diner;

--------------------------------------------------------------------------------
                                  --add_order--
--------------------------------------------------------------------------------

  procedure add_order
    (
      arg_diner_no           in fs_diner.diner_no%type,
      arg_food_item_no       in fs_diner.food_item_no%type,
      arg_food_serve_size    in fs_diner.food_serve_size%type,
      arg_fs_diner_no_serves in fs_diner.fs_diner_no_serves%type,
      arg_order_success out char
    )
  as
    -- exception to be raised when the diner is invalid
    invalid_diner exception;
    -- exception to be raised when the food item is invalid
    invalid_food_item exception;
    -- exception to be raised when the number of serves is invalid
    invalid_diner_no_serves exception;
    -- exception to be raised when
    -- the given serve size for the particular food item type is invalid
    invalid_serve_size_exception exception;
  begin

    -- initialise the value of the out parameter with an empty string
    arg_order_success := '';

    -- raise the exception when the diner is invalid
    if (not valid_diner(arg_diner_no)) then
      raise invalid_diner;
    -- raise the exception when the food item is invalid
    elsif (not valid_food_item(arg_food_item_no)) then
      raise invalid_food_item;
    -- raise the exception when the number of serves is invalid
    -- the value is out of range
    elsif (arg_fs_diner_no_serves <= 0 or arg_fs_diner_no_serves>=10) then
      raise invalid_diner_no_serves;
    -- raise the exception when the serve size for the particular food item
    -- type
    -- is invalid or the given argument is an empty string or invalid serve
    -- size
    elsif (invalid_serve_size(arg_food_item_no,arg_food_serve_size) or not
      (
        arg_food_serve_size='SM' or arg_food_serve_size='ST' or
        arg_food_serve_size='LG'
      )
      or arg_food_serve_size is null) then
      raise invalid_serve_size_exception;
    end if;

    -- insert the appropriate data if all arguments are valid
    insert
    into
      fs_diner values
      (
        arg_diner_no,
        arg_food_item_no,
        arg_food_serve_size,
        arg_fs_diner_no_serves
      );

    -- display a success message if all arguments are valid
    arg_order_success := 'Action successfully completed.';

    commit;

  -- error message to be displayed when a particular exception is raised
  exception
  when invalid_diner then
    raise_application_error(-20001, 'Invalid diner - Action failed');
  when invalid_food_item then
    raise_application_error(-20002, 'Invalid food item - Action failed');
  when invalid_diner_no_serves then
    raise_application_error(-20003, 'Invalid number of serves - Action failed')
    ;
  when invalid_serve_size_exception then
    raise_application_error(-20004, 'Invalid food serve size - Action failed');

  end add_order;

--------------------------------------------------------------------------------
                                --add_fooditem--
--------------------------------------------------------------------------------

  procedure add_fooditem
    (
      arg_food_name        in fooditem.food_name%type,
      arg_food_description in fooditem.food_description%type,
      arg_food_type        in fooditem.food_type%type,
      arg_relevant_data1   in char,
      arg_relevant_data2   in char,
      arg_food_item_no out fooditem.food_item_no%type
    )
  as
    -- exception to be raised when the beverage alcohol level amount is invalid,
    -- null, or NOT numeric
    invalid_bev_alcohol_level exception;
    -- exception to be raised when the given food type is NOT one of the valid
    -- types
    invalid_food_type exception;
    -- exception to be raised when the food name is an empty string
    -- or the length of the string exceeds the max allowed length
    invalid_food_name exception;
    -- exception to be raised when the food description is an empty string
    -- or the length of the string exceeds the max allowed length
    invalid_food_description exception;
    -- exception to be raised when the detail required for an entree food item
    -- type is NOT fully specified
    -- ENTREE_HOT needs to be specified with a valid value (Y/N)
    invalid_entree_detail_value exception;
    -- exception to be raised when the details required for a main food item
    -- type are NOT fully specified
    -- MAIN_VEGETARIAN and MAIN_GLUTEN_FREE need to be specified with a valid
    -- value (Y/N)
    invalid_main_detail_value exception;
    -- exception to be raised when the detail required for a dessert food item
    -- type is NOT fully specified
    -- DESSERT_LACTOSE_FREE needs to be specified with a valid value (Y/N)
    invalid_dessert_detail_value exception;
  begin

    -- raise the exception when the given food type is NOT one of the valid
    -- types
    if(not valid_food_type(arg_food_type)) then
      raise invalid_food_type;
    -- raise the exception when the food name is an empty string
    -- or the length of the string exceeds the max allowed length
    elsif(arg_food_name is null or length(arg_food_name) > 50) then
      raise invalid_food_name;
    -- raise the exception when the food description is an empty string
    -- or the length of the string exceeds the max allowed length
    elsif(arg_food_description is null or length(arg_food_description) > 100) then
      raise invalid_food_description;
    end if;

    -- insert the appropriate data if all arguments are valid
    insert
    into
      fooditem values
      (
        fooditem_food_item_no_seq.nextval,
        arg_food_name,
        arg_food_description,
        arg_food_type
      );

    -- assign the unique food item number generated by the sequence
    -- to the out parameter
    arg_food_item_no := fooditem_food_item_no_seq.currval;


    -- insert the appropriate data if the food type is beverage
    if(arg_food_type = 'B') then
      -- raise the exception when the beverage alcohol level amount is invalid,
      -- an empty string, or NOT a numeric value
      if(not is_numeric(arg_relevant_data1) or arg_relevant_data1 is null or
        not valid_bev_alcohol_level(arg_relevant_data1)) then
        raise invalid_bev_alcohol_level;
      end if;
      -- insert the details required for a beverage food item type
      -- if all arguments are valid
      insert
      into
        beverage values
        (
          arg_food_item_no,
          to_number(arg_relevant_data1)
        );


    -- insert the appropriate data if the food type is entree
    elsif(arg_food_type = 'E') then
      -- raise the exception when the detail required for an entree food item
      -- type is NOT fully specified with the appropriate value
      -- or when the required detail is an empty string
      if(arg_relevant_data1 is null or not
        (arg_relevant_data1='Y' or arg_relevant_data1='N')) then
        raise invalid_entree_detail_value;
      end if;
      -- insert the details required for an entree food item type
      -- if all arguments are valid
      insert
      into
        entree values
        (
          arg_food_item_no,
          arg_relevant_data1
        );


    -- insert the appropriate data if the food type is main
    elsif(arg_food_type = 'M') then
      -- raise the exception when the details required for a main food item
      -- type are NOT fully specified with the appropriate value
      -- or when one/both of the required details is/are null
      if(arg_relevant_data1 is null or arg_relevant_data2 is null or not
        valid_main_detail_value(arg_relevant_data1, arg_relevant_data2)) then
        raise invalid_main_detail_value;
      end if;
      -- insert the details required for a main food item type
      -- if all arguments are valid
      insert
      into
        main values
        (
          arg_food_item_no,
          arg_relevant_data1,
          arg_relevant_data2
        );


    -- insert the appropriate data if the food type is dessert
    elsif(arg_food_type = 'D') then
      -- raise the exception when the detail required for a dessert food item
      -- type is NOT fully specified with the appropriate value
      -- or when the required detail is an empty string
      if(arg_relevant_data1 is null or not
        (arg_relevant_data1='Y' or arg_relevant_data1='N')) then
        raise invalid_dessert_detail_value;
      end if;
      -- insert the details required for a dessert food item type
      -- if all arguments are valid
      insert
      into
        dessert values
        (
          arg_food_item_no,
          arg_relevant_data1
        );
    end if;

    commit;

    -- error message to be displayed when a particular exception is raised
  exception
  when invalid_bev_alcohol_level then
    raise_application_error(-20001, 'Invalid alcohol level - Action failed');
  when invalid_food_type then
    raise_application_error(-20002, 'Invalid food type - Action failed');
  when invalid_food_name then
    raise_application_error(-20003, 'Invalid food name - Action failed');
  when invalid_food_description then
    raise_application_error(-20004, 'Invalid food description - Action failed')
    ;
  when invalid_entree_detail_value then
    raise_application_error(-20005,
    'Invalid entree details value - Action failed');
  when invalid_main_detail_value then
    raise_application_error(-20006,
    'Invalid main details value - Action failed');
  when invalid_dessert_detail_value then
    raise_application_error(-20007,
    'Invalid dessert details value - Action failed');

  end add_fooditem;

--------------------------------------------------------------------------------
                                --add_foodserve--
--------------------------------------------------------------------------------

  procedure add_foodserve
    (
      arg_food_item_no         in food_serve.food_item_no%type,
      arg_food_serve_size      in food_serve.food_serve_size%type,
      arg_food_serve_kilojules in food_serve.food_serve_kilojules%type,
      arg_food_serve_cost      in food_serve.food_serve_cost%type,
      arg_add_foodserve_success out char
    )
  as
    -- exception to be raised when the food item is invalid
    invalid_food_item exception;
    -- exception to be raised when the given argument is an empty string or
    -- invalid serve size
    invalid_serve_size exception;
    -- exception to be raised when the food serve kilojules amount is invalid
    invalid_serve_kilojules exception;
    -- exception to be raised when the food serve cost amount is invalid
    invalid_serve_cost exception;
  begin

    -- initialise the value of the out parameter with an empty string
    arg_add_foodserve_success := '';

    -- raise the exception when the food item is invalid
    if(not valid_food_item(arg_food_item_no))then
      raise invalid_food_item;
    -- raise the exception when the given argument is an empty string or
    -- invalid serve size
    elsif (not(arg_food_serve_size='SM' or arg_food_serve_size='ST' or
          arg_food_serve_size='LG') or arg_food_serve_size is null)then
      raise invalid_serve_size;
    -- raise the exception when the kilojules amount is invalid
    -- the value is out of range
    elsif(arg_food_serve_kilojules<=0 or arg_food_serve_kilojules>=10000)then
      raise invalid_serve_kilojules;
    -- raise the exception when the cost amount is invalid
    -- the value is out of range or the scale exceeds the max allowed scale
    elsif(arg_food_serve_cost<=0 or arg_food_serve_cost>=1000 or
      arg_food_serve_cost     > trunc(arg_food_serve_cost,2))then
      raise invalid_serve_cost;
    end if;

    -- insert the appropriate data if all arguments are valid
    insert
    into
      food_serve values
      (
        arg_food_item_no,
        arg_food_serve_size,
        arg_food_serve_kilojules,
        arg_food_serve_cost
      );

    -- display a success message if all arguments are valid
    arg_add_foodserve_success := 'Action successfully completed.';

    commit;

  -- error message to be displayed when a particular exception is raised
  exception
  when invalid_food_item then
    raise_application_error(-20001, 'Invalid food item - Action failed');
  when invalid_serve_size then
    raise_application_error(-20002, 'Invalid food serve size - Action failed');
  when invalid_serve_kilojules then
    raise_application_error(-20003,
    'Invalid food serve kilojoules amount - Action failed');
  when invalid_serve_cost then
    raise_application_error(-20004,
    'Invalid food serve cost amount - Action failed');

  end add_foodserve;

--------------------------------------------------------------------------------
                            --get_diner_details--
--------------------------------------------------------------------------------

  procedure get_diner_details
    (
      arg_diner_no in diner.diner_no%type,
      arg_table_no out diner.table_no%type,
      arg_diner_seat_no out diner.diner_seat_no%type,
      arg_diner_seated out char,
      arg_diner_payment_due out diner.diner_payment_due%type,
      fooditem_cursor out sys_refcursor
    )
  as
    -- exception to be raised when the diner is invalid
    invalid_diner exception;
    -- local variable to be assigned to the appropriate out parameter
    -- and holds the appropriate value from the select statement
    table_no diner.table_no%type;
    -- local variable to be assigned to the appropriate out parameter
    -- and holds the appropriate value from the select statement
    diner_seat_no diner.diner_seat_no%type;
    -- local variable to be assigned to the appropriate out parameter
    -- and holds the appropriate value from the select statement
    diner_seated char(22);
    -- local variable to be assigned to the appropriate out parameter
    -- and holds the appropriate value from the select statement
    diner_payment_due diner.diner_payment_due%type;
  begin

    -- raise the exception when the diner is invalid
    if(not valid_diner(arg_diner_no))then
      raise invalid_diner;
    end if;

    -- select the appropriate column and assign the value to the appropriate
    -- local variable
    select
      table_no,
      diner_seat_no,
      to_char(diner_seated, 'DD-MON-YYYY HH24:MI:SS') as "DINER_SEATED",
      diner_payment_due
    into
      table_no,
      diner_seat_no,
      diner_seated,
      diner_payment_due
    from
      diner
    where
      diner_no=arg_diner_no
    order by
      table_no;

    -- assign the value of the local variable to the appropriate out parameter
    arg_table_no          := table_no;
    arg_diner_seat_no     := diner_seat_no;
    arg_diner_seated      := diner_seated;
    arg_diner_payment_due := diner_payment_due;

    -- explicit cursor to hold the output of the SQL select statement
    -- that may return two or more rows
    -- in this case, it holds the appropriate fooditem details
    open fooditem_cursor for select fi.food_item_no,
    fi.food_name,
    fs.food_serve_size,
    fs.food_serve_cost,
    fd.fs_diner_no_serves
  as
    "SERVES",
    fs.food_serve_cost * fd.fs_diner_no_serves
  as
    "LINE_COST" from fs_diner fd,
    food_serve fs,
    fooditem fi where fd.food_item_no     =fs.food_item_no and fd.food_serve_size=
    fs.food_serve_size and fs.food_item_no=fi.food_item_no and fd.diner_no=
    arg_diner_no order by fi.food_item_no;

  -- error message to be displayed when a particular exception is raised
  exception
  when invalid_diner then
    raise_application_error(-20001, 'Invalid diner - Action failed');

  end get_diner_details;

end it_food;
/
