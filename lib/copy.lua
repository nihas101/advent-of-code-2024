-- https://gist.github.com/tylerneylon/81333721109155b2d244
local function copy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[copy(k)] = copy(v) end
    return res
end

return copy