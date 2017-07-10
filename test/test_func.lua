

function assert_eq(arg1, arg2)
	if arg1 ~= arg2 then
		error('assert failed: arg1: "' .. tostring(arg1) .. '" and arg2: "' .. tostring(arg2) .. '" not equal!')
	end
end


