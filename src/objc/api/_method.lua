import('api._header')

-- TODO: implement api bridge for this below

local ffi = require('ffi')
ffi.cdef[[
SEL method_getName(Method m);
IMP method_getImplementation(Method m);
const char *method_getTypeEncoding(Method m);
unsigned int method_getNumberOfArguments(Method m);
char *method_copyReturnType(Method m);
char *method_copyArgumentType(Method m, unsigned int index);
void method_getReturnType(Method m, char *dst, size_t dst_len);
void method_getArgumentType(Method m, unsigned int index, 
                                        char *dst, size_t dst_len);
struct objc_method_description *method_getDescription(Method m);
IMP method_setImplementation(Method m, IMP imp);
void method_exchangeImplementations(Method m1, Method m2);
unsigned int method_getSizeOfArguments(Method m);
unsigned method_getArgumentInfo(struct objc_method *m, int arg, const char **type, int *offset);
]]