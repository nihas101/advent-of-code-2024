local read_input = require('lib.read_input')

local Day09 = {}

function Day09:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    return o
end

local Part1 = Day09:new()

function Part1:new(input)
    local o = {}
    Day09.new(self, o)

    return o
end

function Part1:solve()
    return 0
end

local Part2 = Day09:new()

function Part2:new(input)
    local o = {}
    Day09.new(self, o)

    return o
end

function Part2:solve()
    return 0
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