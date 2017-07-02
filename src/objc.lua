local SELF = ...
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

setfenv(0, _M_ENV) -- for use SELF
local private = require(SELF .. '._private')
local import = private.import
-- private common functions
for k,v in pairs(private) do
	_M_ENV[k] = v
end

setfenv(0, _M_ENV)
_M.api = import('api.init')
_M.class = import('_class')
setfenv(0, _orig_G)

return _M