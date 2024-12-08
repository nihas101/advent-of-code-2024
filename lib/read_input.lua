local function read_file(file)
    local f = io.open(file, "rb")
    if not f then
        return nil
    end
    local content = f:read "*a"
    f:close()
    return content
end

local function read_input(fallback)
    if arg[1] == "--input" then
        return read_file("input/" .. arg[0]:gsub(".lua", ".txt"))
    else
        return fallback
    end
end

return read_input