spool ./IT_PKG_TEST_OUTPUT.txt

/*
RAY KRISHARDI LAYADI
RKLAY1 - 26445549
*/

------------------------------------------------------------------------------
                                --add_diner--
--------------------------------------------------------------------------------
--  procedure add_diner(
--      arg_diner_payment_due in diner.diner_payment_due%type,
--      arg_diner_seat_no     in diner.diner_seat_no%type,
--      arg_diner_completed   in diner.diner_completed%type,
--      arg_table_no          in diner.table_no%type,
--      arg_diner_no out diner.diner_no%type );

                        ---------------------------
                        -- arg_diner_payment_due --
                        ---------------------------

-- invalid payment due amount (payment due amount scale exceeds the maximum allowed scale)
var new_diner_no number
exec it_food.add_diner(111.111,1,sysdate,1,:new_diner_no);
print new_diner_no

-- invalid payment due amount (payment due amount >= 10000)
var new_diner_no number
exec it_food.add_diner(10000,1,sysdate,1,:new_diner_no);
print new_diner_no

-- invalid payment due amount (payment due amount >= 10000)
var new_diner_no number
exec it_food.add_diner(10001,1,sysdate,1,:new_diner_no);
print new_diner_no

-- invalid payment due amount (payment due amount < 0)
var new_diner_no number
exec it_food.add_diner(-1,1,sysdate,1,:new_diner_no);
print new_diner_no

-- valid payment due amount (payment due amount >= 0 && payment due amount < 10000)
var new_diner_no number
exec it_food.add_diner(0,1,sysdate,1,:new_diner_no);
print new_diner_no
select * from diner
where diner_no=(select max(diner_no) from diner);

-- valid payment due amount (payment due amount >= 0 && payment due amount < 10000)
var new_diner_no number
exec it_food.add_diner(111.11,2,sysdate,1,:new_diner_no);
print new_diner_no
select * from diner
where diner_no=(select max(diner_no) from diner);

                        ---------------------------
                        --   arg_diner_seat_no   --
                        ---------------------------

-- valid seat (seat number > 0 && seat number < 100 && no duplicate seat number)
var new_diner_no number
exec it_food.add_diner(1,1,sysdate,2,:new_diner_no);
print new_diner_no
select * from diner
where diner_no=(select max(diner_no) from diner);

-- invalid seat (duplicate seat number 1 in table number 2)
-- the seat has been occupied
var new_diner_no number
exec it_food.add_diner(1,1,sysdate,2,:new_diner_no);
print new_diner_no

-- invalid seat (seat number >= 100)
var new_diner_no number
exec it_food.add_diner(1,100,sysdate,2,:new_diner_no);
print new_diner_no

-- invalid seat (seat number >= 100)
var new_diner_no number
exec it_food.add_diner(1,101,sysdate,2,:new_diner_no);
print new_diner_no

-- invalid seat (seat number <= 0)
var new_diner_no number
exec it_food.add_diner(1,0,sysdate,2,:new_diner_no);
print new_diner_no

-- invalid seat (seat number <= 0)
var new_diner_no number
exec it_food.add_diner(1,-1,sysdate,2,:new_diner_no);
print new_diner_no

                        ---------------------------
                        --  arg_diner_completed  --
                        ---------------------------

-- valid diner completed
-- diner completed is null
var new_diner_no number
exec it_food.add_diner(1,2,null,2,:new_diner_no);
print new_diner_no
select * from diner
where diner_no=(select max(diner_no) from diner);

-- valid diner completed
-- diner completed is NOT null
var new_diner_no number
exec it_food.add_diner(1,3,sysdate,2,:new_diner_no);
print new_diner_no
select * from diner
where diner_no=(select max(diner_no) from diner);

                        ---------------------------
                        --      arg_table_no     --
                        ---------------------------

-- invalid table (assuming table number 99 does not exist)
var new_diner_no number
exec it_food.add_diner(0,1,sysdate,99,:new_diner_no);
print new_diner_no

-- invalid table (table number 100 exceeds the maximum allowed precision and does not exist)
var new_diner_no number
exec it_food.add_diner(0,1,sysdate,100,:new_diner_no);
print new_diner_no

-- valid table (assuming table number 2 exists in the database)
var new_diner_no number
exec it_food.add_diner(1,4,sysdate,2,:new_diner_no);
print new_diner_no
select * from diner
where diner_no=(select max(diner_no) from diner);

--------------------------------------------------------------------------------
                                --add_order--
--------------------------------------------------------------------------------
--  procedure add_order(
--      arg_diner_no           in fs_diner.diner_no%type,
--      arg_food_item_no       in fs_diner.food_item_no%type,
--      arg_food_serve_size    in fs_diner.food_serve_size%type,
--      arg_fs_diner_no_serves in fs_diner.fs_diner_no_serves%type,
--      arg_order_success out char );

                        ---------------------------
                        --      arg_diner_no     --
                        ---------------------------

-- invalid diner (assuming diner number 9999 does not exist) --
var message char
exec it_food.add_order(9999,1,'ST',1,:message);
print message

-- invalid diner (diner number 100000000 exceeds the maximum allowed precision and does not exist) --
var message char
exec it_food.add_order(100000000,1,'ST',1,:message);
print message

-- valid diner (assuming diner number 1 exists in the database)
var message char
exec it_food.add_order(1,1,'ST',1,:message);
print message
select * from fs_diner
where diner_no=1
and food_item_no=1
and food_serve_size='ST';

                        ---------------------------
                        --    arg_food_item_no   --
                        ---------------------------
                        
-- invalid food item (assuming food item number 9999 does not exist) --
var message char
exec it_food.add_order(101,9999,'ST',1,:message);
print message

-- invalid food item (food item number 10000 exceeds the maximum allowed precision and does not exist) --
var message char
exec it_food.add_order(101,10000,'ST',1,:message);
print message

-- valid food item (assuming food item number 1 exists in the database)
var message char
exec it_food.add_order(101,1,'ST',1,:message);
print message
select * from fs_diner
where diner_no=101
and food_item_no=1
and food_serve_size='ST';

                        ---------------------------
                        --  arg_food_serve_size  --
                        ---------------------------

-- invalid food serve size (food serve size is an empty string (null))
var message char
exec it_food.add_order(201,3,'',1,:message);
print message
                        
-- invalid food serve size 'sm'
var message char
exec it_food.add_order(201,3,'sm',1,:message);
print message

-- invalid food serve size 'st'
var message char
exec it_food.add_order(201,3,'st',1,:message);
print message

-- invalid food serve size 'lg'
var message char
exec it_food.add_order(201,3,'lg',1,:message);
print message

-- invalid food serve size '123'
var message char
exec it_food.add_order(201,3,'123',1,:message);
print message

-- invalid food serve size 'SM' (food type 'B')
var message char
exec it_food.add_order(201,1,'SM',1,:message);
print message

-- invalid food serve size 'LG' (food type 'B')
var message char
exec it_food.add_order(201,1,'LG',1,:message);
print message

-- invalid food serve size 'SM' (food type 'E')
var message char
exec it_food.add_order(201,2,'SM',1,:message);
print message

-- invalid food serve size 'LG' (food type 'E')
var message char
exec it_food.add_order(201,2,'LG',1,:message);
print message

-- invalid food serve size 'SM' (food type 'D')
var message char
exec it_food.add_order(201,4,'SM',1,:message);
print message

-- invalid food serve size 'LG' (food type 'D')
var message char
exec it_food.add_order(201,4,'LG',1,:message);
print message

-- valid food serve size (food type 'B' (ST))
var message char
exec it_food.add_order(201,1,'ST',1,:message);
print message
select * from fs_diner
where diner_no=201
and food_item_no=1
and food_serve_size='ST';

-- valid food serve size (food type 'E' (ST))
var message char
exec it_food.add_order(201,2,'ST',1,:message);
print message
select * from fs_diner
where diner_no=201
and food_item_no=2
and food_serve_size='ST';

-- valid food serve size (food type 'M' (SM,ST,LG))
var message char
exec it_food.add_order(201,3,'SM',1,:message);
print message
select * from fs_diner
where diner_no=201
and food_item_no=3
and food_serve_size='SM';

-- valid food serve size (food type 'M' (SM,ST,LG))
var message char
exec it_food.add_order(201,3,'ST',1,:message);
print message
select * from fs_diner
where diner_no=201
and food_item_no=3
and food_serve_size='ST';

-- valid food serve size (food type 'M' (SM,ST,LG))
var message char
exec it_food.add_order(201,3,'LG',1,:message);
print message
select * from fs_diner
where diner_no=201
and food_item_no=3
and food_serve_size='LG';

-- valid food serve size (food type 'D' (ST))
var message char
exec it_food.add_order(201,4,'ST',1,:message);
print message
select * from fs_diner
where diner_no=201
and food_item_no=4
and food_serve_size='ST';

                        ----------------------------
                        -- arg_fs_diner_no_serves --
                        ----------------------------

-- invalid number of serves (number of serves <= 0)
var message char
exec it_food.add_order(301,1,'ST',0,:message);
print message

-- invalid number of serves (number of serves <= 0)
var message char
exec it_food.add_order(301,1,'ST',-1,:message);
print message

-- invalid number of serves (number of serves >= 10)
var message char
exec it_food.add_order(301,1,'ST',10,:message);
print message

-- invalid number of serves (number of serves >= 10)
var message char
exec it_food.add_order(301,1,'ST',11,:message);
print message

-- valid number of serves (number of serves >= 1 && number of serves < 10)
var message char
exec it_food.add_order(301,1,'ST',5,:message);
print message
select * from fs_diner
where diner_no=301
and food_item_no=1
and food_serve_size='ST';
  
--------------------------------------------------------------------------------
                                --add_fooditem--
--------------------------------------------------------------------------------
--  procedure add_fooditem(
--      arg_food_name         in fooditem.food_name%type,
--      arg_food_description  in fooditem.food_description%type,
--      arg_food_type         in fooditem.food_type%type,
--      arg_relevant_data1    in char,
--      arg_relevant_data2    in char,
--      arg_food_item_no out fooditem.food_item_no%type );

                        ---------------------------
                        --      arg_food_name    --
                        ---------------------------

-- invalid food name (the length of the string exceeds the max allowed length)
var new_food_item_no number
exec it_food.add_fooditem('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'Small Bottle', 'B', '3.5', null, :new_food_item_no);
print new_food_item_no

-- invalid food name (food name is an empty string (null))
var new_food_item_no number
exec it_food.add_fooditem('', 'Small Bottle', 'B', '3.5', null, :new_food_item_no);
print new_food_item_no

-- valid food name
var new_food_item_no number
exec it_food.add_fooditem('Heineken Beer', 'Small Bottle', 'B', '3.5', null, :new_food_item_no);
print new_food_item_no
select * from fooditem
where food_item_no=(select max(food_item_no) from fooditem);
select * from beverage
where food_item_no=(select max(food_item_no) from fooditem);

                        ---------------------------
                        --  arg_food_description --
                        ---------------------------

-- invalid food description (the length of the string exceeds the max allowed length)
var new_food_item_no number
exec it_food.add_fooditem('Rice Paper Rolls', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'E', 'Y', null, :new_food_item_no);
print new_food_item_no

-- invalid food description (food description is an empty string (null))
var new_food_item_no number
exec it_food.add_fooditem('Rice Paper Rolls', '', 'E', 'Y', null, :new_food_item_no);
print new_food_item_no

-- valid food description
var new_food_item_no number
exec it_food.add_fooditem('Rice Paper Rolls', 'Chinese Cuisine', 'E', 'Y', null, :new_food_item_no);
print new_food_item_no
select * from fooditem
where food_item_no=(select max(food_item_no) from fooditem);
select * from entree
where food_item_no=(select max(food_item_no) from fooditem);

                        ---------------------------
                        --      arg_food_type    --
                        ---------------------------

-- invalid food type (food type is an empty string (null))
var new_food_item_no number
exec it_food.add_fooditem('Fried Noodle', 'Pork', '', 'N', 'N', :new_food_item_no);
print new_food_item_no

-- invalid food type 'b'
var new_food_item_no number
exec it_food.add_fooditem('Fried Noodle', 'Pork', 'b', 'N', 'N', :new_food_item_no);
print new_food_item_no

-- invalid food type 'e'
var new_food_item_no number
exec it_food.add_fooditem('Fried Noodle', 'Pork', 'e', 'N', 'N', :new_food_item_no);
print new_food_item_no

-- invalid food type 'm'
var new_food_item_no number
exec it_food.add_fooditem('Fried Noodle', 'Pork', 'm', 'N', 'N', :new_food_item_no);
print new_food_item_no

-- invalid food type 'd'
var new_food_item_no number
exec it_food.add_fooditem('Fried Noodle', 'Pork', 'd', 'N', 'N', :new_food_item_no);
print new_food_item_no

-- invalid food type '123'
var new_food_item_no number
exec it_food.add_fooditem('Fried Noodle', 'Pork', '123', 'N', 'N', :new_food_item_no);
print new_food_item_no

-- valid food type 'M'
var new_food_item_no number
exec it_food.add_fooditem('Fried Noodle', 'Pork', 'M', 'N', 'N', :new_food_item_no);
print new_food_item_no
select * from fooditem
where food_item_no=(select max(food_item_no) from fooditem);
select * from main
where food_item_no=(select max(food_item_no) from fooditem);

                        ---------------------------
                        --   arg_relevant_data1  --
                        --        BEVERAGE       --
                        ---------------------------

-- invalid alcohol level (alcohol level scale exceeds the maximum allowed scale)
var new_food_item_no number
exec it_food.add_fooditem('Red Wine', 'Italy', 'B', '13.55', null, :new_food_item_no);
print new_food_item_no

-- invalid alcohol level 'abc'
var new_food_item_no number
exec it_food.add_fooditem('Red Wine', 'Italy', 'B', 'abc', null, :new_food_item_no);
print new_food_item_no

-- invalid alcohol level (alcohol level is null)
var new_food_item_no number
exec it_food.add_fooditem('Red Wine', 'Italy', 'B', '', null, :new_food_item_no);
print new_food_item_no

-- invalid alcohol level (alcohol level < 0)
var new_food_item_no number
exec it_food.add_fooditem('Red Wine', 'Italy', 'B', -1, null, :new_food_item_no);
print new_food_item_no

-- invalid alcohol level (alcohol level >= 100)
var new_food_item_no number
exec it_food.add_fooditem('Red Wine', 'Italy', 'B', 100, null, :new_food_item_no);
print new_food_item_no

-- valid alcohol level (alcohol level >=0 && alcohol level < 100)
var new_food_item_no number
exec it_food.add_fooditem('Red Wine', 'Italy', 'B', 13.5, null, :new_food_item_no);
print new_food_item_no
select * from fooditem
where food_item_no=(select max(food_item_no) from fooditem);
select * from beverage
where food_item_no=(select max(food_item_no) from fooditem);

                        ---------------------------
                        --   arg_relevant_data1  --
                        --        ENTREE         --
                        ---------------------------

-- invalid entree details value 
-- invalid entree_hot (entree_hot is an empty string (null))
var new_food_item_no number
exec it_food.add_fooditem('Chicken Corn Soup', 'Homemade', 'E', '', null, :new_food_item_no);
print new_food_item_no

-- invalid entree details value 
-- invalid entree_hot 'YES'
var new_food_item_no number
exec it_food.add_fooditem('Chicken Corn Soup', 'Homemade', 'E', 'YES', null, :new_food_item_no);
print new_food_item_no

-- valid entree details value
var new_food_item_no number
exec it_food.add_fooditem('Chicken Corn Soup', 'Homemade', 'E', 'Y', null, :new_food_item_no);
print new_food_item_no
select * from fooditem
where food_item_no=(select max(food_item_no) from fooditem);
select * from entree
where food_item_no=(select max(food_item_no) from fooditem);

                        ---------------------------
                        --   arg_relevant_data1  --
                        --        DESSERT        --
                        ---------------------------
                        
-- invalid dessert details value 
-- invalid dessert_lactose_free (dessert_lactose_free is an empty string (null))
var new_food_item_no number
exec it_food.add_fooditem('Blueberry Ice Cream', 'Cup', 'D', '', null, :new_food_item_no);
print new_food_item_no

-- invalid dessert details value 
-- invalid dessert_lactose_free 'NO'
var new_food_item_no number
exec it_food.add_fooditem('Blueberry Ice Cream', 'Cup', 'D', 'NO', null, :new_food_item_no);
print new_food_item_no

-- valid dessert details value
var new_food_item_no number
exec it_food.add_fooditem('Blueberry Ice Cream', 'Cup', 'D', 'N', null, :new_food_item_no);
print new_food_item_no
select * from fooditem
where food_item_no=(select max(food_item_no) from fooditem);
select * from dessert
where food_item_no=(select max(food_item_no) from fooditem);

                        ---------------------------
                        --   arg_relevant_data1  --
                        --   arg_relevant_data2  --
                        --         MAIN          --
                        ---------------------------

-- invalid main details value 
-- invalid main_vegetarian (main_vegetarian is an empty string (null))
var new_food_item_no number
exec it_food.add_fooditem('Salmon Teriyaki', 'Japanese', 'M', '', 'N', :new_food_item_no);
print new_food_item_no

-- invalid main details value 
-- invalid main_gluten_free (main_gluten_free is an empty string (null))
var new_food_item_no number
exec it_food.add_fooditem('Salmon Teriyaki', 'Japanese', 'M', 'N', '', :new_food_item_no);
print new_food_item_no

-- invalid main details value 
-- invalid main_vegetarian and main_gluten_free (main_vegetarian and main_gluten_free are both empty string (null))
var new_food_item_no number
exec it_food.add_fooditem('Salmon Teriyaki', 'Japanese', 'M', '', '', :new_food_item_no);
print new_food_item_no

-- invalid main details value 
-- invalid main_vegetarian 'NO'
var new_food_item_no number
exec it_food.add_fooditem('Salmon Teriyaki', 'Japanese', 'M', 'NO', 'N', :new_food_item_no);
print new_food_item_no

-- invalid main details value 
-- invalid main_gluten_free 'NO'
var new_food_item_no number
exec it_food.add_fooditem('Salmon Teriyaki', 'Japanese', 'M', 'N', 'NO', :new_food_item_no);
print new_food_item_no

-- invalid main details value 
-- invalid main_vegetarian 'NO' and invalid main_gluten_free 'NO'
var new_food_item_no number
exec it_food.add_fooditem('Salmon Teriyaki', 'Japanese', 'M', 'NO', 'NO', :new_food_item_no);
print new_food_item_no

-- valid main details value
var new_food_item_no number
exec it_food.add_fooditem('Salmon Teriyaki', 'Japanese', 'M', 'N', 'N', :new_food_item_no);
print new_food_item_no
select * from fooditem
where food_item_no=(select max(food_item_no) from fooditem);
select * from main
where food_item_no=(select max(food_item_no) from fooditem);

--------------------------------------------------------------------------------
                                --add_foodserve--
--------------------------------------------------------------------------------
--  procedure add_foodserve(
--      arg_food_item_no         in food_serve.food_item_no%type,
--      arg_food_serve_size      in food_serve.food_serve_size%type,
--      arg_food_serve_kilojules in food_serve.food_serve_kilojules%type,
--      arg_food_serve_cost      in food_serve.food_serve_cost%type,
--      arg_add_foodserve_success out char );

-- additional sample data to test and add food_serve entry 
-- because the food item numbers generated by the food item sequence are not incremented properly 
insert into fooditem values(11,'Ice Tea','Green Tea','B');
insert into fooditem values(12,'Salad','Vegan','E');
insert into fooditem values(13,'Fried Rice','Spicy','M');
insert into fooditem values(14,'Vanilla Ice Cream','Cone','D');
insert into fooditem values(15,'Ice Coffee','Cappucino','B');
insert into fooditem values(16,'Pasta','Italian','E');
insert into fooditem values(17,'Fried Chicken','Spicy','M');
commit;

                        ---------------------------
                        --    arg_food_item_no   --
                        ---------------------------
                        
-- invalid food item (assuming food item number 9999 does not exist) --
var message char
exec it_food.add_foodserve(9999,'ST',10,10,:message);
print message

-- invalid food item (food item number 10000 exceeds the maximum allowed precision and does not exist) --
var message char
exec it_food.add_foodserve(10000,'ST',10,10,:message);
print message

-- valid food item (assuming food item number 15 exists in the database)
var message char
exec it_food.add_foodserve(15,'ST',10,10,:message);
print message
select * from food_serve
where food_item_no=15
and food_serve_size='ST';

                        ---------------------------
                        --  arg_food_serve_size  --
                        ---------------------------

-- invalid food serve size (food serve size is an empty string (null))
var message char
exec it_food.add_foodserve(11,'',10,10,:message);
print message
                        
-- invalid food serve size 'sm'
var message char
exec it_food.add_foodserve(11,'sm',10,10,:message);
print message

-- invalid food serve size 'st'
var message char
exec it_food.add_foodserve(11,'st',10,10,:message);
print message

-- invalid food serve size 'lg'
var message char
exec it_food.add_foodserve(11,'lg',10,10,:message);
print message

-- invalid food serve size '123'
var message char
exec it_food.add_foodserve(11,'123',10,10,:message);
print message

-- invalid food serve size 'SM' (food type 'B')
-- check_serve_size_trigger will be executed
var message char
exec it_food.add_foodserve(11,'SM',5,5,:message);
print message

-- invalid food serve size 'LG' (food type 'B')
-- check_serve_size_trigger will be executed
var message char
exec it_food.add_foodserve(11,'LG',15,15,:message);
print message

-- invalid food serve size 'SM' (food type 'E')
-- check_serve_size_trigger will be executed
var message char
exec it_food.add_foodserve(12,'SM',5,5,:message);
print message

-- invalid food serve size 'LG' (food type 'E')
-- check_serve_size_trigger will be executed
var message char
exec it_food.add_foodserve(12,'LG',15,15,:message);
print message

-- invalid food serve size 'SM' (food type 'D')
-- check_serve_size_trigger will be executed
var message char
exec it_food.add_foodserve(14,'SM',5,5,:message);
print message

-- invalid food serve size 'LG' (food type 'D')
-- check_serve_size_trigger will be executed
var message char
exec it_food.add_foodserve(14,'LG',15,15,:message);
print message

-- valid food serve size (food type 'B' (ST))
var message char
exec it_food.add_foodserve(11,'ST',10,10,:message);
print message
select * from food_serve
where food_item_no=11
and food_serve_size='ST';

-- valid food serve size (food type 'E' (ST))
var message char
exec it_food.add_foodserve(12,'ST',10,10,:message);
print message
select * from food_serve
where food_item_no=12
and food_serve_size='ST';

-- valid food serve size (food type 'M' (SM,ST,LG))
var message char
exec it_food.add_foodserve(13,'SM',5,5,:message);
print message
select * from food_serve
where food_item_no=13
and food_serve_size='SM';

-- valid food serve size (food type 'M' (SM,ST,LG))
var message char
exec it_food.add_foodserve(13,'ST',10,10,:message);
print message
select * from food_serve
where food_item_no=13
and food_serve_size='ST';

-- valid food serve size (food type 'M' (SM,ST,LG))
var message char
exec it_food.add_foodserve(13,'LG',15,15,:message);
print message
select * from food_serve
where food_item_no=13
and food_serve_size='LG';

-- valid food serve size (food type 'D' (ST))
var message char
exec it_food.add_foodserve(14,'ST',10,10,:message);
print message
select * from food_serve
where food_item_no=14
and food_serve_size='ST';

                      ------------------------------
                      -- arg_food_serve_kilojules --
                      ------------------------------

-- invalid food serve kilojoules amount (kilojoules amount <= 0)
var message char
exec it_food.add_foodserve(16,'ST',0,10,:message);
print message

-- invalid food serve kilojoules amount (kilojoules amount <= 0)
var message char
exec it_food.add_foodserve(16,'ST',-1,10,:message);
print message

-- invalid food serve kilojoules amount (kilojoules amount >= 10000)
var message char
exec it_food.add_foodserve(16,'ST',10000,10,:message);
print message

-- valid food serve kilojoules amount (kilojoules amount >= 1 && kilojoules amount < 10000)
var message char
exec it_food.add_foodserve(16,'ST',10,10,:message);
print message
select * from food_serve
where food_item_no=16
and food_serve_size='ST';

                      ------------------------------
                      --    arg_food_serve_cost   --
                      ------------------------------

-- invalid food serve cost amount (cost amount scale exceeds the maximum allowed scale)
var message char
exec it_food.add_foodserve(17,'ST',10,10.111,:message);
print message

-- invalid food serve cost amount (cost amount <= 0)
var message char
exec it_food.add_foodserve(17,'ST',10,0,:message);
print message

-- invalid food serve cost amount (cost amount <= 0)
var message char
exec it_food.add_foodserve(17,'ST',10,-1,:message);
print message

-- invalid food serve cost amount (cost amount >= 1000)
var message char
exec it_food.add_foodserve(17,'ST',10,1000,:message);
print message

-- valid food serve cost amount (cost amount >= 1 && cost amount < 1000)
var message char
exec it_food.add_foodserve(17,'ST',10,10.15,:message);
print message
select * from food_serve
where food_item_no=17
and food_serve_size='ST';

--------------------------------------------------------------------------------
                              --get_diner_details--
--------------------------------------------------------------------------------
--  procedure get_diner_details(
--      arg_diner_no in diner.diner_no%type,
--      arg_table_no out diner.table_no%type,
--      arg_diner_seat_no out diner.diner_seat_no%type,
--      arg_diner_seated out char,
--      arg_diner_payment_due out diner.diner_payment_due%type,
--      fooditem_cursor out sys_refcursor );

                        ---------------------------
                        --      arg_diner_no     --
                        ---------------------------

-- invalid diner (assuming diner number 9999 does not exist) --
var diner_table_no number
var diner_seat_no number
var diner_seated char
var diner_payment_due number
var fooditem_details refcursor
exec it_food.get_diner_details(9999,:diner_table_no,:diner_seat_no,:diner_seated,:diner_payment_due,:fooditem_details);
print diner_table_no 
print diner_seat_no 
print diner_seated 
print diner_payment_due
print fooditem_details

-- invalid diner (diner number 100000000 exceeds the maximum allowed precision and does not exist) --
var diner_table_no number
var diner_seat_no number
var diner_seated char
var diner_payment_due number
var fooditem_details refcursor
exec it_food.get_diner_details(100000000,:diner_table_no,:diner_seat_no,:diner_seated,:diner_payment_due,:fooditem_details);
print diner_table_no 
print diner_seat_no 
print diner_seated 
print diner_payment_due
print fooditem_details

-- valid diner (assuming diner number 201 exists in the database)
var diner_table_no number
var diner_seat_no number
var diner_seated char
var diner_payment_due number
var fooditem_details refcursor
exec it_food.get_diner_details(201,:diner_table_no,:diner_seat_no,:diner_seated,:diner_payment_due,:fooditem_details);
print diner_table_no 
print diner_seat_no 
print diner_seated 
print diner_payment_due
print fooditem_details

spool off