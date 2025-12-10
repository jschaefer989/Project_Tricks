--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
function ____exports.isEmpty(test)
    return test == nil or test == nil
end
function ____exports.getRandomElementFromTable(tbl)
    local keys = {}
    for k in pairs(tbl) do
        keys[#keys + 1] = k
    end
    if #keys == 0 then
        return
    end
    local randomIndex = math.floor(math.random() * #keys)
    local randomKey = keys[randomIndex + 1]
    return tbl[randomKey]
end
function ____exports.getRandomElementFromArray(arr)
    if #arr == 0 then
        return
    end
    local randomIndex = math.floor(math.random() * #arr)
    return arr[randomIndex + 1]
end
return ____exports
