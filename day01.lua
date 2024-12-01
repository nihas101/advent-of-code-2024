local split_str = require('lib/split_str')
local read_input = require('lib/read_input')
table.zip = require('lib/table_zip')

local Day01 = {
    mapfun = nil,
    redfun = nil,
    solve = nil
}
function Day01:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    return o
end

function Day01:map(source, target)
    for _, v in pairs(source) do
        self.mapfun(target, v)
    end
    return target
end

function Day01:reduce(source, target)
    for _, v in pairs(source) do
        target = self.redfun(target, v)
    end
    return target
end

local Part1 = Day01:new()

function Part1:new(xs, ys)
    local o = {
        mapfun = function(distances, pair)
            return table.insert(distances, math.abs(pair[1] - pair[2]))
        end,
        redfun = function(distance_sum, distance)
            return distance_sum + distance
        end
    }
    Day01.new(self, o)

    o.xs = xs
    o.ys = ys

    return o
end

function Part1:solve()
    local id_pairs = table.zip(self.xs, self.ys)
    local distances = self:map(id_pairs, {})
    return self:reduce(distances, 0)
end

local Part2 = Day01:new()

function Part2:new(ids, frequency_ids)
    local frequencies = {}
    setmetatable(frequencies, {
        __index = function(_, _)
            return 0
        end
    })
    local o = {
        mapfun = function(_, freq)
            frequencies[freq] = frequencies[freq] + 1
            return frequencies
        end,
        redfun = function(similarity_score, e)
            similarity_score = similarity_score + (e * frequencies[e])
            return similarity_score
        end
    }
    Day01.new(self, o)

    o.ids = ids
    o.frequency_ids = frequency_ids
    o.frequencies = frequencies

    return o
end

function Part2:solve()
    self:map(self.frequency_ids, self.frequencies)
    return self:reduce(self.ids, 0)
end

local input = read_input("3   4\
    4   3\
    2   5\
    1   3\
    3   9\
    3   3")

local lines = split_str(input, "\n")

local left_ids = {};
local right_ids = {};
for _, value in pairs(lines) do
    local line = split_str(value, "%s")
    table.insert(left_ids, tonumber(line[1]))
    table.insert(right_ids, tonumber(line[2]))
end

table.sort(left_ids)
table.sort(right_ids)

local p1 = Part1:new(left_ids, right_ids)
print("Part 1: " .. p1:solve())

local p2 = Part2:new(left_ids, right_ids)
print("Part 2: " .. p2:solve())
