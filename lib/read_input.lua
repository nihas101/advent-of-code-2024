local read_file = require('lib/read_file')

local function read_input(fallback)
    if arg[1] == "--input" then
        return read_file("input/" .. arg[0]:gsub(".lua", ".txt"))
    else
        return fallback
    end
end

return read_input