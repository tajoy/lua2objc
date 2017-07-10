local api = {}

api.category = import('api._category')
api.class    = import('api._class')
api.enum     = import('api._enum')
api.imp      = import('api._imp')
api.ivar     = import('api._ivar')
api.method   = import('api._method')
api.objc     = import('api._objc')
api.object   = import('api._object')
api.property = import('api._property')
api.protocol = import('api._protocol')
api.sel      = import('api._sel')

return api