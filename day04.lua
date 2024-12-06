local read_input = require('lib.read_input')
local str = require('lib.split_str')

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

local Matcher = {}

function Matcher:new(pattern)
    local o = {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    o.pattern = pattern
    return o
end

function Matcher:matches(input, x, y)
    if self:invalid_position(input, x, y) then
        return false
    end
    for i = 0, #self.pattern - 1 do
        if self:pattern_does_not_match_at(input, x, y, i) then
            return false
        end
    end
    return true
end

local LeftMatcher = Matcher:new()

function LeftMatcher:invalid_position(_, _, y)
    return y - #self.pattern < 0
end

function LeftMatcher:pattern_does_not_match_at(input, x, y, i)
    return input[x]:byte(y - i) ~= self.pattern:byte(i + 1)
end

local RightMatcher = Matcher:new()

function RightMatcher:invalid_position(input, x, y)
    return not input[x] or (y + (#self.pattern - 1) > #input[x])
end

function RightMatcher:pattern_does_not_match_at(input, x, y, i)
    return input[x]:byte(y + i) ~= self.pattern:byte(i + 1)
end

local UpMatcher = Matcher:new()

function UpMatcher:invalid_position(_, x, _)
    return x - #self.pattern < 0
end

function UpMatcher:pattern_does_not_match_at(input, x, y, i)
    return input[x - i]:byte(y) ~= self.pattern:byte(i + 1)
end

local DownMatcher = Matcher:new()

function DownMatcher:invalid_position(input, x, _)
    return x + (#self.pattern - 1) > #input
end

function DownMatcher:pattern_does_not_match_at(input, x, y, i)
    return input[x + i]:byte(y) ~= self.pattern:byte(i + 1)
end

local LeftUpMatcher = Matcher:new()

function LeftUpMatcher:invalid_position(input, x, y)
    return (not input[x] or y < 1)
    or (y - #self.pattern < 0 or x - #self.pattern < 0)
end

function LeftUpMatcher:pattern_does_not_match_at(input, x, y, i)
    return input[x - i]:byte(y - i) ~= self.pattern:byte(i + 1)
end

local RightUpMatcher = Matcher:new()

function RightUpMatcher:invalid_position(input, x, y)
    return (not input[x] or y < 1)
    or (y + (#self.pattern - 1) > #input[x] or x - #self.pattern < 0)
end

function RightUpMatcher:pattern_does_not_match_at(input, x, y, i)
    return input[x - i]:byte(y + i) ~= self.pattern:byte(i + 1)
end

local LeftDownMatcher = Matcher:new()

function LeftDownMatcher:invalid_position(input, x, y)
    return (not input[x] or y > #input[x])
    or (y - #self.pattern < 0 or x + (#self.pattern - 1) > #input)
end

function LeftDownMatcher:pattern_does_not_match_at(input, x, y, i)
    return input[x + i]:byte(y - i) ~= self.pattern:byte(i + 1)
end

local RightDownMatcher = Matcher:new()

function RightDownMatcher:invalid_position(input, x, y)
    return (not input[x] or y > #input[x])
    or (y + (#self.pattern - 1) > #input[x] or x + (#self.pattern - 1) > #input)
end

function RightDownMatcher:pattern_does_not_match_at(input, x, y, i)
    return input[x + i]:byte(y + i) ~= self.pattern:byte(i + 1)
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
    local matchers = {
        LeftMatcher:new(self.pattern),
        RightMatcher:new(self.pattern),
        UpMatcher:new(self.pattern),
        DownMatcher:new(self.pattern),
        LeftUpMatcher:new(self.pattern),
        RightUpMatcher:new(self.pattern),
        LeftDownMatcher:new(self.pattern),
        RightDownMatcher:new(self.pattern)
    }

    local xmas_found = 0
    if self.input[x]:byte(y) == self.target then
        for _, matcher in pairs(matchers) do
            if matcher:matches(self.input, x, y) then
                xmas_found = xmas_found + 1
            end
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
    local lum = LeftUpMatcher:new(self.pattern)
    local rum = RightUpMatcher:new(self.pattern)
    local ldm = LeftDownMatcher:new(self.pattern)
    local rdm = RightDownMatcher:new(self.pattern)

    if self.input[x]:byte(y) == self.target then
        if (rum:matches(self.input, x + 1, y - 1, self.pattern) and
            (lum:matches(self.input, x + 1, y + 1, self.pattern))) or
            (rum:matches(self.input, x + 1, y - 1, self.pattern) and
                rdm:matches(self.input, x - 1, y - 1, self.pattern)) or
            (ldm:matches(self.input, x - 1, y + 1, self.pattern) and
                rdm:matches(self.input, x - 1, y - 1, self.pattern)) or
            (ldm:matches(self.input, x - 1, y + 1, self.pattern) and
                lum:matches(self.input, x + 1, y + 1, self.pattern)) then
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

    local lines = str.split(input, "\n")

    o.input = lines
    return o
end

local input = Input:new()

local p1 = Part1:new(input)
print("Part 1: " .. p1:solve())

local p2 = Part2:new(input)
print("Part 2: " .. p2:solve())
