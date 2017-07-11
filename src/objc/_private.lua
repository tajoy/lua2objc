
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
		if type(v) ~= ctype and not ffi.istype(ctype, v) then
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

local function _getType(name)
	local real_name = tostring(ffi.typeof(name))
	real_name = string.gsub(real_name, 'ctype<', '')
	real_name = string.gsub(real_name, '*>', '')
	real_name = string.gsub(real_name, '>', '')
	return real_name
end


function _M.exportWithMetaTable(exportTable, metaTable, typeName, refTypeName)
	metaTable.__index = function(self, name)
		-- print('call api: ' .. typeName .. '::' .. name)
		return metaTable[name]
	end
	if refTypeName then
		ffi.metatype(refTypeName, metaTable)
	else
		ffi.metatype(_getType(typeName), metaTable)
	end
	for name, method in pairs(metaTable) do
		if type(method) == 'function' then
			exportTable[name] = function(self, ...)
				if typeName then
					self = checkArg(typeName, self)
				end
				return method(self, ...)
			end
		end
	end
	for k,v in pairs(exportTable) do
		if type(v) == 'function' then
			exportTable[k] = function(...)
				-- print('call api: ' .. typeName .. '::' .. name)
				return v(...)
			end
		end
	end
	return exportTable
end

function _M.convertValueLua2OC(value)
	return value
end

function _M.convertValueOC2Lua(value)
	return value
end

function _M.convertArgsLua2OC(args)
	for k, v in pairs(args) do
		args[k] = ffi.cast('id', v)
	end
	return args
end

function _M.convertArgsOC2Lua(args)
	return args
end

function _M.convertMethodName(method_name)
	method_name = string.gsub(method_name, '__', '$')
	method_name = string.gsub(method_name, '^(_+)', function(parm)
			return string.gsub(parm, '_', '$')
		end)
	method_name = string.gsub(method_name, '_', ':')
	method_name = string.gsub(method_name, '%$', '_')
	return method_name
end

local cache_type_msgSend_x = {}
local msg_Send_def_1 = 'typedef void* (*___)(void* self, void* op'
local msg_Send_def_2 = ', void* arg'
local msg_Send_def_3 = ')'
function _M.callMethod(sender, method, args)
	local method_args_count = method:getNumberOfArguments()
	-- local send_func_type = cache_type_msgSend_x[method_args_count]
	-- if send_func_type == nil then
	-- 	local cdef_type_str = msg_Send_def_1
	-- 	local cdef_type_str = string.gsub(msg_Send_def_1, '___', '_objc_send_Msg_' .. method_args_count)
	-- 	for i = 1, method_args_count do
	-- 		cdef_type_str = cdef_type_str .. msg_Send_def_2 .. tostring(i)
	-- 	end
	-- 	cdef_type_str = cdef_type_str .. msg_Send_def_3 .. ';'
	-- 	print('cdef_type_str:', cdef_type_str)
	-- 	ffi.cdef(cdef_type_str)
	-- 	send_func_type = ffi.typeof('_objc_send_Msg_' .. method_args_count)
	-- 	cache_type_msgSend_x[method_args_count] = send_func_type
	-- end
	-- print('send_func_type:', send_func_type)
	-- print(ffi.typeof('void* (*)(void* self, void* op, void* arg1, void* arg2, void* arg3)'))
	-- FIXME: arguments count and type correct check
	local sel = method:getName()
	-- local imp = method:getImplementation()
	args = _M.convertArgsLua2OC(args)
	-- return ffi.cast(send_func_type, imp)(ffi.cast('id', sender), sel, unpack(args))
	return _M.convertValueOC2Lua(ffi.C.objc_msgSend(ffi.cast('id', sender), sel, unpack(args)))
end

return _M










