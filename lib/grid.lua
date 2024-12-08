local Grid = {}

local DEFAULT_SKIP = "."
local function from_lines(o, lines, handler, skip)
    skip = skip or DEFAULT_SKIP:byte(1)

    for x, line in pairs(lines) do
        for y = 1, #line do
            if line:byte(y) ~= skip then
                handler(o, x, y, line)
            end
        end
    end
end

function Grid:new(o, lines, handler, state)
    o.parent = self
    setmetatable(o, self)
    self.__index = self

    o.handler = handler
    o.state = state or {}
    o.grid = {}
    o.dimensions = {
        width = #lines[1],
        height = #lines
    }
    from_lines(o, lines, handler)
    return o
end

function Grid:get_value(x, y)
    return self.grid[x] and self.grid[x][y]
end

function Grid:set_value(x, y, value)
    self.grid[x] = self.grid[x] or {}
    self.grid[x][y] = value
end

function Grid:is_out_of_bounds(pos)
    local d = self.dimensions
    return pos.x < 1 or d.height < pos.x or pos.y < 1 or d.width < pos.y
end

return Grid