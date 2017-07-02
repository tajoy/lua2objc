local api = import('api.init')

local class = {}



local CLASS = getmetatable(class) or {}
function CLASS.__call(cls_name, super_name)
end




setmetatable(class, CLASS)
return class