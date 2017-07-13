-- write test for objc.api.property


local ffi = require('ffi')

local objc = require('objc').api.objc
local function getClass(name)
	return objc.getClass(name)
end

local cls = getClass'NSString'
local prop_list = cls:getPropertyList()
local prop = prop_list[1]
assert(prop)

local function test__Property_getName()
	-- test for function _Property:getName()
	assert(prop:getName())
end
local function test__Property_getAttributes()
	-- test for function _Property:getAttributes()
	assert(prop:getAttributes())
end
local function test__Property_getAttributeList()
	-- test for function _Property:getAttributeList()
	assert(prop:getAttributeList())
end
local function test__Property_getAttributeValue()
	-- test for function _Property:getAttributeValue(attributeName)
	-- FIXME: how to use this API by right way?
	-- assert(prop:getAttributeValue(''))
end

local all_test_func =
{
	test__Property_getName,
	test__Property_getAttributes,
	test__Property_getAttributeList,
	test__Property_getAttributeValue,
}

for _, func in ipairs(all_test_func) do
	func()
end





