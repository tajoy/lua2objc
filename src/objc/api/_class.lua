import('api._header')

local ffi = require('ffi')
local _class = {}
local class = {}

-- TODO: implement api bridge for this below

ffi.cdef[[
const char *class_getImageName(Class cls);
]]
function _class:getImageName()
	return ffi.C.class_getImageName(self)
end

ffi.cdef[[
const char *class_getName(Class cls);
]]
function _class:getName()
	return ffi.C.class_getName(self)
end

ffi.cdef[[
BOOL class_isMetaClass(Class cls);
]]
function _class:isMetaClass()
	return toboolean(ffi.C.class_isMetaClass(self))
end

ffi.cdef[[
Class class_getSuperclass(Class cls);
]]
function _class:getSuperclass()
	return ffi.C.class_getSuperclass(self)
end

ffi.cdef[[
Class class_setSuperclass(Class cls, Class newSuper);
]]
function _class:setSuperclass(newSuper)
	newSuper = checkArg('Class', newSuper)
	return ffi.C.class_setSuperclass(self, newSuper)
end

ffi.cdef[[
int class_getVersion(Class cls);
]]
function _class:getVersion()
	return ffi.C.class_getVersion(self)
end

ffi.cdef[[
void class_setVersion(Class cls, int version);
]]
function _class:setVersion(version)
	version = checkNumberArg(version)
	return ffi.C.class_setVersion(self, version)
end

ffi.cdef[[
size_t class_getInstanceSize(Class cls);
]]
function _class:getInstanceSize()
	return ffi.C.class_getInstanceSize(self)
end

ffi.cdef[[
Ivar class_getInstanceVariable(Class cls, const char *name);
]]
function _class:getInstanceVariable(name)
	name = checkStringArg(name)
	return ffi.C.class_getInstanceVariable(self, name)
end

ffi.cdef[[
Ivar class_getClassVariable(Class cls, const char *name);
]]
function _class:getClassVariable(name)
	name = checkStringArg(name)
	return ffi.C.class_getClassVariable(self, name)
end


-- API-RENAME : class_copyIvarList class:getIvarList
ffi.cdef[[
Ivar *class_copyIvarList(Class cls, unsigned int *outCount);
]]
function _class:getIvarList()
	local outCount = ffi.new("unsigned int[1]")
	local list = ffi.gc(ffi.C.class_copyIvarList(self, outCount), ffi.C.free)
	local ret = {}
	for i = 0, outCount[1] - 1 do
		ret[i+1] = list[i]
	end
	return ret
end

ffi.cdef[[
Method class_getInstanceMethod(Class cls, SEL name);
]]
function _class:getInstanceMethod(name)
	name = checkArg('SEL', name)
	return ffi.C.class_getInstanceMethod(self, name)
end

ffi.cdef[[
Method class_getClassMethod(Class cls, SEL name);
]]
function _class:getClassMethod(name)
	name = checkArg('SEL', name)
	return ffi.C.class_getClassMethod(self, name)
end

ffi.cdef[[
IMP class_getMethodImplementation(Class cls, SEL name);
]]
function _class:getMethodImplementation(name)
	name = checkArg('SEL', name)
	return ffi.C.class_getMethodImplementation(self, name)
end

ffi.cdef[[
IMP class_getMethodImplementation_stret(Class cls, SEL name);
]]
function _class:getMethodImplementation_stret(name)
	name = checkArg('SEL', name)
	return ffi.C.class_getMethodImplementation_stret(self, name)
end

ffi.cdef[[
BOOL class_respondsToSelector(Class cls, SEL sel);
]]
function _class:respondsToSelector(sel)
	sel = checkArg('SEL', sel)
	return toboolean(ffi.C.class_respondsToSelector(self, name))
end

-- API-RENAME : class_copyMethodList class:getMethodList
ffi.cdef[[
Method *class_copyMethodList(Class cls, unsigned int *outCount);
]]
function _class:getMethodList()
	local outCount = ffi.new("unsigned int[1]")
	local list = ffi.gc(ffi.C.class_copyMethodList(self, outCount), ffi.C.free)
	local ret = {}
	for i = 0, outCount[1] - 1 do
		ret[i+1] = list[i]
	end
	return ret
end

ffi.cdef[[
BOOL class_conformsToProtocol(Class cls, Protocol *protocol);
]]
function _class:conformsToProtocol()
	protocol = checkArg('Protocol *', protocol)
	return toboolean(ffi.C.class_conformsToProtocol(self, protocol))
end

-- API-RENAME : class_copyProtocolList class:getProtocolList
ffi.cdef[[
Protocol **class_copyProtocolList(Class cls, unsigned int *outCount);
]]
function _class:getProtocolList()
	local outCount = ffi.new("unsigned int[1]")
	local list = ffi.gc(ffi.C.class_copyProtocolList(self, outCount), ffi.C.free)
	local ret = {}
	for i = 0, outCount[1] - 1 do
		ret[i+1] = list[i]
	end
	return ret
end

ffi.cdef[[
objc_property_t class_getProperty(Class cls, const char *name);
]]
function _class:getProperty()
	name = checkStringArg(name)
	return ffi.C.class_getProperty(self, name)
end

-- API-RENAME : class_copyPropertyList class:getPropertyList
ffi.cdef[[
objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount);
]]
function _class:getPropertyList()
	local outCount = ffi.new("unsigned int[1]")
	local list = ffi.gc(ffi.C.class_copyPropertyList(self, outCount), ffi.C.free)
	local ret = {}
	for i = 0, outCount[1] - 1 do
		ret[i+1] = list[i]
	end
	return ret
end

ffi.cdef[[
const uint8_t *class_getIvarLayout(Class cls);
]]
function _class:getIvarLayout()
	return ffi.C.class_getIvarLayout(self)
end

ffi.cdef[[
const uint8_t *class_getWeakIvarLayout(Class cls);
]]
function _class:getWeakIvarLayout()
	return ffi.C.class_getWeakIvarLayout(self)
end

ffi.cdef[[
BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types);
]]
function _class:addMethod(name, imp, types)
	name = checkArg('SEL', name)
	imp = checkArg('IMP', imp)
	types = checkStringArg(types)
	return toboolean(ffi.C.class_addMethod(self, name, imp, types))
end

ffi.cdef[[
IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types);
]]
function _class:replaceMethod()
	name = checkArg('SEL', name)
	imp = checkArg('IMP', imp)
	types = checkStringArg(types)
	return ffi.C.class_replaceMethod(self, name, imp, types)
end

ffi.cdef[[
BOOL class_addIvar(Class cls, const char *name, size_t size, uint8_t alignment, const char *types);
]]
function _class:addIvar()
	name = checkStringArg(name)
	size = checkNumberArg(size)
	alignment = checkNumberArg(alignment)
	types = checkStringArg(types)
	return toboolean(ffi.C.class_addIvar(self, name, size, alignment, types))
end

ffi.cdef[[
BOOL class_addProtocol(Class cls, Protocol *protocol);
]]
function _class:addProtocol()
	protocol = checkArg('Protocol *', protocol)
	return toboolean(ffi.C.class_addProtocol(self, protocol))
end

ffi.cdef[[
BOOL class_addProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount);
]]
function _class:addProperty(name, attributes)
	name = checkStringArg(name)
	attributes = checkArrayArg('objc_property_attribute_t', attributes)
	if #attributes <= 0 then
		return ffi.C.class_addProperty(self, name, nil, 0)
	end
	local attrs = ffi.new('objc_property_attribute_t[?]', #attributes)
	return toboolean(ffi.C.class_addProperty(self, name, attrs, #attributes))
end

ffi.cdef[[
void class_replaceProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount);
]]
function _class:replaceProperty(name, attributes)
	name = checkStringArg(name)
	attributes = checkArrayArg('objc_property_attribute_t', attributes)
	if #attributes <= 0 then
		return ffi.C.class_addProperty(self, name, nil, 0)
	end
	local attrs = ffi.new('objc_property_attribute_t[?]', #attributes)
	return ffi.C.class_replaceProperty(self, name, attrs, #attributes)
end

ffi.cdef[[
void class_setIvarLayout(Class cls, const uint8_t *layout);
]]
function _class:setIvarLayout(layout)
	layout = checkNumberArg(layout)
	return ffi.C.class_setIvarLayout(self, layout)
end

ffi.cdef[[
void class_setWeakIvarLayout(Class cls, const uint8_t *layout);
]]
function _class:setWeakIvarLayout(layout)
	layout = checkNumberArg(layout)
	return ffi.C.class_setWeakIvarLayout(self, layout)
end

ffi.cdef[[
id class_createInstanceFromZone(Class, size_t idxIvars, void *z);
]]
function _class:createInstanceFromZone(idxIvars, z)
	idxIvars = checkNumberArg(idxIvars)
	z = checkArg('void*', z)
	return ffi.C.class_createInstanceFromZone(self, idxIvars, z)
end



-- API-IGNORE : class_addMethods
-- API-IGNORE : class_removeMethods
-- ffi.cdef[[
-- void class_addMethods(Class, struct objc_method_list *);
-- void class_removeMethods(Class, struct objc_method_list *);
-- ]]

ffi.cdef[[
IMP class_lookupMethod(Class cls, SEL sel);
]]
function _class:lookupMethod(sel)
	sel = checkArg('SEL', sel)
	return ffi.C.class_lookupMethod(self, sel)
end

ffi.cdef[[
BOOL class_respondsToMethod(Class cls, SEL sel);
]]
function _class:respondsToMethod()
	sel = checkArg('SEL', sel)
	return toboolean(ffi.C.class_respondsToMethod(self, sel))
end



return class