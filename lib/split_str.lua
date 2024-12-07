local function global_match(input, sep)
    if sep == nil then
        sep = "%s"
    end
    local matches = {}
    for str in string.gmatch(input, sep) do
        table.insert(matches, str)
    end
    return matches
end

local function split(input, sep)
    if sep == nil then
        sep = "%s"
    end
    return global_match(input, "([^" .. sep .. "]+)")
end

return {
    split = split,
    global_match = global_match
}
