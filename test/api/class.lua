-- TODO: write test for objc.api.class

local ffi = require('ffi')

local objc = require('objc').api.objc
local function getClass(name)
	return objc.getClass(name)
end
local function newClass(name, adapter)
	local cls = objc.getClass('NSObject')
	local pair = objc.allocateClassPair(cls, name, 0)
	if adapter and type(adapter) == 'function' then
		adapter(cls)
	end
	objc.registerClassPair(pair)
	return objc.getClass(name)
end
local function SEL(str)
	return ffi.C.sel_registerName(str)
end
local function Protocol(name)
	return ffi.C.objc_getProtocol(name)
end

assert(ffi.istype('SEL', SEL('init')))
assert(ffi.istype('Class', getClass('NSObject')))
assert(ffi.istype('Class', newClass('MyNewClass')))

function test_Class_getImageName()
	-- test for function _Class:getImageName()
	local cls = getClass('NSObject')
	assert(cls:getImageName())
end
function test_Class_getName()
	-- test for function _Class:getName()
	local cls = getClass('NSObject')
	assert(cls:getName())
end
function test_Class_isMetaClass()
	-- test for function _Class:isMetaClass()
	local cls = getClass('NSObject')
	assert_eq(cls:isMetaClass(), false)
	local meta_cls = ffi.cast('id', cls):getClass()
	assert_eq(meta_cls:isMetaClass(), true)
end
function test_Class_getSuperclass()
	-- test for function _Class:getSuperclass()
	local cls = getClass('NSString')
	assert(cls)
	assert(ffi.istype('Class', cls))
	local super_cls = cls:getSuperclass()
	assert(super_cls)
	assert(ffi.istype('Class', super_cls))
end
function test_Class_setSuperclass()
	-- test for function _Class:setSuperclass(newSuper)
	local new_cls = newClass("Test_setSuperclass")
	assert(new_cls)
	assert(ffi.istype('Class', new_cls))
	local old_super_cls = new_cls:setSuperclass(getClass('NSString'))
	assert(old_super_cls)
	assert(ffi.istype('Class', old_super_cls))
end
function test_Class_getVersion()
	-- test for function _Class:getVersion()
	local cls = getClass('NSObject')
	assert(cls)
	assert(ffi.istype('Class', cls))
	assert(cls:getVersion())
end
function test_Class_setVersion()
	-- test for function _Class:setVersion(version)
	local new_cls = newClass("Test_setVersion")
	assert(new_cls)
	assert(ffi.istype('Class', new_cls))
	new_cls:setVersion(1)
end
function test_Class_getInstanceSize()
	-- test for function _Class:getInstanceSize()
	local cls = getClass('NSObject')
	assert(cls)
	assert(cls:getInstanceSize())
end
function test_Class_getInstanceVariable()
	-- test for function _Class:getInstanceVariable(name)
	local cls = getClass('NSString')
	assert(cls)
	assert(ffi.istype('Ivar', cls:getInstanceVariable('_hash')))
end
function test_Class_getClassVariable()
	-- test for function _Class:getClassVariable(name)
	local cls = getClass('NSString')
	assert(cls)
	assert(ffi.istype('Ivar', cls:getClassVariable('isa')))
end
function test_Class_getIvarList()
	-- test for function _Class:getIvarList()
	local cls = getClass('NSObject')
	assert(cls)
	assert(#cls:getIvarList() > 0)
end
function test_Class_getInstanceMethod()
	-- test for function _Class:getInstanceMethod(name)
	local cls = getClass('NSString')
	assert(cls)
	local  method = cls:getInstanceMethod(SEL'UTF8String')
	assert(method)
	assert(ffi.istype('Method', method))
end
function test_Class_getClassMethod()
	-- test for function _Class:getClassMethod(name)
	local cls = getClass('NSString')
	assert(cls)
	local  method = cls:getClassMethod(SEL'initWithUTF8String:')
	assert(method)
	assert(ffi.istype('Method', method))
end
function test_Class_getMethodImplementation()
	-- test for function _Class:getMethodImplementation(name)
	local cls = getClass('NSString')
	assert(cls)
	local  imp = cls:getMethodImplementation(SEL'UTF8String')
	assert(imp)
	assert(ffi.istype('IMP', imp))
end
function test_Class_getMethodImplementation_stret()
	-- test for function _Class:getMethodImplementation_stret(name)
	local cls = getClass('NSString')
	assert(cls)
	local  imp = cls:getMethodImplementation_stret(SEL'decimalValue')
	assert(imp)
	assert(ffi.istype('IMP', imp))
end
function test_Class_respondsToSelector()
	-- test for function _Class:respondsToSelector(sel)
	local cls = getClass('NSString')
	assert(cls)
	assert(cls:respondsToSelector(SEL'initWithUTF8String:'))
end
function test_Class_getMethodList()
	-- test for function _Class:getMethodList()
	local cls = getClass('NSString')
	assert(cls)
	assert(#cls:getMethodList() > 0)
end
function test_Class_conformsToProtocol()
	-- test for function _Class:conformsToProtocol()
	local cls = getClass('NSString')
	assert(cls)
	local protocol = Protocol'NSCopying'
	assert(protocol)
	assert(cls:conformsToProtocol(protocol))
end
function test_Class_getProtocolList()
	-- test for function _Class:getProtocolList()
	local cls = getClass('NSString')
	assert(cls)
	local list = cls:getProtocolList()
	assert(#list > 0)
	assert(ffi.istype('Protocol *', list[1]))
end
function test_Class_getProperty()
	-- test for function _Class:getProperty(name)
	local cls = getClass('NSString')
	assert(cls)
	local property = cls:getProperty('length')
	assert(property)
	assert(ffi.istype('objc_property_t', property))
end
function test_Class_getPropertyList()
	-- TODO: test for function _Class:getPropertyList()
	local cls = getClass('NSString')
	assert(cls)
	local list = cls:getPropertyList()
	assert(#list > 0)
	assert(ffi.istype('objc_property_t', list[1]))
end
function test_Class_getIvarLayout()
	-- TODO: test for function _Class:getIvarLayout()
	local cls = getClass('NSConcreteData')
	assert(cls)
	print(cls:getIvarLayout())
end
function test_Class_getWeakIvarLayout()
	-- TODO: test for function _Class:getWeakIvarLayout()
end
function test_Class_addMethod()
	-- TODO: test for function _Class:addMethod(name, imp, types)
end
function test_Class_replaceMethod()
	-- TODO: test for function _Class:replaceMethod()
end
function test_Class_addIvar()
	-- TODO: test for function _Class:addIvar()
end
function test_Class_addProtocol()
	-- TODO: test for function _Class:addProtocol()
end
function test_Class_addProperty()
	-- TODO: test for function _Class:addProperty(name, attributes)
end
function test_Class_replaceProperty()
	-- TODO: test for function _Class:replaceProperty(name, attributes)
end
function test_Class_setIvarLayout()
	-- TODO: test for function _Class:setIvarLayout(layout)
end
function test_Class_setWeakIvarLayout()
	-- TODO: test for function _Class:setWeakIvarLayout(layout)
end
function test_Class_createInstanceFromZone()
	-- TODO: test for function _Class:createInstanceFromZone(idxIvars, z)
end
function test_Class_lookupMethod()
	-- TODO: test for function _Class:lookupMethod(sel)
end
function test_Class_respondsToMethod()
	-- TODO: test for function _Class:respondsToMethod(sel)
end
function test_Class_createInstance()
	-- TODO: test for function _Class:createInstance(extraBytes)
end
local all_test_func = {
	test_Class_getImageName,
	test_Class_getName,
	test_Class_isMetaClass,
	test_Class_getSuperclass,
	test_Class_setSuperclass,
	test_Class_getVersion,
	test_Class_setVersion,
	test_Class_getInstanceSize,
	test_Class_getInstanceVariable,
	test_Class_getClassVariable,
	test_Class_getIvarList,
	test_Class_getInstanceMethod,
	test_Class_getClassMethod,
	test_Class_getMethodImplementation,
	test_Class_getMethodImplementation_stret,
	test_Class_respondsToSelector,
	test_Class_getMethodList,
	test_Class_conformsToProtocol,
	test_Class_getProtocolList,
	test_Class_getProperty,
	test_Class_getPropertyList,
	test_Class_getIvarLayout,
	test_Class_getWeakIvarLayout,
	test_Class_addMethod,
	test_Class_replaceMethod,
	test_Class_addIvar,
	test_Class_addProtocol,
	test_Class_addProperty,
	test_Class_replaceProperty,
	test_Class_setIvarLayout,
	test_Class_setWeakIvarLayout,
	test_Class_createInstanceFromZone,
	test_Class_lookupMethod,
	test_Class_respondsToMethod,
	test_Class_createInstance,
}

for _, func in ipairs(all_test_func) do
	func()
end

