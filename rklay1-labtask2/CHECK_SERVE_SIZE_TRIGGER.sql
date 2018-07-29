--------------------------------------------------------
--  File created - Saturday-April-23-2016
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger CHECK_SERVE_SIZE_TRIGGER
--------------------------------------------------------

/*
RAY KRISHARDI LAYADI
RKLAY1 - 26445549
*/

create or replace trigger "CHECK_SERVE_SIZE_TRIGGER" before
  insert
    on food_serve for each row declare
    -- keep track of the food item type
    food_type fooditem.food_type%type;
    -- exception to be raised when invalid serve size for the particular food
    -- item type is entered
    invalid_serve_size exception;
  begin
    -- determine the type of the particular food item
    select
      food_type
    into
      food_type
    from
      fooditem
    where
      food_item_no = :new.food_item_no;

    -- raise the exception invalid_serve_size
    -- when before the insertion, invalid serve size for the particular food
    -- item type is entered
    if ((food_type <> 'M' and :new.food_serve_size = 'SM') or
      (
        food_type <> 'M' and :new.food_serve_size = 'LG'
      )
      ) then
      raise invalid_serve_size;
    end if;

  -- error message to be displayed when invalid serve size for the particular
  -- food item type is entered
  exception
  when invalid_serve_size then
    raise_application_error(-20001, 'Invalid food serve size - Action failed');
  end;
  /
  alter trigger "CHECK_SERVE_SIZE_TRIGGER" enable;
