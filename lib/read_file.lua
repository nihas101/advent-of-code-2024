local function read_file(file)
    local f = io.open(file, "rb")
    if not f then
        return nil
    end
    return f:read "*a"
end

return read_file
