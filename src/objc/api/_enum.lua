import('api._header')

-- TODO: implement api bridge for this below
local ffi = require('ffi')
ffi.cdef[[
void objc_enumerationMutation(id obj);
void objc_setEnumerationMutationHandler(void (*handler)(id));
void objc_setForwardHandler(void *fwd, void *fwd_stret);

]]