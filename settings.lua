local defaultTypes =
"item, ammo, capsule, module, tool, repair-tool, item-with-entity-data, rail-planner, rail-signal, rail-chain-signal, gun"
local defaultNames = "barrel, iron-ore, copper-ore, coal, uranium-ore, calcite, scrap, stone, tungsten-ore"
data:extend({
    {
        type = "int-setting",
        name = "new-stack-size-multiplier",
        order = "aab",
        setting_type = "startup",
        default_value = 5,
        minimum_value = 1,
        maximum_value = 100000,
    },
    {
        type = "string-setting",
        name = "stackSize-item-types-to-change",
        order = "aac",
        setting_type = "startup",
        default_value = defaultTypes,
        allow_blank = true
    },
    {
        type = "string-setting",
        name = "stackSize-item-names-to-change",
        order = "aad",
        setting_type = "startup",
        default_value = defaultNames,
        allow_blank = true
    }

})
if mods["space-age"] then
    data:extend({
        {
            type = "double-setting",
            name = "new-weight-multiplier",
            order = "caa",
            setting_type = "startup",
            default_value = 1,
            minimum_value = 0,
            maximum_value = 100000,
        },
        {
            type = "string-setting",
            name = "weight-item-types-to-change",
            order = "cab",
            setting_type = "startup",
            default_value = defaultTypes,
            allow_blank = true
        },
        {
            type = "string-setting",
            name = "weight-item-names-to-change",
            order = "cac",
            setting_type = "startup",
            default_value = defaultNames,
            allow_blank = true
        }
    })
end
