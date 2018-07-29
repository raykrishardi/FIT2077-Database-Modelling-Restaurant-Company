spool ./xml_database_output.txt

/*
RAY KRISHARDI LAYADI
RKLAY1 - 26445549 
*/

-- configure sql developer to display properly
SET LINESIZE 32000;
SET PAGESIZE 40000;
SET LONG 50000;

-- drop existing schema
BEGIN
DBMS_XMLSCHEMA.DELETESCHEMA(
   'http://fit2077.monash.edu/recipe.xsd',
   dbms_xmlschema.DELETE_CASCADE_FORCE);
END;
/

-- drop table and sequence
DROP
  TABLE fooditem_recipe CASCADE CONSTRAINTS ;
  
DROP SEQUENCE food_item_no_SEQ;

-- register binary schema
BEGIN
DBMS_XMLSCHEMA.REGISTERSCHEMA(SCHEMAURL => 'http://fit2077.monash.edu/recipe.xsd',
 schemadoc => '
 <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified">

    <!-- 
    Ray Krishardi Layadi
    rklay1 - 26445549
    18th May 2016
    -->

    <xs:element name="recipe">
        <xs:complexType>
            <xs:sequence>
                <xs:element ref="foodItem"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>

    <xs:element name="foodItem">
        <xs:complexType>
            <xs:sequence>
                <xs:element ref="foodName"/>
                <xs:element ref="foodTotalQuantity"/>
                <xs:element ref="foodServeSizeQuantity"/>
                <xs:element ref="ingredients"/>
                <xs:element ref="steps"/>
                <xs:choice>
                    <xs:element ref="webSource"/>
                    <xs:element ref="homemadeSource"/>
                </xs:choice>
            </xs:sequence>
            <xs:attribute ref="id" use="required"/>
            <xs:attribute ref="type" use="required"/>
            <xs:attribute ref="cooked" use="required"/>
        </xs:complexType>
    </xs:element>

    <xs:element name="foodName" type="nonEmptyString"/>
    <xs:element name="foodTotalQuantity">
        <xs:complexType>
            <xs:simpleContent>
                <xs:extension base="positiveDecimal">
                    <xs:attribute ref="unit" use="optional"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
    </xs:element>
    <xs:element name="foodServeSizeQuantity">
        <xs:complexType>
            <xs:sequence>
                <xs:element ref="quantity" minOccurs="1" maxOccurs="3"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
    <xs:element name="quantity">
        <xs:complexType>
            <xs:simpleContent>
                <xs:extension base="positiveDecimal">
                    <xs:attribute ref="size" use="required"/>
                    <xs:attribute ref="unit" use="optional"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
    </xs:element>
    <xs:element name="ingredients">
        <xs:complexType>
            <xs:sequence>
                <xs:element ref="ingredient" minOccurs="1" maxOccurs="unbounded"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
    <xs:element name="ingredient">
        <xs:complexType>
            <xs:sequence>
                <xs:element ref="ingredientName" minOccurs="1"/>
                <xs:element ref="ingredientAmount" minOccurs="0"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
    <xs:element name="ingredientName" type="nonEmptyString"/>
    <xs:element name="ingredientAmount">
        <xs:complexType>
            <xs:simpleContent>
                <xs:extension base="positiveDecimal">
                    <xs:attribute ref="unit" use="optional"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
    </xs:element>
    <xs:element name="steps">
        <xs:complexType>
            <xs:sequence>
                <xs:element ref="step" minOccurs="1" maxOccurs="unbounded"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
    <xs:element name="step" type="nonEmptyString"/>
    <xs:element name="webSource">
        <xs:complexType>
            <xs:simpleContent>
                <xs:extension base="validURL">
                    <xs:attribute ref="date" use="required"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
    </xs:element>
    <xs:element name="homemadeSource">
        <xs:complexType>
            <xs:simpleContent>
                <xs:extension base="nonEmptyString">
                    <xs:attribute ref="date" use="required"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
    </xs:element>


    <xs:attribute name="id" type="foodID"/>
    <xs:attribute name="type" type="foodType"/>
    <xs:attribute name="cooked" type="xs:boolean"/>
    <xs:attribute name="size" type="foodServeSize"/>
    <xs:attribute name="unit" type="validUnit"/>
    <xs:attribute name="date" type="xs:date"/>


    <xs:simpleType name="foodID">
        <xs:restriction base="xs:positiveInteger">
            <xs:pattern value="\d{1,4}"/>
        </xs:restriction>
    </xs:simpleType>
    <xs:simpleType name="foodType">
        <xs:restriction base="xs:string">
            <xs:enumeration value="Beverage"/>
            <xs:enumeration value="Entree"/>
            <xs:enumeration value="Main"/>
            <xs:enumeration value="Dessert"/>
        </xs:restriction>
    </xs:simpleType>
    <xs:simpleType name="nonEmptyString">
        <xs:restriction base="xs:string">
            <xs:minLength value="1"/>
        </xs:restriction>
    </xs:simpleType>
    <xs:simpleType name="positiveDecimal">
        <xs:restriction base="xs:decimal">
            <xs:minExclusive value="0"/>
        </xs:restriction>
    </xs:simpleType>
    <xs:simpleType name="foodServeSize">
        <xs:restriction base="xs:string">
            <xs:enumeration value="Small"/>
            <xs:enumeration value="Standard"/>
            <xs:enumeration value="Large"/>
        </xs:restriction>
    </xs:simpleType>
    <xs:simpleType name="validUnit">
        <xs:restriction base="xs:string">
            <xs:enumeration value="g"/>
            <xs:enumeration value="ml"/>
            <xs:enumeration value="cm"/>
        </xs:restriction>
    </xs:simpleType>
    <xs:simpleType name="validURL">
        <xs:restriction base="xs:anyURI">
            <xs:pattern value="https?://.+"/>
        </xs:restriction>
    </xs:simpleType>

</xs:schema>
',
 LOCAL => TRUE,
 GENTYPES => FALSE,
 GENTABLES => FALSE,
 FORCE => FALSE,
 options => DBMS_XMLSCHEMA.REGISTER_BINARYXML);
 end;
/

-- check the existence of the schema
SELECT
    schema_url,
    local,
    binary
FROM
    user_xml_schemas;

-- create XMLType column
CREATE TABLE fooditem_recipe
(food_item_no NUMBER (4) NOT NULL,
recipe XMLTYPE NOT NULL)
XMLType COLUMN recipe
XMLSCHEMA "http://fit2077.monash.edu/recipe.xsd"
ELEMENT "recipe"; 

-- food item number sequence
CREATE SEQUENCE food_item_no_SEQ START WITH 100 NOCACHE ORDER ;

-- comments on column
COMMENT ON COLUMN fooditem_recipe.food_item_no
IS
  'Identifier for a particular menu item' ;
  
COMMENT ON COLUMN fooditem_recipe.recipe
IS
  'XML document that contains recipe for a particular menu item' ;

-- define the primary key for the table
ALTER TABLE fooditem_recipe ADD CONSTRAINT fooditem_recipe_PK PRIMARY KEY ( food_item_no ) ;



-- ignore the ampersand symbol (&) that prompts for variable substitution
-- food item type 'Beverage'
set define off;
insert into fooditem_recipe values(food_item_no_SEQ.nextval,'
<!-- 
    Ray Krishardi Layadi
    rklay1 - 26445549
    14th May 2016
-->

<recipe>
    <foodItem id="100" type="Beverage" cooked="false">
        <foodName>Cranberry and orange iced tea</foodName>
        <foodTotalQuantity unit="ml">2000</foodTotalQuantity>
        <foodServeSizeQuantity>
            <quantity size="Standard" unit="ml">2000</quantity>
        </foodServeSizeQuantity>
        <ingredients>
            <ingredient>
                <ingredientName>Small orange</ingredientName>
                <ingredientAmount>1</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>English breakfast tea bags</ingredientName>
                <ingredientAmount>4</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Boling water</ingredientName>
                <ingredientAmount unit="ml">1000</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Cranberry juice</ingredientName>
                <ingredientAmount unit="ml">1000</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Caster sugar</ingredientName>
                <ingredientAmount unit="g">28.13</ingredientAmount>
            </ingredient>
        </ingredients>
        <steps>
            <step>
                <![CDATA[Use a vegetable peeler to peel the rind from the orange. 
                Use a small sharp knife to remove the white pith from the rind.]]>
            </step>
            <step>
                <![CDATA[Place the rind and tea bags in a large heatproof jug. 
                Pour over the water. 
                Set aside for 20 minutes to infuse.]]>
            </step>
            <step>
                <![CDATA[Remove the tea bags and rind, and discard. 
                Add the cranberry juice and sugar to the jug, and stir to combine.]]>
            </step>
            <step>
                <![CDATA[Cut half the orange flesh into small pieces and divide among 2 ice cube trays. 
                Pour the tea mixture among the trays. 
                Place in the freezer overnight. 
                Cover the remaining tea mixture with plastic wrap and place in the fridge to chill.]]>
            </step>
            <step>
                <![CDATA[Remove the ice cubes from the trays and place in a serving jug. 
                Pour over the tea mixture and serve.]]>
            </step>
        </steps>
        <webSource date="2016-05-14"
            >https://www.taste.com.au/recipes/18850/cranberry+and+orange+iced+tea</webSource>
    </foodItem>
</recipe>
');


-- ignore the ampersand symbol (&) that prompts for variable substitution
-- food item type 'Entree'
set define off;
insert into fooditem_recipe values(food_item_no_SEQ.nextval,'
<!-- 
    Ray Krishardi Layadi
    rklay1 - 26445549
    13th May 2016
-->

<recipe>
    <foodItem id="101" type="Entree" cooked="true">
        <foodName>Prawn and Ginger Dumplings</foodName>
        <foodTotalQuantity>30</foodTotalQuantity>
        <foodServeSizeQuantity>
            <quantity size="Standard">4</quantity>
        </foodServeSizeQuantity>
        <ingredients>
            <ingredient>
                <ingredientName>Peeled green prawns</ingredientName>
                <ingredientAmount unit="g">250</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Fresh ginger, peeled, finely grated</ingredientName>
                <ingredientAmount unit="cm">3</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Spring onions, thinly sliced</ingredientName>
                <ingredientAmount>2</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Soy sauce</ingredientName>
                <ingredientAmount unit="ml">25</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Oyster sauce</ingredientName>
                <ingredientAmount unit="ml">25</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Sesame oil</ingredientName>
                <ingredientAmount unit="ml">5</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Gow gee wrappers</ingredientName>
                <ingredientAmount>30</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Cracked black Pepper, to taste</ingredientName>
            </ingredient>
        </ingredients>
        <steps>
            <step>
                <![CDATA[Place prawns in a food processor. 
                Process until finely chopped. 
                Transfer to a medium bowl. 
                Stir in ginger, onion, soy, oyster sauce & oil.]]>
            </step>
            <step>
                <![CDATA[Place 1 Gow gee wrapper on a flat surface.
                Spoon 2 teaspoons of prawn mixture into centre of wrapper. 
                Brush edges with cold water.
                Press edges together to seal, then pleat. 
                Place on a baking paper­lined baking tray. 
                Repeat with remaining wrappers and prawn mixture, placing dumplings in a single layer on tray.]]>
            </step>
            <step>
                <![CDATA[Line a large bamboo steamer with baking paper.
                Place over a wok of simmering water.
                Place 1/3 of the dumplings in steamer (make sure they''re not touching).
                Cover. 
                Steam for 5 minutes or until wrappers are translucent and prawn mixture is cooked through.
                Transfer to a large plate. Cover to keep warm. Repeat with remaining dumplings in 2 batches.]]>
            </step>
        </steps>
        <webSource date="2016-05-13"
            >http://www.taste.com.au/recipes/40251/prawn+and+ginger+dumplings?ref=collections,starters­recipes</webSource>
    </foodItem>
</recipe>
');

-- ignore the ampersand symbol (&) that prompts for variable substitution
-- food item type 'Main'
set define off;
insert into fooditem_recipe values(food_item_no_SEQ.nextval,'
<!-- 
    Ray Krishardi Layadi
    rklay1 - 26445549
    14th May 2016
-->

<recipe>
    <foodItem id="102" type="Main" cooked="true">
        <foodName>Malaysian vegetable curry</foodName>
        <foodTotalQuantity>4</foodTotalQuantity>
        <foodServeSizeQuantity>
            <quantity size="Small">1</quantity>
            <quantity size="Standard">2</quantity>
            <quantity size="Large">4</quantity>
        </foodServeSizeQuantity>
        <ingredients>
            <ingredient>
                <ingredientName>Jar Malaysian curry paste</ingredientName>
                <ingredientAmount unit="g">185</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Medium brown onion, thinly sliced</ingredientName>
                <ingredientAmount>1</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Orange sweet potato, peeled, cut into 2.5cm pieces</ingredientName>
                <ingredientAmount unit="g">450</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Can coconut milk</ingredientName>
                <ingredientAmount unit="ml">270</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Cauliflower, cut into small florets</ingredientName>
                <ingredientAmount unit="g">450</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Green beans, trimmed, cut into 4cm pieces</ingredientName>
                <ingredientAmount unit="g">150</ingredientAmount>
            </ingredient>
        </ingredients>
        <steps>
            <step>
                <![CDATA[Heat a wok over medium-high heat. 
                Add curry paste. 
                Cook for 1 minute or until fragrant. 
                Add onion. 
                Cook, stirring, for 3 minutes or until softened. 
                Add sweet potato and coconut milk. 
                Bring to the boil. 
                Reduce heat to low. 
                Cover. 
                Simmer for 5 minutes or until slightly thickened.]]>
            </step>
            <step>
                <![CDATA[Add cauliflower and 1/3 cup cold water. 
                Cover. 
                Cook, stirring occasionally for 12 minutes or until vegetables are tender. 
                Add beans. 
                Cook for 4 minutes or until beans are bright green and tender. 
                Serve.]]>
            </step>
        </steps>
        <webSource date="2016-05-14"
            >http://www.taste.com.au/recipes/24930/malaysian+vegetable+curry</webSource>
    </foodItem>
</recipe>
');

-- ignore the ampersand symbol (&) that prompts for variable substitution
-- food item type 'Dessert'
set define off;
insert into fooditem_recipe values(food_item_no_SEQ.nextval,'
<!-- 
    Ray Krishardi Layadi
    rklay1 - 26445549
    14th May 2016
-->

<recipe>
    <foodItem id="103" type="Dessert" cooked="false">
        <foodName>Apple crumble</foodName>
        <foodTotalQuantity unit="g">1300</foodTotalQuantity>
        <foodServeSizeQuantity>
            <quantity size="Standard" unit="g">1300</quantity>
        </foodServeSizeQuantity>
        <ingredients>
            <ingredient>
                <ingredientName>Plain flour</ingredientName>
                <ingredientAmount unit="g">150</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Brown sugar</ingredientName>
                <ingredientAmount unit="g">100</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Chilled butter, chopped</ingredientName>
                <ingredientAmount unit="g">100</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Rolled oats</ingredientName>
                <ingredientAmount unit="g">50</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Chopped walnuts</ingredientName>
                <ingredientAmount unit="g">60</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Can baker''s apple</ingredientName>
                <ingredientAmount unit="g">800</ingredientAmount>
            </ingredient>
            <ingredient>
                <ingredientName>Vanilla ice-cream, to serve</ingredientName>
            </ingredient>
        </ingredients>
        <steps>
            <step>
                <![CDATA[Preheat oven to 180°C. 
                Combine the flour, sugar, butter and oats in a bowl.]]>
            </step>
            <step>
                <![CDATA[Use your fingertips to rub the butter into the flour mixture until the mixture resembles fine breadcrumbs. 
                Stir in the walnuts.]]>
            </step>
            <step>
                <![CDATA[Spoon the apple into a 1.5L (6-cup) capacity ovenproof dish. 
                Scatter the walnut mixture evenly over the apples. 
                Bake in oven for 20-25 minutes or until golden. 
                Spoon the apple crumble into serving bowls. 
                Serve with ice-cream.]]>
            </step>
        </steps>
        <homemadeSource date="2016-05-14">Tracy Rutherford</homemadeSource>
    </foodItem>
</recipe>
');

commit;

-- check the existence of the records
select * from fooditem_recipe
order by food_item_no;

spool off