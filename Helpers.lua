function isEmpty(test)
    return test == nil or test == ''
end

function getRandomElementFromTable(tbl)
    local keys = {}
    -- Populate the 'keys' table with the named keys from 'tbl'
    for k in pairs(tbl) do
        table.insert(keys, k)
    end

    -- If the table is empty, return nil
    if #keys == 0 then
        return nil
    end

    -- Get a random index from the 'keys' table
    local randomIndex = math.random(1, #keys)
    -- Get the random key
    local randomKey = keys[randomIndex]
    -- Return the value associated with the random key from the original table
    return tbl[randomKey]
end