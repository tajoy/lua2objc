import('api._header')

-- TODO: implement api bridge for this below

local ffi = require('ffi')
ffi.cdef[[
const char *ivar_getName(Ivar v);
const char *ivar_getTypeEncoding(Ivar v);
ptrdiff_t ivar_getOffset(Ivar v);
]]