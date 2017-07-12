import('api._header')

local ffi = require('ffi')
local object = {}
local _object = {}


-- TODO: test api bridge for this below

ffi.cdef[[
id object_copy(id obj, size_t size);
]]
function _object:copy(size)
	size = checkNumberArg(size)
	return ffi.C.object_copy(self, size)
end

ffi.cdef[[
id object_dispose(id obj);
]]
function _object:dispose()
	return ffi.C.object_dispose(self)
end

ffi.cdef[[
Class object_getClass(id obj);
]]
function _object:getClass()
	return ffi.C.object_getClass(self)
end

ffi.cdef[[
Class object_setClass(id obj, Class cls);
]]
function _object:setClass(cls)
	cls = checkArg('Class', cls)
	return ffi.C.object_setClass(self, cls)
end

ffi.cdef[[
BOOL object_isClass(id obj);
]]
function _object:isClass()
	return ffi.C.object_isClass(self)
end

ffi.cdef[[
id object_getIvar(id obj, Ivar ivar);
]]
function _object:getIvar(ivar)
	ivar = checkArg('Ivar', ivar)
	return ffi.C.object_getIvar(self, ivar)
end


ffi.cdef[[
void object_setIvar(id obj, Ivar ivar, id value);
]]
function _object:setIvar(ivar, value)
	ivar = checkArg('Ivar', ivar)
	value = checkArg('id', value)
	return ffi.C.object_setIvar(self, ivar, value)
end


ffi.cdef[[
void object_setIvarWithStrongDefault(id obj, Ivar ivar, id value);
]]
function _object:setIvarWithStrongDefault(ivar, value)
	ivar = checkArg('Ivar', ivar)
	value = checkArg('id', value)
	return ffi.C.object_setIvarWithStrongDefault(self, ivar, value)
end


ffi.cdef[[
Ivar object_setInstanceVariable(id obj, const char *name, void *value);
]]
function _object:setInstanceVariable(name, value)
	name = checkStringArg(name)
	value = checkArg('void*', value)
	return ffi.C.object_setInstanceVariable(self, name, value)
end


ffi.cdef[[
Ivar object_setInstanceVariableWithStrongDefault(id obj, const char *name, void *value);
]]
function _object:setInstanceVariableWithStrongDefault(name, value)
	name = checkStringArg(name)
	value = checkArg('void*', value)
	return ffi.C.object_setInstanceVariableWithStrongDefault(self, name, value)
end


ffi.cdef[[
Ivar object_getInstanceVariable(id obj, const char *name, void **outValue);
]]
function _object:getInstanceVariable(name, outValue)
	name = checkStringArg(name)
	value = checkArg('void**', outValue)
	return ffi.C.object_getInstanceVariable(self, name, outValue)
end

ffi.cdef[[
const char *object_getClassName(id obj);
]]
function _object:getClassName()
	return ffi.string(ffi.C.object_getClassName(self))
end

ffi.cdef[[
void *object_getIndexedIvars(id obj);
]]
function _object:getIndexedIvars()
	return ffi.C.object_getIndexedIvars(self)
end

ffi.cdef[[
id object_copyFromZone(id anObject, size_t nBytes, void *z);
]]
function object.copyFromZone(anObject, nBytes, z)
	anObject = checkArg('id', anObject)
	nBytes = checkNumberArg(nBytes)
	z = checkArg('void*', z)
	return ffi.C.object_copyFromZone(anObject, nBytes, z)
end

-- API-IGNORE: object_realloc
-- nBytes = checkNumberArg(nBytes)dlsym(RTLD_DEFAULT, object_realloc): symbol not found
-- ffi.cdef[[
-- id object_realloc(id anObject, size_t nBytes);
-- ]]
-- function object.realloc(anObject, nBytes)
-- 	anObject = checkArg('id', anObject)
-- 	nBytes = checkNumberArg(nBytes)
-- 	return ffi.C.object_realloc(anObject, nBytes)
-- end

-- API-IGNORE: object_reallocFromZone
-- dlsym(RTLD_DEFAULT, object_reallocFromZone): symbol not found
-- ffi.cdef[[
-- id object_reallocFromZone(id anObject, size_t nBytes, void *z);
-- ]]
-- function object.reallocFromZone(anObject, nBytes, z)
-- 	anObject = checkArg('id', anObject)
-- 	nBytes = checkNumberArg(nBytes)
-- 	z = checkArg('void*', z)
-- 	return ffi.C.object_reallocFromZone(anObject, nBytes, z)
-- end

return exportWithMetaTable(object, _object, 'id')