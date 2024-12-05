local str = require('lib.split_str')
local read_input = require('lib.read_input')
table.zip = require('lib.table_zip')

local Day01 = {
    consumer_values = {},
    consumer = nil,
    reducer_values = {},
    reducer = nil,
    solve = nil
}
function Day01:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    return o
end

function Day01:solve()
    if not self.result then
        -- Prepare the ids for the reducer step
        for _, value in pairs(self.consumer_values) do
            self.consumer(value)
        end

        -- Reduce the state to the final result
        self.result = 0
        for _, value in pairs(self.reducer_values) do
            self.result = self.reducer(self.result, value)
        end
    end
    return self.result
end

local Part1 = Day01:new()

function Part1:new(input)
    local distances = {}
    local o = {
        consumer_values = table.zip(input.left, input.right),
        consumer = function(ids)
            table.insert(distances, math.abs(ids[1] - ids[2]))
        end,
        reducer_values = distances,
        reducer = function(distance_sum, distance)
            return distance_sum + distance
        end
    }
    Day01.new(self, o)

    return o
end

local Part2 = Day01:new()

function Part2:new(input)
    local frequencies = {}
    setmetatable(frequencies, {
        __index = function(_, _)
            return 0
        end
    })
    local o = {
        consumer_values = input.right,
        consumer = function(id)
            frequencies[id] = frequencies[id] + 1
        end,
        reducer_values = input.left,
        reducer = function(similarity_score, id)
            return similarity_score + (id * frequencies[id])
        end
    }
    Day01.new(self, o)

    return o
end

local Input = {
    left = {},
    right = {}
}

function Input:new(o)
    o = o or {
        left = {},
        right = {}
    }

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    local input = read_input("3   4\
    4   3\
    2   5\
    1   3\
    3   9\
    3   3")

    local lines = str.split(input, "\n")

    local left_ids = {};
    local right_ids = {};
    for _, value in pairs(lines) do
        local line = str.split(value, "%s")
        table.insert(left_ids, tonumber(line[1]))
        table.insert(right_ids, tonumber(line[2]))
    end

    table.sort(left_ids)
    table.sort(right_ids)

    o.left = left_ids
    o.right = right_ids

    return o
end

local input = Input:new()
local p1 = Part1:new(input)
print("Part 1: " .. p1:solve())

local p2 = Part2:new(input)
print("Part 2: " .. p2:solve())
