local Range = {}

function Range:new(from, to)
    local o = {}
    setmetatable(o, {
        __index = function (_, idx)
            local value = from + (idx - 1)
            if value < to then
                return value
            else
                return nil
            end
        end
    })
    return o
end

return Range