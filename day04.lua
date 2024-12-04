local read_input = require('lib.read_input')
local split_str = require('lib.split_str')

local Day04 = {}

function Day04:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    return o
end

function Day04:solve()
    local xmas_found = 0
    for x = 1, #self.input do
        for y = 1, #self.input[x] do
            if self.input[x]:byte(y) == self.target then
                xmas_found = xmas_found + self:count_xmas(x, y)
            end
        end
    end
    return xmas_found
end

local left_match = function(input, x, y, pattern)
    if y - #pattern < 0 then
        return false
    end
    local line = input[x]
    for i = 0, #pattern - 1 do
        if line:byte(y - i) ~= pattern:byte(i + 1) then
            return false
        end
    end
    return true
end

local right_match = function(input, x, y, pattern)
    if not input[x] or (y + (#pattern - 1) > #input[x]) then
        return false
    end
    local line = input[x]
    for i = 0, #pattern - 1 do
        if line:byte(y + i) ~= pattern:byte(i + 1) then
            return false
        end
    end
    return true
end

local up_match = function(input, x, y, pattern)
    if x - #pattern < 0 then
        return false
    end
    for i = 0, #pattern - 1 do
        if input[x - i]:byte(y) ~= pattern:byte(i + 1) then
            return false
        end
    end
    return true
end

local down_match = function(input, x, y, pattern)
    if x + (#pattern - 1) > #input then
        return false
    end
    for i = 0, #pattern - 1 do
        if input[x + i]:byte(y) ~= pattern:byte(i + 1) then
            return false
        end
    end
    return true
end

local diagonal_left_up_match = function(input, x, y, pattern)
    if (not input[x] or y < 1) or (y - #pattern < 0 or x - #pattern < 0) then
        return false
    end
    for i = 0, #pattern - 1 do
        if input[x - i]:byte(y - i) ~= pattern:byte(i + 1) then
            return false
        end
    end
    return true
end

local diagonal_right_up_match = function(input, x, y, pattern)
    if (not input[x] or y < 1) or (y + (#pattern - 1) > #input[x] or x - #pattern < 0) then
        return false
    end
    for i = 0, #pattern - 1 do
        if input[x - i]:byte(y + i) ~= pattern:byte(i + 1) then
            return false
        end
    end
    return true
end

local diagonal_left_down_match = function(input, x, y, pattern)
    if (not input[x] or y > #input[x]) or (y - #pattern < 0 or x + (#pattern - 1) > #input) then
        return false
    end
    for i = 0, #pattern - 1 do
        if input[x + i]:byte(y - i) ~= pattern:byte(i + 1) then
            return false
        end
    end
    return true
end

local diagonal_right_down_match = function(input, x, y, pattern)
    if (not input[x] or y > #input[x]) or (y + (#pattern - 1) > #input[x] or x + (#pattern - 1) > #input) then
        return false
    end

    for i = 0, #pattern - 1 do
        if input[x + i]:byte(y + i) ~= pattern:byte(i + 1) then
            return false
        end
    end
    return true
end

local Part1 = Day04:new()

function Part1:new(input, pattern)
    local o = {}
    Day04.new(self, o)

    o.input = input.input
    o.pattern = pattern or "XMAS"
    o.target = o.pattern:byte(1);
    return o
end

function Part1:count_xmas(x, y)
    local xmas_found = 0
    if self.input[x]:byte(y) == self.target then
        if left_match(self.input, x, y, self.pattern) then
            xmas_found = xmas_found + 1
        end
        if diagonal_left_up_match(self.input, x, y, self.pattern) then
            xmas_found = xmas_found + 1
        end
        if up_match(self.input, x, y, self.pattern) then
            xmas_found = xmas_found + 1
        end
        if diagonal_right_up_match(self.input, x, y, self.pattern) then
            xmas_found = xmas_found + 1
        end
        if right_match(self.input, x, y, self.pattern) then
            xmas_found = xmas_found + 1
        end
        if diagonal_right_down_match(self.input, x, y, self.pattern) then
            xmas_found = xmas_found + 1
        end
        if down_match(self.input, x, y, self.pattern) then
            xmas_found = xmas_found + 1
        end
        if diagonal_left_down_match(self.input, x, y, self.pattern) then
            xmas_found = xmas_found + 1
        end
    end
    return xmas_found
end

local Part2 = Day04:new()

function Part2:new(input, pattern)
    local o = {}
    Day04.new(self, o)

    o.input = input.input
    o.pattern = pattern or "MAS"
    o.target = o.pattern:byte(2);
    return o
end

function Part2:count_xmas(x, y)
    if self.input[x]:byte(y) == self.target then
        if (diagonal_right_up_match(self.input, x + 1, y - 1, self.pattern) and
            (diagonal_left_up_match(self.input, x + 1, y + 1, self.pattern))) or
            (diagonal_right_up_match(self.input, x + 1, y - 1, self.pattern) and
                diagonal_right_down_match(self.input, x - 1, y - 1, self.pattern)) or
            (diagonal_left_down_match(self.input, x - 1, y + 1, self.pattern) and
                diagonal_right_down_match(self.input, x - 1, y - 1, self.pattern)) or
            (diagonal_left_down_match(self.input, x - 1, y + 1, self.pattern) and
                diagonal_left_up_match(self.input, x + 1, y + 1, self.pattern)) then
            return 1
        end
    end
    return 0
end

local Input = {}

function Input:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    local input = read_input("MMMSXXMASM\
MSAMXMSMSA\
AMXSXMAAMM\
MSAMASMSMX\
XMASAMXAMM\
XXAMMXXAMA\
SMSMSASXSS\
SAXAMASAAA\
MAMMMXMMMM\
MXMXAXMASX")

    local lines = split_str(input, "\n")

    o.input = lines
    return o
end

local input = Input:new()

local p1 = Part1:new(input)
print("Part 1: " .. p1:solve())

local p2 = Part2:new(input)
print("Part 2: " .. p2:solve())
