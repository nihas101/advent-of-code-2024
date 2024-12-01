-- Source: https://gist.github.com/w13b3/5d8a80fae57ab9d51e285f909e2862e0
local function zip(...)
    local idx, ret, args = 1, {}, {...}
    while true do -- loop smallest table-times
        local sub_table = {}
        local value
        for _, table_ in ipairs(args) do
            value = table_[idx] -- becomes nil if index is out of range
            if value == nil then
                break
            end -- break for-loop
            table.insert(sub_table, value)
        end
        if value == nil then
            break
        end -- break while-loop
        table.insert(ret, sub_table) -- insert the sub result
        idx = idx + 1
    end
    return ret
end

return zip
