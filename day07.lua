local read_input = require('lib.read_input')
local str = require('lib.split_str')

local Day07 = {}

function Day07:new(o, input)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    o.equations = (input and input.input) or {}
    return o
end

local Part1 = Day07:new()

function Part1:new(input)
    local o = {}
    Day07.new(self, o, input)

    return o
end

local function plus(x, y)
    return x + y
end

local function mult(x, y)
    return x * y
end

local function concat(x, y)
    return tonumber(tostring(x) .. tostring(y))
end

function Day07:solve_equation(goal, numbers, op, idx, res)
    idx = idx or 1
    if idx > #numbers then
        return goal == res
    end
    res = op((res or 0), numbers[idx])
    if res > goal then
        return false
    end

    for _, func in pairs(self.funcs) do
        if self:solve_equation(goal, numbers, func, idx + 1, res) then
            return true
        end
    end
    return false
end

function Day07:solve()
    local res = 0
    for _, eq in pairs(self.equations) do
        if self:solve_equation(eq.test, eq.numbers, plus) then
            res = res + eq.test
        end
    end
    return res
end

function Part1:solve()
    self.funcs = { plus, mult }
    return Day07.solve(self)
end

local Part2 = Day07:new()

function Part2:new(input)
    local o = {}
    Day07.new(self, o, input)

    return o
end

function Part2:solve()
    self.funcs = { plus, mult, concat }
    return Day07.solve(self)
end

local Input = {}

local function map_to_numbers(ns)
    for k, n in ipairs(ns) do
        ns[k] = tonumber(n)
    end
    return ns
end

function Input:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    local input = read_input("190: 10 19\
3267: 81 40 27\
83: 17 5\
156: 15 6\
7290: 6 8 6 15\
161011: 16 10 13\
192: 17 8 14\
21037: 9 7 18 13\
292: 11 6 16 20")

    local eqs = str.split(input, "\n")

    local equations = {}
    for _, eq in pairs(eqs) do
        local equation = str.split(eq, ":")
        table.insert(equations, {
            test = tonumber(equation[1]),
            numbers = map_to_numbers(str.split(equation[2], " "))
        })
    end

    o.input = equations
    return o
end

local input = Input:new()

local p1 = Part1:new(input)
print("Part 1: " .. p1:solve())

local p2 = Part2:new(input)
print("Part 2: " .. p2:solve())