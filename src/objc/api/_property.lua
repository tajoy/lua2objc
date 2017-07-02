import('api._header')

-- TODO: implement api bridge for this below

local ffi = require('ffi')
ffi.cdef[[
const char *property_getName(objc_property_t property);
const char *property_getAttributes(objc_property_t property);
objc_property_attribute_t *property_copyAttributeList(objc_property_t property, unsigned int *outCount);
char *property_copyAttributeValue(objc_property_t property, const char *attributeName);
]]