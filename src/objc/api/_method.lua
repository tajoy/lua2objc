import('api._header')

local ffi = require('ffi')

local _Method = {}
local Method = {}

ffi.cdef[[
SEL method_getName(Method m);
]]
function _Method:getName()
	return ffi.C.method_getName(self)
end

function _Method:__tostring(other)
	local sel = self:getName()
	local name = 'unknown'
	if sel then
		name = sel:getName()
	end
	return 'Method<' .. name .. '>'
end
function _Method:__concat(other)
	return tostring(self) .. tostring(other)
end

ffi.cdef[[
IMP method_getImplementation(Method m);
]]
function _Method:getImplementation()
	return ffi.C.method_getImplementation(self)
end

ffi.cdef[[
const char *method_getTypeEncoding(Method m);
]]
function _Method:getTypeEncoding()
	return ffi.string(ffi.C.method_getTypeEncoding(self))
end

ffi.cdef[[
unsigned int method_getNumberOfArguments(Method m);
]]
function _Method:getNumberOfArguments()
	return ffi.C.method_getNumberOfArguments(self)
end

-- API-RENAME : method_copyReturnType class:getReturnType
ffi.cdef[[
char *method_copyReturnType(Method m);
]]
function _Method:getReturnType()
	return ffi.string(ffi.gc(ffi.C.method_copyReturnType(self), ffi.C.free))
end

-- API-RENAME : method_copyArgumentType class:getArgumentType
ffi.cdef[[
char *method_copyArgumentType(Method m, unsigned int index);
]]
function _Method:getArgumentType(index)
	index = checkNumberArg(index)
	local ret = ffi.C.method_copyArgumentType(self, index)
	if ret == nil then
		return nil
	end
	return ffi.string(ffi.gc(ret, ffi.C.free))
end

-- API-IGNORE : method_getReturnType
-- the rename reason is duplicate with method:getReturnType
-- API-IGNORE : method_getArgumentType
-- the rename reason is duplicate with method:getArgumentType
-- ffi.cdef[[
-- void method_getReturnType(Method m, char *dst, size_t dst_len);
-- void method_getArgumentType(Method m, unsigned int index, char *dst, size_t dst_len);
-- ]]

ffi.cdef[[
struct objc_method_description *method_getDescription(Method m);
]]
function _Method:getDescription()
	local desc = ffi.C.method_getDescription(self)
	if desc == nil then
		return nil
	end
	return {
		name = desc.name,
		types = ffi.string(desc.types),
	}
end

ffi.cdef[[
IMP method_setImplementation(Method m, IMP imp);
]]
function _Method:setImplementation(imp)
	imp = checkArg('IMP', imp)
	return ffi.C.method_setImplementation(self, imp)
end

ffi.cdef[[
void method_exchangeImplementations(Method m1, Method m2);
]]
function _Method:exchangeImplementations(other)
	other = checkArg('Method', other)
	ffi.C.method_exchangeImplementations(self, other)
end

-- API-IGNORE: method_getSizeOfArguments
-- dlsym(RTLD_DEFAULT, method_getSizeOfArguments): symbol not found
-- ffi.cdef[[
-- unsigned int method_getSizeOfArguments(Method m);
-- ]]
-- function _Method:getSizeOfArguments()
-- 	return ffi.C.method_getSizeOfArguments(self)
-- end

-- API-IGNORE: method_getArgumentInfo
-- dlsym(RTLD_DEFAULT, method_getArgumentInfo): symbol not found
-- ffi.cdef[[
-- unsigned method_getArgumentInfo(Method m, int arg, const char **type, int *offset);
-- ]]
-- function _Method:getArgumentInfo(arg)
-- 	arg = checkNumberArg(arg)
-- 	local p_type = ffi.new('const char *[1]')
-- 	local p_offset = ffi.new('int[1]')
-- 	local ret = ffi.C.method_getArgumentInfo(self, arg, p_type, p_offset)
-- 	return ret, ffi.string(p_type[0]), tonumber(p_offset[0])
-- end

return exportWithMetaTable(Method, _Method, 'Method')

