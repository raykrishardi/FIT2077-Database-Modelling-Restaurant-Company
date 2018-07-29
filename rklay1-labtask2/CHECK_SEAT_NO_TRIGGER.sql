--------------------------------------------------------
--  File created - Saturday-April-23-2016
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger CHECK_SEAT_NO_TRIGGER
--------------------------------------------------------

/*
RAY KRISHARDI LAYADI
RKLAY1 - 26445549
*/

create or replace trigger "CHECK_SEAT_NO_TRIGGER" before
  insert
    on diner for each row declare
    -- keep track of the maximum number of available seat in a particular table
    max_num_of_seat it_table.table_seating_capacity%type;
    -- keep track of the number of occupied seat in a particular table
    num_of_seat diner.diner_seat_no%type;
    -- exception to be raised when the maximum number of available seat is
    -- exceeded
    insufficient_seat exception;
  begin
    -- determine the maximum number of available seat in a particular table
    select
      table_seating_capacity
    into
      max_num_of_seat
    from
      it_table
    where
      table_no = :new.table_no;

    -- determine the number of occupied seat in a particular table
    select
      count(diner_seat_no)
    into
      num_of_seat
    from
      diner
    where
      table_no = :new.table_no;

    -- raise the exception insufficient_seat
    -- when before the insertion, the number of occupied seat equals the
    -- maximum number of available seat
    if (num_of_seat = max_num_of_seat) then
      raise insufficient_seat;
    end if;

  -- error message to be displayed when the maximum number of available seat
  -- is exceeded
  exception
  when insufficient_seat then
    raise_application_error(-20001,
    'Number of seats exceed number of available seats - Action failed');

  end;
  /
  alter trigger "CHECK_SEAT_NO_TRIGGER" enable;
