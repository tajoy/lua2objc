local api = import('api.init')

local class = {
	__cache_class = {},
	__cache_method_list = {},
}
local CLASS = getmetatable(class) or {}

function class.getClassByCached(cls_name)
	if class.__cache_class[cls_name] == nil then
		class.__cache_class[cls_name] = api.objc.getClass(cls_name)
	end
	return class.__cache_class[cls_name]
end

function class.lookupMethodInherited(cls, method_name)
	local method_list = cls:getMethodList()
	for i, v in pairs(method_list) do
		local sel = v:getName()
		if sel ~= nil then
			local this_method_name = sel:getName()
			-- print('lookup method: ', this_method_name)
			if this_method_name and this_method_name ~= '<null selector>' and this_method_name == method_name then
				return v
			end
		end
	end
	-- print('super_cls')
	local super_cls = cls:getSuperClass()
	if super_cls then
		return class.lookupMethodInherited(super_cls, method_name)
	end
	return nil
end

function class.getMethodByCached(cls_name, method_name)
	method_name = convertMethodName(method_name)
	if class.__cache_method_list[cls_name] == nil then
		class.__cache_method_list[cls_name] = {}
	end
	if class.__cache_method_list[cls_name][method_name] == nil then
		local cls = class.getClassByCached(cls_name)
		local method = class.lookupMethodInherited(cls, method_name)
		class.__cache_method_list[cls_name][method_name] = method
		return method
	end
	return class.__cache_method_list[cls_name][method_name]
end

function CLASS.__call(self, cls_name, super_name, ...)
	local arg = {...}
	if super_name == nil then
		super_name = 'NSObject'
	end
	-- FIXME: check nil
	local _cls = class.getClassByCached(cls_name)
	-- FIXME: check nil
	local _super_cls = class.getClassByCached(super_name)
	local cls = {
		__cls_name = cls_name,
		__cls = _cls,
		__super_cls_name = super_name,
		__super_cls = _super_cls,
		__cache_methods = {},
	}
	function cls:_(self, ...)
		return self
	end
	setmetatable(cls, {
		__index = function(self, name)
			if cls.__cache_methods[name] == nil then
				local method = class.getMethodByCached(cls.__cls_name, name)
				print(method)
				if method == nil then
					return nil
				end
				cls.__cache_methods[name] = function(self, ...)
					local args = {...}
					return callMethod(cls.__cls, method, args)
				end
				cls[name] = cls.__cache_methods[name]
			end
			return cls.__cache_methods[name]
		end,
	})
	return cls
end

setmetatable(class, CLASS)
return class