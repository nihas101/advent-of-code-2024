local read_input = require('lib.read_input')
local str = require('lib.split_str')

local Day08 = {}

function Day08:new(o, input)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    o.input = (input and input.input) or {}
    return o
end

local Part1 = Day08:new()

function Part1:new(input)
    local o = {}
    Day08.new(self, o, input)

    return o
end

function Day08:valid_position(pos)
    local width = self.input.dimensions.width
    local height = self.input.dimensions.height
    return pos[1] > 0 and pos[2] > 0 and pos[1] <= width and pos[2] <= height
end

function Day08:not_seen_yet(pos)
    return not self.seen_antinodes[pos[1]] or not self.seen_antinodes[pos[1]][pos[2]]
end

function Day08:add_to_seen(pos)
    self.seen_antinodes[pos[1]] = self.seen_antinodes[pos[1]] or {}
    self.seen_antinodes[pos[1]][pos[2]] = true
end

local function antinode_positions(a, b, scalar)
    scalar = scalar or 1
    local xs = math.abs(a[1] - b[1]) * scalar
    local ys = math.abs(a[2] - b[2]) * scalar

    if a[1] < b[1] and a[2] < b[2] then
        return {(a[1] - xs), (a[2] - ys)}, {(b[1] + xs), (b[2] + ys)}
    elseif a[1] < b[1] and a[2] > b[2] then
        return {(a[1] - xs), (a[2] + ys)}, {(b[1] + xs), (b[2] - ys)}
    elseif a[1] > b[1] and a[2] < b[2] then
        return {(a[1] + xs), (a[2] - ys)}, {(b[1] - xs), (b[2] + ys)}
    elseif a[1] > b[1] and a[2] > b[2] then
        return {(a[1] + xs), (a[2] + ys)}, {(b[1] - xs), (b[2] - ys)}
    end
end

function Day08:solve()
    if self.antinodes_count then
        return self.antinodes_count
    end

    self.antinodes_count = 0
    self.seen_antinodes = {}
    for _, pos in pairs(self.input.positions) do
        for i, p1 in pairs(pos) do
            for j = i + 1, #pos do
                local p2 = pos[j]
                self:count_antinodes(p1, p2)
            end
        end
    end

    return self.antinodes_count
end

function Day08:valid_antinode_positions(p1, p2, scalar)
    local a1, a2 = antinode_positions(p1, p2, scalar)
    local pos = {}
    if self:valid_position(a1) then
        table.insert(pos, a1)
    end
    if self:valid_position(a2) then
        table.insert(pos, a2)
    end
    return table.unpack(pos)
end

function Part1:count_antinodes(p1, p2)
    local a1, a2 = self:valid_antinode_positions(p1, p2)
    if a1 and self:not_seen_yet(a1) then
        self.antinodes_count = self.antinodes_count + 1
        self:add_to_seen(a1)
    end
    if a2 and self:not_seen_yet(a2) then
        self.antinodes_count = self.antinodes_count + 1
        self:add_to_seen(a2)
    end
end

local Part2 = Day08:new()

function Part2:new(input)
    local o = {}
    Day08.new(self, o, input)

    return o
end

function Part2:count_antinodes(p1, p2)
    local scalar = 0
    repeat
        local a1, a2 = self:valid_antinode_positions(p1, p2, scalar)
        if a1 and self:not_seen_yet(a1) then
            self.antinodes_count = self.antinodes_count + 1
            self:add_to_seen(a1)
        end
        if a2 and self:not_seen_yet(a2) then
            self.antinodes_count = self.antinodes_count + 1
            self:add_to_seen(a2)
        end
        scalar = scalar + 1
    until not a1 and not a2
end

local Input = {}

function Input:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    local input = read_input("............\
........0...\
.....0......\
.......0....\
....0.......\
......A.....\
............\
............\
........A...\
.........A..\
............\
............")

    local lines = str.split(input, "\n")

    local state = {
        antennas = {},
        positions = {},
        dimensions = {
            width = #lines[1],
            height = #lines
        }
    }
    local empty_space = "."
    for x, line in pairs(lines) do
        for y = 1, #line do
            if line:byte(y) ~= empty_space:byte(1) then
                state.antennas[x] = state.antennas[x] or {}
                state.antennas[x][y] = line:byte(y)
                state.positions[line:byte(y)] = state.positions[line:byte(y)] or {}
                table.insert(state.positions[line:byte(y)], {x, y})
            end
        end
    end

    o.input = state
    return o
end

local input = Input:new()

local p1 = Part1:new(input)
print("Part 1: " .. p1:solve())

local p2 = Part2:new(input)
print("Part 2: " .. p2:solve())
