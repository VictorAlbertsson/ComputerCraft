-- Currently does not return the computed values
-- NOTE Havent tested this function yet
function call(f, count)
    for i = 1, count do
	f()
    end
end

function split(str, sep)
    if sep == nil then
	sep = "%s"
    end
    local t = {}
    for str in string.gmatch(str, "([^" .. sep .. "]+)") do
	table.insert(t, str)
    end
    return t
end
