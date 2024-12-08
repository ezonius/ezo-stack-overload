---@diagnostic disable: assign-type-mismatch, param-type-mismatch
local newRequestMultiplier = settings.startup["new-request-multiplier"].value
local newStackSizeMultiplier = settings.startup["new-stack-size-multiplier"].value
local newWeightMultiplier = settings.startup["new-weight-multiplier"].value
local stackSizeItemTypesToChangeString = settings.startup["stackSize-item-types-to-change"].value
local stackSizeItemNamesToChangeString = settings.startup["stackSize-item-names-to-change"].value
local requestItemTypesToChangeString = settings.startup["request-item-types-to-change"].value
local requestItemNamesToChangeString = settings.startup["request-item-names-to-change"].value
local weightItemTypesToChangeString = settings.startup["weight-item-types-to-change"].value
local weightItemNamesToChangeString = settings.startup["weight-item-names-to-change"].value

-- Set of possible flags
local possibleFlags = { "draw-logistic-overlay", "hidden", "always-show", "hide-from-bonus-gui", "hide-from-fuel-tooltip",
    "not-stackable", "can-extend-inventory", "primary-place-result", "mod-openable", "only-in-cursor", "spawnable" }

local function tableContains(tbl, element)
    for _, value in ipairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

local function processItemFlags(item)
    if item.flags then
        for _, flag in ipairs(item.flags) do
            if tableContains(possibleFlags, flag) then
                if flag == "not-stackable" then
                    return false
                end
            end
        end
    end
    return true
end

local function parseSettingString(settingString, inputType)
    local result = {}
    for entry in settingString:gmatch("[^%s,]+") do
        local typeOrName, numeration = entry:match("([^=]+)=?(.*)")

        if typeOrName then
            result[typeOrName] = {}
            if inputType == "stack" then
                result[typeOrName].stack_size = tonumber(numeration)
            elseif inputType == "request" then
                result[typeOrName].default_request_amount = tonumber(numeration)
            elseif inputType == "weight" then
                result[typeOrName].weight = tonumber(numeration)
            end
        end
    end
    return result
end

local stackSizeItemTypesToChange = parseSettingString(stackSizeItemTypesToChangeString, "stack")
local stackSizeItemNamesToChange = parseSettingString(stackSizeItemNamesToChangeString, "stack")

local requestItemTypesToChange = parseSettingString(requestItemTypesToChangeString, "request")
local requestItemNamesToChange = parseSettingString(requestItemNamesToChangeString, "request")

local weightItemTypesToChange = parseSettingString(weightItemTypesToChangeString, "weight")
local weightItemNamesToChange = parseSettingString(weightItemNamesToChangeString, "weight")

local excludedGroups = {
    recipe = true,
    achievement = true,
    corpse = true,
    explosion = true,
    ['ambient-sound'] = true,
    ["delayed-active-trigger"] = true,
    ["noise-expression"] = true,
    ["noise-function"] = true,
    ["optimized-decorative"] = true,
    ["optimized-particle"] = true,
    ["smoke-with-trigger"] = true,
    ["technology"] = true,
    ["tile"] = true,
    ["virtual-signal"] = true,
    ["armor"] = true,
    ["deconstruction-item"] = true,
    ["upgrade-item"] = true,
    ["blueprint-book"] = true,
    ["custom-input"] = true,
    ["shortcut"] = true,
}

for itemTypeName, itemType in pairs(data.raw) do
    if excludedGroups[itemTypeName] or type(itemType) ~= "table" then
        goto nextItemType
    end

    for itemName, item in pairs(itemType) do
        if not processItemFlags(item) then
            goto nextItem
        end

        if item.stack_size then
            if stackSizeItemNamesToChange[itemName] and stackSizeItemNamesToChange[itemName].stack_size then
                --log("[1]StackSize of data.raw[" .. itemTypeName .. "]" .. "[" .. itemName .. "]" .. " changed to " .. stackSizeItemNamesToChange[itemName].stack_size)
                item.stack_size = stackSizeItemNamesToChange[itemName].stack_size
            elseif stackSizeItemTypesToChange[itemTypeName] and stackSizeItemTypesToChange[itemTypeName].stack_size then
                --log("[2]StackSize of data.raw[" ..itemTypeName .. "]" .. "[" .. itemName .. "]" .. " changed to " .. stackSizeItemTypesToChange[itemTypeName].stack_size)
                item.stack_size = stackSizeItemTypesToChange[itemTypeName].stack_size
            elseif stackSizeItemNamesToChange[itemName] or stackSizeItemTypesToChange[itemTypeName] then
                --log("[3]StackSize of data.raw[" ..itemTypeName .. "]" .. "[" .. itemName .. "]" .. " changed to " .. item.stack_size * newStackSizeMultiplier)
                item.stack_size = item.stack_size * newStackSizeMultiplier
            end
        end

        if item.stack_size and item.default_request_amount then
            if requestItemNamesToChange[itemName] and requestItemNamesToChange[itemName].default_request_amount then
                item.default_request_amount = requestItemNamesToChange[itemName].default_request_amount
            elseif requestItemTypesToChange[itemTypeName] and requestItemTypesToChange[itemTypeName].default_request_amount then
                item.default_request_amount = requestItemTypesToChange[itemTypeName].default_request_amount
            elseif requestItemNamesToChange[itemName] or requestItemTypesToChange[itemTypeName] then
                item.default_request_amount = item.default_request_amount * newRequestMultiplier
            end
        end

        if mods["space-age"] and item.weight then
            if weightItemNamesToChange[itemName] and weightItemNamesToChange[itemName].weight then
                item.weight = weightItemNamesToChange[itemName].weight
            elseif weightItemTypesToChange[itemTypeName] and weightItemTypesToChange[itemTypeName].weight then
                item.weight = weightItemTypesToChange[itemTypeName].weight
            elseif weightItemNamesToChange[itemName] or weightItemTypesToChange[itemTypeName] then
                item.weight = math.floor(item.weight * newWeightMultiplier)
            end
        end
        ::nextItem::
    end
    ::nextItemType::
end
-- SE
if mods["space-exploration"] then
    data.raw.item["rocket-fuel"].stack_size = 10
end
