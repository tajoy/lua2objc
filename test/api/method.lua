-- test for objc.api.method

local ffi = require('ffi')

local objc = require('objc').api.objc
local function getClass(name)
	return objc.getClass(name)
end

local function SEL(str)
	return ffi.C.sel_registerName(str)
end

local cls = getClass('NSString')
local method_1 = cls:getClassMethod(SEL'stringWithBytes:length:encoding:')
local method_2 = cls:getInstanceMethod(SEL'compare:options:range:')
local imp = ffi.cast('IMP', ffi.C._objc_msgForward)

assert(cls)
assert(method_1)
assert(method_2)

local function test_Method_getName()
	-- test for function _Method:getName()
	assert_eq(method_1:getName(), SEL'stringWithBytes:length:encoding:')
end
local function test_Method___tostring()
	-- test for function _Method:__tostring(other)
	assert_eq(tostring(method_1), 'Method<stringWithBytes:length:encoding:>')
end
local function test_Method___concat()
	-- test for function _Method:__concat(other)
	assert_eq(method_1 .. 'xxx', 'Method<stringWithBytes:length:encoding:>xxx')
end
local function test_Method_getImplementation()
	-- test for function _Method:getImplementation()
	local imp = method_1:getImplementation()
	assert(imp)
	assert(ffi.istype('IMP', imp))
end
local function test_Method_getTypeEncoding()
	-- test for function _Method:getTypeEncoding()
	assert_eq(method_1:getTypeEncoding(), '@40@0:8r^v16Q24Q32')
	assert_eq(method_2:getTypeEncoding(), 'q48@0:8@16Q24{_NSRange=QQ}32')
end
local function test_Method_getNumberOfArguments()
	-- test for function _Method:getNumberOfArguments()
	assert_eq(method_1:getNumberOfArguments(), 5)
	assert_eq(method_2:getNumberOfArguments(), 5)
end
local function test_Method_getReturnType()
	-- test for function _Method:getReturnType()
	assert_eq(method_1:getReturnType(), "@")
	assert_eq(method_2:getReturnType(), "q")
end
local function test_Method_getArgumentType()
	-- test for function _Method:getArgumentType(index)
	assert_eq(method_1:getArgumentType(0), "@")
	assert_eq(method_1:getArgumentType(1), ":")
	assert_eq(method_1:getArgumentType(2), "r^v")
	assert_eq(method_1:getArgumentType(3), "Q")
	assert_eq(method_1:getArgumentType(4), "Q")

	assert_eq(method_2:getArgumentType(0), "@")
	assert_eq(method_2:getArgumentType(1), ":")
	assert_eq(method_2:getArgumentType(2), "@")
	assert_eq(method_2:getArgumentType(3), "Q")
	assert_eq(method_2:getArgumentType(4), "{_NSRange=QQ}")
end
local function test_Method_getDescription()
	-- test for function _Method:getDescription()
	local desc_1 = method_1:getDescription()
	assert(desc_1)
	assert_eq(desc_1.name, SEL'stringWithBytes:length:encoding:')
	assert_eq(desc_1.types, '@40@0:8r^v16Q24Q32')
	local desc_2 = method_2:getDescription()
	assert(desc_2)
	assert_eq(desc_2.name, SEL'compare:options:range:')
	assert_eq(desc_2.types, 'q48@0:8@16Q24{_NSRange=QQ}32')
end
local function test_Method_setImplementation()
	-- test for function _Method:setImplementation(imp)
	local old_imp = method_1:setImplementation(imp)
	assert_eq(method_1:setImplementation(old_imp), imp)
end
local function test_Method_exchangeImplementations()
	-- test for function _Method:exchangeImplementations(other)
	method_1:exchangeImplementations(method_2)
	method_2:exchangeImplementations(method_1)
end
local all_test_func =
{
	test_Method_getName,
	test_Method___tostring,
	test_Method___concat,
	test_Method_getImplementation,
	test_Method_getTypeEncoding,
	test_Method_getNumberOfArguments,
	test_Method_getReturnType,
	test_Method_getArgumentType,
	test_Method_getDescription,
	test_Method_setImplementation,
	test_Method_exchangeImplementations,
}

for _, func in ipairs(all_test_func) do
	func()
end
