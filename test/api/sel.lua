-- test for objc.api.sel

local ffi = require('ffi')
local api = require('objc').api
local objc = api.objc
local function getClass(name)
	return objc.getClass(name)
end
local SEL = api.SEL

local function test__SEL_getName()
	-- test for function _SEL:getName()
	local sel = SEL'test__SEL_getName'
	assert_eq(sel:getName(), 'test__SEL_getName')
end
local function test__SEL___tostring()
	-- test for function _SEL:__tostring(other)
	local sel = SEL'test__SEL___tostring'
	assert_eq(tostring(sel), 'SEL<test__SEL___tostring>')

end
local function test__SEL___concat()
	-- test for function _SEL:__concat(other)
	local sel = SEL'test__SEL___concat'
	assert_eq(sel .. 'xxx', 'SEL<test__SEL___concat>xxx')

end
local function test__SEL_isMapped()
	-- test for function _SEL:isMapped()
	local sel = SEL'test__SEL_isMapped'
	assert_eq(sel:isMapped(), true)
end
local function test__SEL_isEqual()
	-- test for function _SEL:isEqual(other)
	local sel_1 = SEL'test__SEL_isEqual'
	local sel_2 = SEL'test__SEL_isEqual'
	assert_eq(sel_1:isEqual(sel_2), true)

end
local function test__SEL___eq()
	-- test for function _SEL:__eq(other)
	local sel_1 = SEL'test__SEL___eq'
	local sel_2 = SEL'test__SEL___eq'
	assert_eq(sel_1, sel_2)
end
local function test__SEL___call()
	-- test for function _SEL.__call(name)
	assert(ffi.istype('SEL', SEL'test__SEL___call'))
end
local function test_SEL_getUid()
	-- test for function SEL.getUid(str)
	local sel = SEL.getUid'test_SEL_getUid'
	assert(ffi.istype('SEL', sel))
end
local function test_SEL_registerName()
	-- test for function SEL.registerName(str)
	local sel = SEL.registerName'test_SEL_getUid'
	assert(ffi.istype('SEL', sel))
end

local all_test_func =
{
	test__SEL_getName,
	test__SEL___tostring,
	test__SEL___concat,
	test__SEL_isMapped,
	test__SEL_isEqual,
	test__SEL___eq,
	test__SEL___call,
	test_SEL_getUid,
	test_SEL_registerName,
}

for _, func in ipairs(all_test_func) do
	func()
end