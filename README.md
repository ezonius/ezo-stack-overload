This mod lets you multiply the stack size and weight of items.

- General multiplier, applied to specified Item Types and Item Names (internal names)
- Both Item Types and Item Names can be specified with a multiplier specific to each.

Item Types and Item Names settings field, has the format:

` item_type=stack_size, another_item_type=stack_size`

- Entries separated by comma. 
- 'stack_size' is optional, if omitted will use multiplier above.
- Item names overwrites Item types, which overwrites the general multiplier.
- You can check item name, type, weight and a lot more while mouse-over in game and pressing CTRL + SHIFT + F.

Item Type example:

`item, ammo=100, module=10`

- Items in **item** group (https://wiki.factorio.com/Data.raw#item), will be multiplied by the multiplier set in settings
- Items in **ammo** group (https://wiki.factorio.com/Data.raw#ammo), will be multiplier by 100
- Items in **module** group (https://wiki.factorio.com/Data.raw#module), will be multiplied by 10

Same principle is applied to the Item Names settings, and the same applies to the weight settings.

Important to note that the weight multiplier is a multiplier, i.e setting the multiplier above 1 makes the weight of the item increase, and thus more expensive to put in rockets.
