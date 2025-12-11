local ____lualib = require("lualib_bundle")
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
function ____exports.isEmpty(test)
    return test == nil or test == nil
end
--- Returns a random value from a TypeScript enum.
-- 
-- @param anEnum The enum object (e.g., Color, LoadBalancingPolicy).
-- @returns A random value of the enum's value type.
function ____exports.getRandomElementFromEnum(anEnum)
    local enumValues = __TS__ObjectValues(anEnum)
    local relevantValues = __TS__ArrayFilter(
        enumValues,
        function(____, value) return type(value) ~= "number" end
    )
    local randomIndex = math.floor(math.random() * #relevantValues)
    return relevantValues[randomIndex + 1]
end
function ____exports.getRandomElementFromArray(arr)
    if #arr == 0 then
        return
    end
    local randomIndex = math.floor(math.random() * #arr)
    return arr[randomIndex + 1]
end
function ____exports.exhaustiveGuard(value)
    error(
        __TS__New(
            Error,
            "ERROR! Reached forbidden guard function with unexpected value: " .. JSON:stringify(value)
        ),
        0
    )
end
return ____exports
