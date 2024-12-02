local read_input = require('lib.read_input')
local split_str = require('lib.split_str')
table.zip = require('lib.table_zip')
local Range = require('lib.range')

local SkippingRange = {}

-- Removes the specified value in the given range
function SkippingRange:new(range, skip)
    local o = {}
    setmetatable(o, {
        __index = function(_, key)
            local v = range[key]
            if skip and skip <= v then
                return range[key + 1]
            else
                return v
            end
        end
    })
    return o
end

local Day02 = {}

function Day02:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    o.safe_diffs = {}
    for _, value in pairs({-3, -2, -1, 1, 2, 3}) do
        o.safe_diffs[value] = true
    end

    return o
end

function Day02:level_unsafe(diff)
    return not self.safe_diffs[diff]
end

function Day02:diff_unsafe(last_diff, diff)
    return last_diff and ((last_diff < 0 and diff > 0) or (last_diff > 0 and diff < 0))
end

function Day02:is_safe(report, skip)
    local id1 = Range:new(1, #report + 1)
    local id2 = Range:new(2, #report + 1)
    if skip then
        id1 = SkippingRange:new(id1, math.max(skip, 1))
        id2 = SkippingRange:new(id2, math.max(skip, 2))
    end
    local idxs = table.zip(id1, id2)

    local last_diff = nil
    for i, idx in ipairs(idxs) do
        local diff = report[idx[1]] - report[idx[2]]
        if self:level_unsafe(diff) then
            return false, i
        end
        if self:diff_unsafe(last_diff, diff) then
            return false, i
        end
        last_diff = diff
    end

    return true
end

function Day02:solve()
    local safe_reports = 0
    for _, rep in pairs(self.reports) do
        if self:is_safe(rep) then
            safe_reports = safe_reports + 1
        end
    end
    return safe_reports
end

local Part1 = Day02:new()

function Part1:new(input)
    local o = {}
    Day02.new(self, o)

    o.reports = input.reports
    return o
end

local Part2 = Day02:new()

function Part2:new(input)
    local o = {}
    Day02.new(self, o)

    o.reports = input.reports
    return o
end

function Part2:is_safe(report)
    local res, idx = Day02.is_safe(self, report)
    return res
        or Day02.is_safe(self, report, idx - 1)
        or Day02.is_safe(self, report, idx)
        or Day02.is_safe(self, report, idx + 1)
end

local Input = {
    reports = {}
}

function Input:new(o)
    o = o or {
        reports = {}
    }

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    local input = read_input("7 6 4 2 1\
    1 2 7 8 9\
    9 7 6 2 1\
    1 3 2 4 5\
    8 6 4 4 1\
    1 3 6 7 9")

    local lines = split_str(input, "\n")

    local reports = {}
    for _, value in pairs(lines) do
        local lvls = split_str(value, "%s")
        local report = {}
        for _, lvl in pairs(lvls) do
            table.insert(report, tonumber(lvl))
        end
        table.insert(reports, report)
    end

    o.reports = reports
    return o
end

local input = Input:new()

local p1 = Part1:new(input)
print("Part 1: " .. p1:solve())

local p2 = Part2:new(input)
print("Part 2: " .. p2:solve())
