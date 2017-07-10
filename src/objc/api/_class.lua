import('api._header')

local ffi = require('ffi')
local _Class = {}
local Class = {}

-- TODO: test api bridge for this below

ffi.cdef[[
const char *class_getImageName(Class cls);
]]
function _Class:getImageName()
	return ffi.string(ffi.C.class_getImageName(self))
end

ffi.cdef[[
const char *class_getName(Class cls);
]]
function _Class:getName()
	return ffi.string(ffi.C.class_getName(self))
end

function _Class:__tostring(other)
	return 'Class<' .. self:getName() .. '>'
end
function _Class:__concat(other)
	return tostring(self) .. tostring(other)
end


ffi.cdef[[
BOOL class_isMetaClass(Class cls);
]]
function _Class:isMetaClass()
	return toboolean(ffi.C.class_isMetaClass(self))
end

ffi.cdef[[
Class class_getSuperclass(Class cls);
]]
function _Class:getSuperclass()
	-- FIXME: crashed when calling
	return ffi.C.class_getSuperclass(self)
end

-- API-ALIAS : _Class.getSuperClass -> Class.getSuperclass
_Class.getSuperClass = _Class.getSuperclass

ffi.cdef[[
Class class_setSuperclass(Class cls, Class newSuper);
]]
function _Class:setSuperclass(newSuper)
	newSuper = checkArg('Class', newSuper)
	return ffi.C.class_setSuperclass(self, newSuper)
end

ffi.cdef[[
int class_getVersion(Class cls);
]]
function _Class:getVersion()
	return ffi.C.class_getVersion(self)
end

ffi.cdef[[
void class_setVersion(Class cls, int version);
]]
function _Class:setVersion(version)
	version = checkNumberArg(version)
	return ffi.C.class_setVersion(self, version)
end

ffi.cdef[[
size_t class_getInstanceSize(Class cls);
]]
function _Class:getInstanceSize()
	return ffi.C.class_getInstanceSize(self)
end

ffi.cdef[[
Ivar class_getInstanceVariable(Class cls, const char *name);
]]
function _Class:getInstanceVariable(name)
	name = checkStringArg(name)
	return ffi.C.class_getInstanceVariable(self, name)
end

ffi.cdef[[
Ivar class_getClassVariable(Class cls, const char *name);
]]
function _Class:getClassVariable(name)
	name = checkStringArg(name)
	return ffi.C.class_getClassVariable(self, name)
end


-- API-RENAME : class_copyIvarList class:getIvarList
ffi.cdef[[
Ivar *class_copyIvarList(Class cls, unsigned int *outCount);
]]
function _Class:getIvarList()
	local outCount = ffi.new("unsigned int[1]")
	local list = ffi.gc(ffi.C.class_copyIvarList(self, outCount), ffi.C.free)
	local ret = {}
	for i = 0, outCount[0] - 1 do
		ret[i+1] = list[i]
	end
	return ret
end

ffi.cdef[[
Method class_getInstanceMethod(Class cls, SEL name);
]]
function _Class:getInstanceMethod(name)
	name = checkArg('SEL', name)
	return ffi.C.class_getInstanceMethod(self, name)
end

ffi.cdef[[
Method class_getClassMethod(Class cls, SEL name);
]]
function _Class:getClassMethod(name)
	name = checkArg('SEL', name)
	return ffi.C.class_getClassMethod(self, name)
end

ffi.cdef[[
IMP class_getMethodImplementation(Class cls, SEL name);
]]
function _Class:getMethodImplementation(name)
	name = checkArg('SEL', name)
	return ffi.C.class_getMethodImplementation(self, name)
end

ffi.cdef[[
IMP class_getMethodImplementation_stret(Class cls, SEL name);
]]
function _Class:getMethodImplementation_stret(name)
	name = checkArg('SEL', name)
	return ffi.C.class_getMethodImplementation_stret(self, name)
end

ffi.cdef[[
BOOL class_respondsToSelector(Class cls, SEL sel);
]]
function _Class:respondsToSelector(sel)
	sel = checkArg('SEL', sel)
	return toboolean(ffi.C.class_respondsToSelector(self, sel))
end

-- API-RENAME : class_copyMethodList class:getMethodList
ffi.cdef[[
Method *class_copyMethodList(Class cls, unsigned int *outCount);
]]
function _Class:getMethodList()
	local outCount = ffi.new("unsigned int[2]")
	local list = ffi.C.class_copyMethodList(self, outCount)
	local ret = {}
	local i = 0
	while list[i] and outCount[0] > i do
		ret[i+1] = list[i]
		i = i + 1
	end
	ffi.C.free(list)
	return ret
end

ffi.cdef[[
BOOL class_conformsToProtocol(Class cls, Protocol *protocol);
]]
function _Class:conformsToProtocol(protocol)
	protocol = checkArg('Protocol *', protocol)
	return toboolean(ffi.C.class_conformsToProtocol(self, protocol))
end

-- API-RENAME : class_copyProtocolList class:getProtocolList
ffi.cdef[[
Protocol **class_copyProtocolList(Class cls, unsigned int *outCount);
]]
function _Class:getProtocolList()
	local outCount = ffi.new("unsigned int[1]")
	local list = ffi.gc(ffi.C.class_copyProtocolList(self, outCount), ffi.C.free)
	local ret = {}
	for i = 0, outCount[0] - 1 do
		ret[i+1] = list[i]
	end
	return ret
end

ffi.cdef[[
objc_property_t class_getProperty(Class cls, const char *name);
]]
function _Class:getProperty(name)
	name = checkStringArg(name)
	return ffi.C.class_getProperty(self, name)
end

-- API-RENAME : class_copyPropertyList class:getPropertyList
ffi.cdef[[
objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount);
]]
function _Class:getPropertyList()
	local outCount = ffi.new("unsigned int[1]")
	local list = ffi.gc(ffi.C.class_copyPropertyList(self, outCount), ffi.C.free)
	local ret = {}
	for i = 0, outCount[0] - 1 do
		ret[i+1] = list[i]
	end
	return ret
end

ffi.cdef[[
const uint8_t *class_getIvarLayout(Class cls);
]]
function _Class:getIvarLayout()
	return ffi.C.class_getIvarLayout(self)
end

ffi.cdef[[
const uint8_t *class_getWeakIvarLayout(Class cls);
]]
function _Class:getWeakIvarLayout()
	return ffi.C.class_getWeakIvarLayout(self)
end

ffi.cdef[[
BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types);
]]
function _Class:addMethod(name, imp, types)
	name = checkArg('SEL', name)
	imp = checkArg('IMP', imp)
	types = checkStringArg(types)
	return toboolean(ffi.C.class_addMethod(self, name, imp, types))
end

ffi.cdef[[
IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types);
]]
function _Class:replaceMethod()
	name = checkArg('SEL', name)
	imp = checkArg('IMP', imp)
	types = checkStringArg(types)
	return ffi.C.class_replaceMethod(self, name, imp, types)
end

ffi.cdef[[
BOOL class_addIvar(Class cls, const char *name, size_t size, uint8_t alignment, const char *types);
]]
function _Class:addIvar()
	name = checkStringArg(name)
	size = checkNumberArg(size)
	alignment = checkNumberArg(alignment)
	types = checkStringArg(types)
	return toboolean(ffi.C.class_addIvar(self, name, size, alignment, types))
end

ffi.cdef[[
BOOL class_addProtocol(Class cls, Protocol *protocol);
]]
function _Class:addProtocol()
	protocol = checkArg('Protocol *', protocol)
	return toboolean(ffi.C.class_addProtocol(self, protocol))
end

ffi.cdef[[
BOOL class_addProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount);
]]
function _Class:addProperty(name, attributes)
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
function _Class:replaceProperty(name, attributes)
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
function _Class:setIvarLayout(layout)
	layout = checkNumberArg(layout)
	return ffi.C.class_setIvarLayout(self, layout)
end

ffi.cdef[[
void class_setWeakIvarLayout(Class cls, const uint8_t *layout);
]]
function _Class:setWeakIvarLayout(layout)
	layout = checkNumberArg(layout)
	return ffi.C.class_setWeakIvarLayout(self, layout)
end

ffi.cdef[[
id class_createInstanceFromZone(Class, size_t idxIvars, void *z);
]]
function _Class:createInstanceFromZone(idxIvars, z)
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
function _Class:lookupMethod(sel)
	sel = checkArg('SEL', sel)
	return ffi.C.class_lookupMethod(self, sel)
end

ffi.cdef[[
BOOL class_respondsToMethod(Class cls, SEL sel);
]]
function _Class:respondsToMethod(sel)
	sel = checkArg('SEL', sel)
	return toboolean(ffi.C.class_respondsToMethod(self, sel))
end

ffi.cdef[[
id class_createInstance(Class cls, size_t extraBytes);
void *objc_destructInstance(id obj);
]]
function _Class:createInstance(extraBytes)
	if extraBytes == nil then
		extraBytes = 0
	end
	extraBytes = checkNumberArg(extraBytes)
	-- FIXME: maybe should check refrence count when GC in lua?
	return ffi.gc(ffi.C.class_createInstance(self, extraBytes), ffi.C.objc_destructInstance)
end

return exportWithMetaTable(Class, _Class, 'Class')