
local ffi = require('ffi')

local _M = {}

function _M.import(name)
	return require(SELF .. "." .. name)
end

function _M.try_import(name)
	local ok , ret = xpcall(_M.import, function(err)
			print('try import failure: ' .. name)
			if err then
				print(err)
			end
			print(debug.traceback())
		end, name)
	return ret
end

function _M.checkArg(ctype, arg)
	if not ffi.istype(ctype, arg) then
		error('expected ' .. ctype .. ', but it is ' .. tostring(arg))
	end
	return arg
end

function _M.checkStringArg(arg)
	if type(arg) ~= 'string' then
		error('expected string, but it is ' .. type(arg))
	end
	return arg
end

function _M.checkNumberArg(arg)
	if type(arg) ~= 'number' then
		error('expected number, but it is ' .. type(arg))
	end
	return arg
end

function _M.checkBooleanArg(arg)
	if type(arg) ~= 'boolean' then
		error('expected boolean, but it is ' .. type(arg))
	end
	return arg
end

function _M.checkFunctionArg(arg)
	if type(arg) ~= 'function' then
		error('expected function, but it is ' .. type(arg))
	end
	return arg
end

function _M.checkArrayArg(ctype, arg)
	if type(arg) ~= 'table' then
		error('expected table(array type), but it is ' .. type(arg))
		return arg
	end
	for i, v in ipairs(arg) do
		if not ffi.istype(ctype, v) then
			error('arg[' .. i .. '] expected ' .. ctype .. ', but it is ' .. type(arg))
			return arg
		end
	end
	return arg
end

function _M.toboolean(var)
	local n = tonumber(var)
	if n == 0 or n == nil then
		return false
	end
	return true
end

function _M.exportMethodTable(typeName, exportTable, methodTable)
	for name, method in pairs(methodTable) do
		if type(method) == 'function' then
			exportTable[name] = function(self, ...)
				if typeName then
					self = checkArg(typeName, self)
				end
				return method(self, ...)
			end
		end
	end
	return exportTable
end

return _M





