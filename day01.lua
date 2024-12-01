local split_str = require('lib/split_str')
local read_file = require('lib/read_file')
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
    local prev_element, prev_frequency = frequency_ids[1], 1
    for i = 2, #frequency_ids do
        if prev_element == frequency_ids[i] then
            prev_frequency = prev_frequency + 1
        else
            frequencies[prev_element] = prev_frequency
            prev_element, prev_frequency = frequency_ids[i], 1
        end
    end
    frequencies[prev_element] = prev_frequency

    local similarity_score = 0
    for _, e in pairs(ids) do
        local mult = frequencies[e]
        if mult == nil then
            mult = 0
        end
        similarity_score = similarity_score + (e * mult)
    end
    return similarity_score
end

local input
if arg[1] == "--input" then
    input = read_file("input/day01.txt")
else
    input = "3   4\
    4   3\
    2   5\
    1   3\
    3   9\
    3   3"
end

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
