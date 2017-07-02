local oc = require('objc')

local function main()
	local test_cases = {
	---------------- test cases for api ------------
		'test.api.category',
		'test.api.class',
		'test.api.enum',
		'test.api.imp',
		'test.api.instance',
		'test.api.ivar',
		'test.api.method',
		'test.api.objc',
		'test.api.object',
		'test.api.property',
		'test.api.protocol',
		'test.api.sel',
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