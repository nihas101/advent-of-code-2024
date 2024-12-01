local split_str = require('lib/split_str')
local read_input = require('lib/read_input')
table.zip = require('lib/table_zip')

local function part1(xs, ys)
    local id_pairs = table.zip(xs, ys)

    local distances = {}
    for _, pair in pairs(id_pairs) do
        table.insert(distances, math.abs(pair[1] - pair[2]))
    end

    local distance_sum = 0
    for _, e in pairs(distances) do
        distance_sum = distance_sum + e
    end
    return distance_sum
end

local function part2(ids, frequency_ids)
    local frequencies = {}
    setmetatable(frequencies, {
        __index = function(_, _)
            return 0
        end
    })

    for _, freq in pairs(frequency_ids) do
        frequencies[freq] = frequencies[freq] + 1
    end

    local similarity_score = 0
    for _, e in pairs(ids) do
        local mult = frequencies[e]
        similarity_score = similarity_score + (e * mult)
    end
    return similarity_score
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

print("Part 1: " .. part1(left_ids, right_ids))
print("Part 2: " .. part2(left_ids, right_ids))
