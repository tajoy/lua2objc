import('api._header')

-- TODO: implement api bridge for this below

local ffi = require('ffi')
ffi.cdef[[
IMP imp_implementationWithBlock(id block);
id imp_getBlock(IMP anImp);
BOOL imp_removeBlock(IMP anImp);
]]





