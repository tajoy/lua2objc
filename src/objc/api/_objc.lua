import('api._header')
local ffi = require('ffi')
local objc = {}

ffi.cdef[[
id objc_retainedObject(objc_objectptr_t obj);
]]
function objc.retainedObject(obj)
	obj = checkArg('objc_objectptr_t', obj)
	return ffi.C.objc_retainedObject(obj)
end

ffi.cdef[[
id objc_unretainedObject(objc_objectptr_t obj);
]]
function objc.unretainedObject(obj)
	obj = checkArg('objc_objectptr_t', obj)
	return ffi.C.objc_unretainedObject(obj)
end

ffi.cdef[[
objc_objectptr_t objc_unretainedPointer(id obj);
]]
function objc.unretainedPointer(obj)
	obj = checkArg('id', obj)
	return ffi.C.objc_unretainedPointer(obj)
end

ffi.cdef[[
void objc_addClass(Class myClass);
]]
function objc.addClass(cls)
	cls = checkArg('Class', cls)
	ffi.C.objc_addClass(cls)
end

ffi.cdef[[
void objc_setClassHandler(int (*)(const char *));
]]
function objc.setClassHandler(func)
	func = checkFunctionArg(func)
	ffi.C.objc_setClassHandler(func)
end

ffi.cdef[[
void objc_setMultithreaded(BOOL flag);
]]
function objc.setMultithreaded(flag)
	flag = checkBooleanArg(flag)
	ffi.C.objc_setMultithreaded(flag)
end

-- API-RENAME : objc_copyClassList objc.getClassList
ffi.cdef[[
Class *objc_copyClassList(unsigned int *outCount);
]]
function objc.getClassList()
	local outCount = ffi.new("unsigned int[1]")
	local classes = ffi.gc(ffi.C.objc_copyClassList(outCount), ffi.C.free)
	local count = tonumber(outCount[0])
	local ret = {}
	for i = 0, count - 1 do
		ret[i+1] = classes[i]
	end
	return ret
end

-- API-RENAME : objc_copyImageNames objc.getImageNames
ffi.cdef[[
const char **objc_copyImageNames(unsigned int *outCount);
]]
function objc.getImageNames()
	local outCount = ffi.new("unsigned int[1]")
	local names = ffi.gc(ffi.C.objc_copyImageNames(outCount), ffi.C.free)
	local count = tonumber(outCount[0])
	local ret = {}
	for i = 0, count - 1 do
		ret[i+1] = ffi.string(names[i])
	end
	return ret
end

-- API-RENAME : objc_copyClassNamesForImage objc.getImageNamesForImage
ffi.cdef[[
const char **objc_copyClassNamesForImage(const char *image, unsigned int *outCount);
]]
function objc.getImageNamesForImage(image)
	image = checkStringArg(image)
	local outCount = ffi.new("unsigned int[1]")
	local names = ffi.gc(ffi.C.objc_copyClassNamesForImage(image, outCount), ffi.C.free)
	local count = tonumber(outCount[0])
	local ret = {}
	for i = 0, count - 1 do
		ret[i+1] = ffi.string(names[i])
	end
	return ret
end


ffi.cdef[[
void objc_registerClassPair(Class cls);
]]
function objc.registerClassPair(cls)
	cls = checkArg('Class', cls)
	ffi.C.objc_registerClassPair(cls)
end

ffi.cdef[[
Class objc_duplicateClass(Class original, const char *name, size_t extraBytes);
]]
function objc.duplicateClass(original, name, extraBytes)
	original = checkArg('Class', original)
	name = checkStringArg(name)
	extraBytes = checkNumberArg(extraBytes)
	return ffi.C.objc_duplicateClass(original, name, extraBytes)
end

ffi.cdef[[
void objc_disposeClassPair(Class cls);
]]
function objc.disposeClassPair(cls)
	cls = checkArg('Class', cls)
	ffi.C.objc_disposeClassPair(cls)
end

ffi.cdef[[
Class objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes);
]]
function objc.allocateClassPair(superclass, name, extraBytes)
	superclass = checkArg('Class', superclass)
	name = checkStringArg(name)
	extraBytes = checkNumberArg(extraBytes)
	return ffi.C.objc_allocateClassPair(superclass, name, extraBytes)
end

-- API-IGNORE : objc_constructInstance
-- API-IGNORE : objc_destructInstance
-- the rename reason is duplicate with class:createInstance
-- ffi.cdef[[
-- id objc_constructInstance(Class cls, void *bytes);
-- void *objc_destructInstance(id obj);
-- ]]

ffi.cdef[[
Class objc_getClass(const char *name);
]]
function objc.getClass(name)
	name = checkStringArg(name)
	return ffi.C.objc_getClass(name)
end

ffi.cdef[[
Class objc_getMetaClass(const char *name);
]]
function objc.getMetaClass(name)
	name = checkStringArg(name)
	return ffi.C.objc_getMetaClass(name)
end

ffi.cdef[[
Class objc_lookUpClass(const char *name);
]]
function objc.lookUpClass(name)
	name = checkStringArg(name)
	return ffi.C.objc_lookUpClass(name)
end

ffi.cdef[[
Class objc_getRequiredClass(const char *name);
]]
function objc.getRequiredClass(name)
	name = checkStringArg(name)
	return ffi.C.objc_getRequiredClass(name)
end

ffi.cdef[[
Protocol *objc_getProtocol(const char *name);
]]
function objc.getProtocol(name)
	name = checkStringArg(name)
	return ffi.C.objc_getProtocol(name)
end

-- API-RENAME : objc_copyProtocolList objc.getProtocolList
ffi.cdef[[
Protocol **objc_copyProtocolList(unsigned int *outCount);
]]
function objc.getProtocolList()
	local outCount = ffi.new("unsigned int[1]")
	local protocols = ffi.gc(ffi.C.objc_copyProtocolList(outCount), ffi.C.free)
	local count = tonumber(outCount[0])
	local ret = {}
	for i = 0, count - 1 do
		ret[i+1] = protocols[i]
	end
	return ret
end

ffi.cdef[[
Protocol *objc_allocateProtocol(const char *name);
]]
function objc.allocateProtocol(name)
	name = checkStringArg(name)
	return ffi.C.objc_allocateProtocol(name)
end
ffi.cdef[[
void objc_registerProtocol(Protocol *proto);
]]
function objc.registerProtocol(proto)
	proto = checkArg('Protocol *', proto)
	ffi.C.objc_registerProtocol(proto)
end

-- TODO: implement api bridge for this below
ffi.cdef[[
id objc_loadWeak(id *location);
id objc_storeWeak(id *location, id obj);
]]

-- TODO: implement api bridge for this below
ffi.cdef[[
void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
id objc_getAssociatedObject(id object, const void *key);
void objc_removeAssociatedObjects(id object);
]]



return objc


