local api = {}

api.Category = import('api._category')
api.Class    = import('api._class')
api.Enum     = import('api._enum')
api.IMP      = import('api._imp')
api.Ivar     = import('api._ivar')
api.Method   = import('api._method')
api.objc     = import('api._objc')
api.Object   = import('api._object')
api.Property = import('api._property')
api.Protocol = import('api._protocol')
api.SEL      = import('api._sel')

return api