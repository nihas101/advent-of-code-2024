local function read_file(file)
    local f = io.open(file, "rb")
    if not f then
        return nil
    end
    local content = f:read "*a"
    f:close()
    return content
end

return read_file
