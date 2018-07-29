/*
RAY KRISHARDI LAYADI
RKLAY1 - 26445549
*/

--------------------------------------------------------------------------------
                                  --SAMPLE DATA--
--------------------------------------------------------------------------------

-- additional sample data for testing purposes
-- in this case, the 'Main' food type is NOT COOKED AND DOES NOT HAVE THE CORRECT FOOD ITEM NUMBER
set define off;
insert into fooditem_recipe values(1,'
<!-- 
    Ray Krishardi Layadi
    rklay1 - 26445549
    14th May 2016
-->

<recipe>
    <foodItem id="10" type="Main" cooked="false">
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

-- additional sample data for testing purposes
-- in this case, the 'Main' food type is COOKED AND DOES NOT HAVE THE CORRECT FOOD ITEM NUMBER
set define off;
insert into fooditem_recipe values(2,'
<!-- 
    Ray Krishardi Layadi
    rklay1 - 26445549
    14th May 2016
-->

<recipe>
    <foodItem id="20" type="Main" cooked="true">
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

commit;