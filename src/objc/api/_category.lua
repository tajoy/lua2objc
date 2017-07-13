import('api._header')

-- TODO: implement api bridge for this below

local ffi = require('ffi')
ffi.cdef[[
id objc_retainedObject(objc_objectptr_t obj);
id objc_unretainedObject(objc_objectptr_t obj);
objc_objectptr_t objc_unretainedPointer(id obj);
]]




