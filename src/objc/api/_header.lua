local ffi = require('ffi')

ffi.cdef[[
typedef struct objc_class *Class;
typedef struct objc_object *id;
typedef struct objc_selector *SEL;
typedef id (*IMP)(id, SEL, ...);

typedef signed char BOOL;
typedef const void* objc_objectptr_t;
typedef char *STR;
typedef struct objc_method *Method;
typedef struct objc_ivar *Ivar;
typedef struct objc_category *Category;
typedef struct objc_property *objc_property_t;
typedef struct objc_object Protocol;


enum objc_AssociationPolicy {
    OBJC_ASSOCIATION_ASSIGN = 0,
	OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1,
	OBJC_ASSOCIATION_COPY_NONATOMIC = 3,
	OBJC_ASSOCIATION_RETAIN = 01401,
	OBJC_ASSOCIATION_COPY = 01403
};
typedef enum objc_AssociationPolicy objc_AssociationPolicy;

/// Defines a method
struct objc_method_description {
	SEL name;               /**< The name of the method */
	char *types;            /**< The types of the method arguments */
};

/// Defines a property attribute
typedef struct {
    const char *name;           /**< The name of the attribute */
    const char *value;          /**< The value of the attribute (usually empty) */
} objc_property_attribute_t;

]]

ffi.cdef[[
id _objc_msgForward(id receiver, SEL sel, ...);
void _objc_msgForward_stret(id receiver, SEL sel, ...);

typedef id (*ForwardInvocation)(id assignSlf, SEL selector, id *invocation);
]]
local IMP = ffi.typeof('IMP')
local imp = IMP(ffi.C._objc_msgForward)
print(imp)

local forward_invocation = ffi.cast('ForwardInvocation', function()end)
local imp_forward_invocation = IMP(ffi.cast('IMP', forward_invocation))














