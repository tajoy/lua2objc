import('api._header')

-- TODO: implement api bridge for this below

local ffi = require('ffi')
ffi.cdef[[
id class_createInstance(Class cls, size_t extraBytes);
id objc_constructInstance(Class cls, void *bytes);
void *objc_destructInstance(id obj);

]]