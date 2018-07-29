/*
RAY KRISHARDI LAYADI
RKLAY1 - 26445549
*/

--------------------------------------------------------------------------------
                                  --SAMPLE DATA--
--------------------------------------------------------------------------------

select * from it_table;
select * from fooditem;
select * from food_serve;
select * from beverage;
select * from entree;
select * from main;
select * from dessert;

delete from it_table;
delete from fooditem;
delete from food_serve;
delete from beverage;
delete from entree;
delete from main;
delete from dessert;

-- IT_TABLE --
insert into it_table values(1,2,'indoor');
insert into it_table values(2,4,'outdoor');
insert into it_table values(3,6,'indoor');
insert into it_table values(4,8,'outdoor');
insert into it_table values(5,10,'indoor');
commit;

-- FOODITEM --
insert into fooditem values(1,'Ice Tea','Green Tea','B');
insert into fooditem values(2,'Salad','Vegan','E');
insert into fooditem values(3,'Fried Rice','Spicy','M');
insert into fooditem values(4,'Vanilla Ice Cream','Cone','D');
insert into fooditem values(5,'Ice Coffee','Cappucino','B');
insert into fooditem values(6,'Pasta','Italian','E');
insert into fooditem values(7,'Fried Chicken','Spicy','M');
insert into fooditem values(8,'Chocolate Ice Cream','Cup','D');
insert into fooditem values(9,'Mixed Juice','Healthy','B');
insert into fooditem values(10,'Gyoza','Japanese','E');
commit;

insert into beverage values(1,0);
insert into entree values(2,'N');
insert into main values(3,'N','N');
insert into dessert values(4,'N');
insert into beverage values(5,0);
insert into entree values(6,'Y');
insert into main values(7,'N','N');
insert into dessert values(8,'N');
insert into beverage values(9,0);
insert into entree values(10,'Y');
commit;

-- FOOD_SERVE --
insert into food_serve values(1,'ST',10,10);
insert into food_serve values(2,'ST',10,10);
insert into food_serve values(3,'SM',5,5);
insert into food_serve values(3,'ST',10,10);
insert into food_serve values(3,'LG',15,15);
insert into food_serve values(4,'ST',10,10);
insert into food_serve values(5,'ST',10,10);
insert into food_serve values(6,'ST',10,10);
insert into food_serve values(7,'SM',5,5);
insert into food_serve values(7,'ST',10,10);
insert into food_serve values(7,'LG',15,15);
insert into food_serve values(8,'ST',10,10);
insert into food_serve values(9,'ST',10,10);
insert into food_serve values(10,'ST',10,10);
commit;