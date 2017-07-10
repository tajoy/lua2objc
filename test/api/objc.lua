-- test for objc.api.objc

local ffi = require('ffi')
local objc = require('objc').api.objc

local function test_objc_retainedObject()
	-- test for function objc.retainedObject(obj)
	local cls = objc.getClass('NSObject')
	assert(cls)
	cls = ffi.cast('objc_objectptr_t', cls)
	assert_eq(objc.retainedObject(cls), cls)
end
local function test_objc_unretainedObject()
	-- test for function objc.unretainedObject(obj)
	local cls = objc.getClass('NSObject')
	assert(cls)
	cls = ffi.cast('objc_objectptr_t', cls)
	_cls = objc.retainedObject(cls)
	assert(_cls)
	_cls = ffi.cast('objc_objectptr_t', _cls)
	assert_eq(objc.unretainedObject(_cls), cls)
end
local function test_objc_unretainedPointer()
	-- TODO: test for function objc.unretainedPointer(obj)
end
local function test_objc_addClass()
	-- TODO: test for function objc.addClass(cls)
end
local function test_objc_setClassHandler()
	-- TODO: test for function objc.setClassHandler(func)
end
local function test_objc_setMultithreaded()
	-- test for function objc.setMultithreaded(flag)
	objc.setMultithreaded(false)
	objc.setMultithreaded(true)
end
local function test_objc_getClassList()
	-- test for function objc.getClassList()
	local class_list = objc.getClassList()
	assert(#class_list > 0)
	assert(class_list[1])
	assert(ffi.istype('Class', class_list[1]))
end
local function test_objc_getImageNames()
	-- test for function objc.getImageNames()
	local image_names = objc.getImageNames()
	assert(#image_names > 0)
	assert(image_names[1])
	assert_eq(type(image_names[1]), 'string')
end
local function test_objc_getImageNamesForImage()
	-- test for function objc.getImageNamesForImage(image)
	local image_names = objc.getImageNames()
	assert(#image_names > 0)
	assert(image_names[1])
	assert_eq(type(image_names[1]), 'string')
	local class_names = objc.getImageNamesForImage(image_names[1])
	assert(#class_names > 0)
	assert(class_names[1])
	assert_eq(type(class_names[1]), 'string')
end
local function test_objc_registerClassPair()
	-- test for function objc.registerClassPair(cls)
	local cls = objc.getClass('NSObject')
	assert(cls)
	local pair = objc.allocateClassPair(cls, 'NSObject_registerClassPair', 0)
	assert(pair)
	objc.registerClassPair(pair)
end
local function test_objc_duplicateClass()
	-- test for function objc.duplicateClass(original, name, extraBytes)
	local cls = objc.getClass('NSObject')
	assert(cls)
	cls = objc.duplicateClass(cls, "NSObject_duplicateClass", 0)
	assert(cls)
end
local function test_objc_disposeClassPair()
	-- test for function objc.disposeClassPair(cls)
	local cls = objc.getClass('NSObject')
	assert(cls)
	local pair = objc.allocateClassPair(cls, 'NSObject_disposeClassPair', 0)
	assert(pair)
	objc.disposeClassPair(pair)
end
local function test_objc_allocateClassPair()
	-- test for function objc.allocateClassPair(superclass, name, extraBytes)
	local cls = objc.getClass('NSObject')
	assert(cls)
	local pair = objc.allocateClassPair(cls, 'NSObject_allocateClassPair', 0)
	assert(pair)
end
local function test_objc_getClass()
	-- test for function objc.getClass(name)
	assert(objc.getClass('NSObject'))
end
local function test_objc_getMetaClass()
	-- test for function objc.getMetaClass(name)
	assert(objc.getMetaClass('NSObject'))
end
local function test_objc_lookUpClass()
	-- test for function objc.lookUpClass(name)
	assert(objc.lookUpClass('NSObject'))
end
local function test_objc_getRequiredClass()
	-- test for function objc.getRequiredClass(name)
	assert(objc.getRequiredClass('NSObject'))
end
function test_objc_getProtocol()
	-- test for function objc.getProtocol(name)
	assert(objc.getProtocol('NSCopying'))
end
function test_objc_getProtocolList()
	-- test for function objc.getProtocolList()
	local list = objc.getProtocolList()
	assert(#list > 0)
	assert(ffi.istype('Protocol *', list[1]))
end
function test_objc_allocateProtocol()
	-- test for function objc.allocateProtocol(name)
	local protocol = objc.allocateProtocol('test_objc_allocateProtocol')
	assert(protocol)
	assert(ffi.istype('Protocol *', protocol))
end
function test_objc_registerProtocol()
	-- test for function objc.registerProtocol(proto)
	local protocol = objc.allocateProtocol('test_objc_registerProtocol')
	assert(protocol)
	assert(ffi.istype('Protocol *', protocol))
	objc.registerProtocol(protocol)
end
local all_test_func = {
	test_objc_retainedObject,
	test_objc_unretainedObject,
	test_objc_unretainedPointer,
	test_objc_addClass,
	test_objc_setClassHandler,
	test_objc_setMultithreaded,
	test_objc_getClassList,
	test_objc_getImageNames,
	test_objc_getImageNamesForImage,
	test_objc_registerClassPair,
	test_objc_duplicateClass,
	test_objc_disposeClassPair,
	test_objc_allocateClassPair,
	test_objc_getClass,
	test_objc_getMetaClass,
	test_objc_lookUpClass,
	test_objc_getRequiredClass,
	test_objc_getProtocol,
	test_objc_getProtocolList,
	test_objc_allocateProtocol,
	test_objc_registerProtocol,
}

for _, func in ipairs(all_test_func) do
	func()
end
