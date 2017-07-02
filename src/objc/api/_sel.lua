import('api._header')

-- TODO: implement api bridge for this below

local ffi = require('ffi')
ffi.cdef[[
const char *sel_getName(SEL sel);
SEL sel_registerName(const char *str);
const char *object_getClassName(id obj);
void *object_getIndexedIvars(id obj);
BOOL sel_isMapped(SEL sel);
SEL sel_getUid(const char *str);
const char *sel_getName(SEL sel);
SEL sel_registerName(const char *str);
BOOL sel_isEqual(SEL lhs, SEL rhs);
]]


