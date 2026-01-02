local _, SDT = ...

SDT.L = SDT.L or {}
local L = SDT.L

if not getmetatable(L) then
    setmetatable(L, {
        __index = function(_, key)
            return key
        end
    })
end
