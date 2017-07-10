import('api._header')

-- TODO: test api bridge for this below

local ffi = require('ffi')

local SEL = {}
local _SEL = {}

ffi.cdef[[
const char *sel_getName(SEL sel);
]]
function _SEL:getName()
	return ffi.string(ffi.C.sel_getName(self))
end

function _SEL:__tostring(other)
	return 'SEL<' .. self:getName() .. '>'
end
function _SEL:__concat(other)
	return tostring(self) .. tostring(other)
end

ffi.cdef[[
BOOL sel_isMapped(SEL sel);
]]
function _SEL:isMapped()
	return toboolean(ffi.C.sel_isMapped(self))
end

ffi.cdef[[
BOOL sel_isEqual(SEL lhs, SEL rhs);
]]
function _SEL:isEqual(other)
	if not ffi.istype('SEL', other) then
		return false
	end
	return toboolean(ffi.C.sel_isEqual(self, other))
end

function _SEL:__eq(other)
	return self:isEqual(other)
end

ffi.cdef[[
SEL sel_getUid(const char *str);
]]
function SEL.getUid(str)
	str = checkStringArg(str)
	return ffi.C.sel_getUid(str)
end

ffi.cdef[[
SEL sel_registerName(const char *str);
]]
function SEL.registerName(str)
	str = checkStringArg(str)
	return ffi.C.sel_registerName(str)
end

function _SEL.__call(name)
	return SEL.registerName(name)
end

return exportWithMetaTable(SEL, _SEL, 'SEL')