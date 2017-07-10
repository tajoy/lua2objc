SELF = 'objc'
local priv = require('objc._Private')



local function test_convertMethodName()
	assert_eq(convertMethodName(''), '')
	assert_eq(convertMethodName('method'), 'method')
	assert_eq(convertMethodName('_method'), '_method')
	assert_eq(convertMethodName('__method'), '_method')
	assert_eq(convertMethodName('___method'), '_:method')
	assert_eq(convertMethodName('____method'), '__method')
	assert_eq(convertMethodName('_____method'), '__:method')

	assert_eq(convertMethodName('method_'), 'method:')

	assert_eq(convertMethodName('method__'), 'method_')
	assert_eq(convertMethodName('method___'), 'method_:')
	assert_eq(convertMethodName('method____'), 'method__')
	assert_eq(convertMethodName('method_____'), 'method__:')


	assert_eq(convertMethodName('method__method__'), 'method_method_')
	assert_eq(convertMethodName('method___method___'), 'method_:method_:')
	assert_eq(convertMethodName('method____method____'), 'method__method__')
	assert_eq(convertMethodName('method_____method_____'), 'method__:method__:')
end




















local _orig_G = {}
local _M = {}
local _M_ENV = {}

for k,v in pairs(_ENV or _G) do
	_orig_G[k] = v
	if k ~= '_G' then
		_M_ENV[k] = v
	end
end

--  used for relatively require
_M_ENV.SELF = SELF

for k,v in pairs(priv) do
	_M_ENV[k] = v
end

setfenv(test_convertMethodName, _M_ENV)()




