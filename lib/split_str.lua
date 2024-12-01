local function split_str(input, sep)
    if sep == nil then
        sep = "%s"
    end
    local matches = {}
    for str in string.gmatch(input, "([^" .. sep .. "]+)") do
        table.insert(matches, str)
    end
    return matches
end

return split_str
