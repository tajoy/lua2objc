-- TODO: write test for objc.api.object

local ffi = require('ffi')

local objc = require('objc').api.objc
local function getClass(name)
	return objc.getClass(name)
end

local Object = require('objc').api.Object
local obj = ffi.cast('id', getClass'NSObject')

local function test__object_copy()
	-- test for function _object:copy(size)
	assert(obj:copy(0))
end
local function test__object_dispose()
	-- test for function _object:dispose()
	assert(obj:copy(0):dispose())
end
local function test__object_getClass()
	-- test for function _object:getClass()
	assert(obj:getClass())
end
local function test__object_setClass()
	-- test for function _object:setClass(cls)
	assert(obj:setClass(getClass'NSObject'))
end
local function test__object_isClass()
	-- test for function _object:isClass()
	assert(obj:isClass())
end
local function test__object_getIvar()
	-- test for function _object:getIvar(ivar)
	assert(obj:getIvar(getClass('NSObject'):getClassVariable('')))
end
local function test__object_setIvar()
	-- test for function _object:setIvar(ivar, value)
	local ivar = getClass('NSObject'):getClassVariable('')
	obj:setIvar(ivar, obj:getIvar(ivar))
end
local function test__object_setIvarWithStrongDefault()
	-- test for function _object:setIvarWithStrongDefault()
	obj:setIvarWithStrongDefault(ffi.cast('Ivar', nil), ffi.cast('id', nil))
end
local function test__object_setInstanceVariable()
	-- test for function _object:setInstanceVariable(name, value)
	assert(obj:setInstanceVariable('', ffi.cast('void*', nil)))
end
local function test__object_setInstanceVariableWithStrongDefault()
	-- test for function _object:setInstanceVariableWithStrongDefault(name, value)
	assert(obj:setInstanceVariableWithStrongDefault('', ffi.cast('void*', nil)))
end
local function test__object_getInstanceVariable()
	-- test for function _object:getInstanceVariable(name, outValue)
	assert(obj:getInstanceVariable('', ffi.cast('void**', nil)))
end
local function test__object_getClassName()
	-- test for function _object:getClassName()
	assert(obj:getClassName())
end
local function test__object_getIndexedIvars()
	-- test for function _object:getIndexedIvars()
	assert(obj:getIndexedIvars())
end
local function test_object_copyFromZone()
	-- test for function object.copyFromZone(anObject, nBytes, z)
	Object.copyFromZone(obj, 0, ffi.cast('void*', nil))
end

local all_test_func =
{
	test__object_copy,
	test__object_dispose,
	test__object_getClass,
	test__object_setClass,
	test__object_isClass,
	test__object_getIvar,
	test__object_setIvar,
	test__object_setIvarWithStrongDefault,
	test__object_setInstanceVariable,
	test__object_setInstanceVariableWithStrongDefault,
	test__object_getInstanceVariable,
	test__object_getClassName,
	test__object_getIndexedIvars,
	test_object_copyFromZone,
}

for _, func in ipairs(all_test_func) do
	func()
end