local read_input = require('lib.read_input')
local str = require('lib.split_str')

local Day05 = {}

function Day05:new(o, input)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    o.input = (input and input.input) or {}
    return o
end

local Part1 = Day05:new()

function Part1:new(input)
    local o = {}
    Day05.new(self, o, input)

    return o
end

function Day05:is_sorted(n, closures)
    for i = 1, #n do
        for j = i + 1, #n do
            if closures[n[j]] and closures[n[j]][n[i]] then
                return false
            end
        end
    end
    return true
end

function Day05:sorted(n, closures)
    for i = 1, #n do
        for j = i + 1, #n do
            if closures[n[j]] and closures[n[j]][n[i]] then
                n[j], n[i] = n[i], n[j]
            end
        end
    end
end

function Part1:solve()
    local sorted_count = 0
    for _, n in pairs(self.input.numbers) do
        if self:is_sorted(n, self.input.rules) then
            sorted_count = sorted_count + n[math.floor((#n / 2) + 0.5)]
        end
    end
    return sorted_count
end

local Part2 = Day05:new()

function Part2:new(input)
    local o = {}
    Day05.new(self, o, input)

    return o
end

function Part2:solve()
    local sorted_count = 0
    for _, n in pairs(self.input.numbers) do
        if not self:is_sorted(n, self.input.rules) then
            self:sorted(n, self.input.rules)
            sorted_count = sorted_count + n[math.floor((#n / 2) + 0.5)]
        end
    end
    return sorted_count
end

local Input = {}

function Input:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    local input = read_input("47|53\
97|13\
97|61\
97|47\
75|29\
61|13\
75|53\
29|13\
97|29\
53|29\
61|53\
97|53\
61|29\
47|13\
75|47\
97|75\
47|61\
75|61\
47|29\
75|13\
53|13\
\
75,47,61,53,29\
97,61,53,29,13\
75,29,13\
75,97,47,61,53\
61,13,29\
97,13,75,29,47\
") .. "\n"

    local sections = str.global_match(input, "(.-)\n\n")
    local rules = str.split(sections[1], "(.-)\n")

    local rule_map = {}
    for _, v in pairs(rules) do
        local t = str.split(v, "|")
        rule_map[t[1]] = rule_map[t[1]] or {}
        rule_map[t[1]][t[2]] = true
    end

    local pages = str.split(sections[2], "(.-)\n")
    local page_numbers = {}
    for _, v in pairs(pages) do
        table.insert(page_numbers, str.split(v, ","))
    end

    o.input = {
        rules = rule_map,
        numbers = page_numbers
    }
    return o
end

local input = Input:new()

local p1 = Part1:new(input)
print("Part 1: " .. p1:solve())

local p2 = Part2:new(input)
print("Part 2: " .. p2:solve())