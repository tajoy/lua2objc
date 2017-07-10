
local _print = print
print = function(...)
	_print(...)
	io.flush()
end
require('test.test_func')


local function main()
	local test_cases = {
	---------------- test cases for api ------------
		'test.api.objc', -- this is basement api, so test first

		'test.api.category',
		'test.api.class',
		'test.api.enum',
		'test.api.imp',
		'test.api.ivar',
		'test.api.method',
		'test.api.object',
		'test.api.property',
		'test.api.protocol',
		'test.api.sel',
	---------------- test cases for bridges ------------
		'test.Private',
		'test.Class',
	}
	local isSomeoneFailure = false
	for i, v in ipairs(test_cases) do
		print('running #' .. tostring(i) .. ' test case: ' .. v)
		xpcall(require, function(err)
			isSomeoneFailure = true
			print('run test failure: ' .. v)
			if err then
				print(err)
			end
			print(debug.traceback())
		end, v)
	end
	if isSomeoneFailure then
		print("===== test failure, there is something wrong =====")
	else
		print("test success !")
	end
end

main()