local function split_exact(input, sep)
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
    return split_exact(input, "([^" .. sep .. "]+)")
end

return {
    split = split,
    split_exact = split_exact
}
