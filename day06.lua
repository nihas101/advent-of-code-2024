local read_input = require('lib.read_input')
local str = require('lib.split_str')
local copy = require('lib.copy')

local Day06 = {}

function Day06:new(o, input)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    o.initial_state = (input and input.input) or {}
    o.input = copy(o.initial_state)
    return o
end

local NORTH = {
    x = -1,
    y = 0
}
local EAST = {
    x = 0,
    y = 1
}
local SOUTH = {
    x = 1,
    y = 0
}
local WEST = {
    x = 0,
    y = -1
}

function Day06:turn_guard()
    local guard = self.input.guard

    if guard.direction.x == NORTH.x and guard.direction.y == NORTH.y then
        guard.direction = EAST
    elseif guard.direction.x == EAST.x and guard.direction.y == EAST.y then
        guard.direction = SOUTH
    elseif guard.direction.x == SOUTH.x and guard.direction.y == SOUTH.y then
        guard.direction = WEST
    elseif guard.direction.x == WEST.x and guard.direction.y == WEST.y then
        guard.direction = NORTH
    end
end


function Day06:move_guard()
    local guard = self.input.guard
    local obstacles = self.input.obstacles

    for _ = 1, 4 do
        local x = guard.x + guard.direction.x
        local y = guard.y + guard.direction.y

        if obstacles[x] and obstacles[x][y] then
            self:turn_guard()
        else
            guard.x = x
            guard.y = y
            return
        end
    end
    print("Guard is boxed in and cannot move!")
end

function Day06:out_of_bounds()
    local g = self.input.guard
    local d = self.input.dimensions

    return g.x < 1 or d.height < g.x
    or g.y < 1 or d.width < g.y
end

function Day06:state_visited(res)
    local g = self.input.guard
    local gs = res.guard_states

    return gs[g.x] and gs[g.x][g.y]
        and gs[g.x][g.y][g.direction.x]
        and gs[g.x][g.y][g.direction.x][g.direction.y]
end

function Day06:visit_state(res)
    local g = self.input.guard
    local gs = res.guard_states

    gs[g.x] = gs[g.x] or {}
    gs[g.x][g.y] = gs[g.x][g.y] or {}
    gs[g.x][g.y][g.direction.x] = gs[g.x][g.y][g.direction.x] or {}
    gs[g.x][g.y][g.direction.x][g.direction.y] = true
end

function Day06:position_visited(res)
    local guard = self.input.guard
    local pos = res.positions
    return pos[guard.x] and pos[guard.x][guard.y]
end

function Day06:visit_position(res)
    local guard = self.input.guard
    local pos = res.positions
    pos[guard.x] = pos[guard.x] or {}
    pos[guard.x][guard.y] = true
end

function Day06:simulate_guard()
    local res = {
        count = 0,
        positions = {},
        guard_states = {},
        is_loop = false
    }

    while not self:out_of_bounds() do
        if self:state_visited(res) then
            res.is_loop = true
            return res
        end
        self:visit_state(res)

        if not self:position_visited(res) then
            res.count = res.count + 1
        end
        self:visit_position(res)
        self:move_guard()
    end

    return res
end

local Part1 = Day06:new()

function Part1:new(input)
    local o = {}
    Day06.new(self, o, input)

    return o
end

function Part1:solve()
    return self:simulate_guard().count
end

local Part2 = Day06:new()

function Part2:new(input)
    local o = {}
    Day06.new(self, o, input)

    return o
end

function Part2:set_obstacle(x, y, value)
    self.input.obstacles[x] = self.input.obstacles[x] or {}
    self.input.obstacles[x][y] = value
end

function Part2:solve()
    local guard = copy(self.input.guard)
    local obstacle_candidates = self:simulate_guard().positions

    local loops_found = 0
    for x, ys in pairs(obstacle_candidates) do
        for y, _ in pairs(ys) do
            if x ~= guard.x or y ~= guard.y then
                self.input.guard = copy(guard)
                self:set_obstacle(x, y, true)
                if self:simulate_guard().is_loop then
                    loops_found = loops_found + 1
                end
                self:set_obstacle(x, y, nil)
            end
        end
    end
    return loops_found
end

local Input = {}

function Input:new(o)
    o = o or {}

    o.parent = self
    setmetatable(o, self)
    self.__index = self

    local input = read_input("....#.....\
.........#\
..........\
..#.......\
.......#..\
..........\
.#..^.....\
........#.\
#.........\
......#...")

    local lines = str.split(input, "\n")

    local state = {
        guard = {},
        obstacles = {},
        dimensions = {
            width = #lines[1],
            height = #lines
        }
    }
    local obstacle = "#"
    local guard = "^"
    for x, line in pairs(lines) do
        for y = 1, #line do
            if line:byte(y) == obstacle:byte(1) then
                state.obstacles[x] = state.obstacles[x] or {}
                state.obstacles[x][y] = true
            elseif line:byte(y) == guard:byte(1) then
                state.guard = {
                    direction = NORTH,
                    x = x,
                    y = y
                }
            end
        end
    end

    o.input = state
    return o
end

local input = Input:new()

-- Part 1: 5095
local p1 = Part1:new(input)
print("Part 1: " .. p1:solve())

-- 1933
local p2 = Part2:new(input)
print("Part 2: " .. p2:solve())
