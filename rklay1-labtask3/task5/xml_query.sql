spool ./xml_query_output.txt

/*
RAY KRISHARDI LAYADI
RKLAY1 - 26445549
*/

-- configure sql developer to display properly
set linesize 32000;
set pagesize 40000;
set long 50000;

-- task1
-- the where clause is used to ignore the results from sample data
select
  xmlelement("recipe", chr(10), xmlelement("foodName",extractvalue(recipe,
  'recipe/foodItem/foodName')),chr(10), xmlelement("url", extractvalue(recipe,
  'recipe/foodItem/webSource | recipe/foodItem/homemadeSource')),chr(10))
  "recipe"
from
  fooditem_recipe
where
  food_item_no >= 100
order by
  food_item_no;

-- task2
-- the additional sample data (food_item_no: 10) will NOT be displayed because
-- it is NOT a COOKED MAIN
-- however, additional sample data (food_item_no: 20) will be displayed
-- because
-- it is a COOKED MAIN
select
  fr.food_item_no,
  fr.recipe_name as "RECIPE NAME"
from
  fooditem_recipe,
  xmltable('recipe' passing fooditem_recipe.recipe columns food_item_no number(
  4) path '/recipe/foodItem/@id', recipe_name                           varchar
  (50) path '/recipe/foodItem/foodName' ) fr
where
  existsnode(recipe, 'recipe/foodItem[@type="Main" and @cooked="true"]') = 1
order by
  food_item_no;

-- task3
-- the additional sample data (PK VALUE: 1 and 2) will have a document
-- status
-- of 'Incorrect recipe stored [10]' and 'Incorrect recipe stored [20]'
-- because the PK VALUE does not match the food item number stored in the XML
-- document
select
  fr.food_item_no as "PK VALUE",
  extractvalue(fr.recipe,
  'recipe/foodItem/webSource/@date | recipe/foodItem/homemadeSource/@date') as
  "DATE RECIPE ADDED",
  extractvalue(fr.recipe, '/recipe/foodItem/foodName') as "RECIPE NAME",
  case
    when fi.food_item_id = fr.food_item_no
    then 'Correct recipe stored'
    else 'Incorrect recipe stored'
      || '['
      || fi.food_item_id
      || ']'
  end as "DOCUMENT STATUS"
from
  fooditem_recipe fr,
  xmltable('recipe' passing fr.recipe columns food_item_id number path
  '/recipe/foodItem/@id') fi
order by
  fr.food_item_no;

spool off