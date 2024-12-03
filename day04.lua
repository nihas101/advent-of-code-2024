local read_input = require('lib.read_input')

local Day04 = {}

function Day04:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    return o
end

local Part1 = Day04:new()

function Part1:new(input)
    local o = {}
    Day04.new(self, o)

    return o
end

function Part1:solve()

end

local Part2 = Day04:new()

function Part2:new(input)
    local o = {}
    Day04.new(self, o)

    return o
end

function Part2:solve()

end

local Input = {}

function Input:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    local input = read_input("example input here")

    return o
end

local input = Input:new()

local p1 = Part1:new(input)
print("Part 1: " .. p1:solve())

--local p2 = Part2:new(input)
--print("Part 2: " .. p2:solve())