local read_input = require('lib.read_input')

local Day03 = {}

function Day03:new(o, program)
    o = o or {}
    program = program or ""

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    local numbers = {}
    for n1, n2 in string.gmatch(program, "mul%((%d+),(%d+)%)") do
        table.insert(numbers, {n1, n2})
    end

    o.numbers = numbers
    return o
end

function Day03:solve()
    local result = 0
    for _, n in pairs(self.numbers) do
        result = result + (n[1] * n[2])
    end
    return result
end

local Part1 = Day03:new()

function Part1:new(input)
    local o = {}
    Day03.new(self, o, input.program)
    return o
end

local Part2 = Day03:new()

function Part2:new(input)
    local o = {}
    -- Remove disabled sections
    local program = string.gsub(input.program, "don't%(%)(.-)do%(%)", "")
    Day03.new(self, o, program)
    return o
end

local Input = {}

function Input:new(n)
    local o = {}
    n = n or 1

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    if n == 1 then
        o.program = read_input("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
    else
        o.program = read_input("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
    end

    return o
end

local p1 = Part1:new(Input:new(1))
print("Part 1: " .. p1:solve())

local p2 = Part2:new(Input:new(2))
print("Part 2: " .. p2:solve())