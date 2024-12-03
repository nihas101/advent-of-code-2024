local read_input = require('lib.read_input')

local Day12 = {}

function Day12:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    return o
end

local Part1 = Day12:new()

function Part1:new(input)
    local o = {}
    Day12.new(self, o)

    return o
end

local Part2 = Day12:new()

function Part2:new(input)
    local o = {}
    Day12.new(self, o)

    return o
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