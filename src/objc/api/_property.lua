import('api._header')

local ffi = require('ffi')

local Property = {}
local _Property = {}

ffi.cdef[[
const char *property_getName(objc_property_t property);
]]
function _Property:getName()
	return ffi.string(ffi.C.property_getName(self))
end

ffi.cdef[[
const char *property_getAttributes(objc_property_t property);
]]
function _Property:getAttributes()
	return ffi.string(ffi.C.property_getAttributes(self))
end

-- API-RENAME : property_copyAttributeList Property:getAttributeList
ffi.cdef[[
objc_property_attribute_t *property_copyAttributeList(objc_property_t property, unsigned int *outCount);
]]
function _Property:getAttributeList()
	local outCount = ffi.new('unsigned int[1]')
	local attrs = ffi.gc(ffi.C.property_copyAttributeList(self, outCount), ffi.C.free)
	local ret = {}
	for i = 0, outCount[0] - 1 do
		ret[i+1] = {
			name = attrs[i].name,
			value = attrs[i].value,
		}
	end
	return ret
end

-- API-RENAME : property_copyAttributeValue Property:getAttributeValue
ffi.cdef[[
char *property_copyAttributeValue(objc_property_t property, const char *attributeName);
]]
function _Property:getAttributeValue(attributeName)
	attributeName = checkStringArg(attributeName)
	local ret = ffi.C.property_copyAttributeValue(self, attributeName)
	if ret ~= nil then
		return ffi.string(ret)
	end
	return nil
end


return exportWithMetaTable(Property, _Property, 'objc_property_t')

