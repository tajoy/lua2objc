-- TODO: write test for objc.api.object

local ffi = require('ffi')

local objc = require('objc').api.objc
local function getClass(name)
	return objc.getClass(name)
end

local object = require('objc').api.object

local function test__object_copy()
	-- TODO: test for function _object:copy(size)
end
local function test__object_dispose()
	-- TODO: test for function _object:dispose()
end
local function test__object_getClass()
	-- TODO: test for function _object:getClass()
end
local function test__object_setClass()
	-- TODO: test for function _object:setClass(cls)
end
local function test__object_isClass()
	-- TODO: test for function _object:isClass()
end
local function test__object_getIvar()
	-- TODO: test for function _object:getIvar(ivar)
end
local function test__object_setIvar()
	-- TODO: test for function _object:setIvar(ivar, value)
end
local function test__object_setIvarWithStrongDefault()
	-- TODO: test for function _object:setIvarWithStrongDefault()
end
local function test__object_setInstanceVariable()
	-- TODO: test for function _object:setInstanceVariable(name, value)
end
local function test__object_setInstanceVariableWithStrongDefault()
	-- TODO: test for function _object:setInstanceVariableWithStrongDefault(name, value)
end
local function test__object_getInstanceVariable()
	-- TODO: test for function _object:getInstanceVariable(name, outValue)
end
local function test__object_getClassName()
	-- TODO: test for function _object:getClassName()
end
local function test__object_getIndexedIvars()
	-- TODO: test for function _object:getIndexedIvars()
end
local function test_object_copyFromZone()
	-- TODO: test for function object.copyFromZone(anObject, nBytes, z)
end
local function test_object_realloc()
	-- TODO: test for function object.realloc(anObject, nBytes)
end
local function test_object_reallocFromZone()
	-- TODO: test for function object.reallocFromZone(anObject, nBytes, z)
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
	test_object_realloc,
	test_object_reallocFromZone,
}

for _, func in ipairs(all_test_func) do
	func()
end