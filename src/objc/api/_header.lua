local ffi = require('ffi')

ffi.cdef[[

void * malloc(unsigned int);
void free(void*);

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

struct objc_method_description_list {
        int count;
        struct objc_method_description list[1];
};

/// Defines a property attribute
typedef struct {
    const char *name;           /**< The name of the attribute */
    const char *value;          /**< The value of the attribute (usually empty) */
} objc_property_attribute_t;

/// Specifies the superclass of an instance. 
struct objc_super {
    /// Specifies an instance of a class.
    id receiver;

    /// Specifies the particular superclass of the instance to message. 
    /* For compatibility with old objc-runtime.h header */
    Class class;
    Class super_class;
    /* super_class is the first class to search */
};

id objc_msgSend(id self, SEL op, ...);
id objc_msgSendSuper(struct objc_super *super, SEL op, ...);
void objc_msgSend_stret(id self, SEL op, ...);
void objc_msgSendSuper_stret(struct objc_super *super, SEL op, ...);
id _objc_msgForward(id receiver, SEL sel, ...);
void _objc_msgForward_stret(id receiver, SEL sel, ...);

typedef void* marg_list;

id objc_msgSendv(id self, SEL op, size_t arg_size, marg_list arg_frame);
void objc_msgSendv_stret(void *stretAddr, id self, SEL op, size_t arg_size, marg_list arg_frame);
]]

-- ffi.cdef[[
-- id _objc_msgForward(id receiver, SEL sel, ...);
-- void _objc_msgForward_stret(id receiver, SEL sel, ...);

-- typedef id (*ForwardInvocation)(id assignSlf, SEL selector, id *invocation);
-- ]]
-- local IMP = ffi.typeof('IMP')
-- local imp = IMP(ffi.C._objc_msgForward)
-- print(imp)

-- local forward_invocation = ffi.cast('ForwardInvocation', function()end)
-- local imp_forward_invocation = IMP(ffi.cast('IMP', forward_invocation))






