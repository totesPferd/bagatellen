package = 'base'
version = '0.0.1-001'

description = {
   summary = "some useful things which are useful in particular for OOP",
   detailed = [[Make it possible to program object-oriented as used.
Moreover it contains some data types.
   ]],
   license = 'MIT/X11',
}

supported_platforms = { 'unix' }

source = {
   url = 'git://github.com/totesPferd/bagatellen.git',
}

dependencies = { 'lua >= 5.1' }

build = {
   type = 'none',
   modules = {
      ['base.config']      =  "bagatellen/lua/base/config.lua",
      ['base.Indentation'] =  "bagatellen/lua/base/Indentation.lua",
      ['base.oop.obj']     =  "bagatellen/lua/base/oop/obj.lua",
      ['base.type.aux.Type'] =  "bagatellen/lua/base/type/aux/Type.lua",
      ['base.type.aux.Type_implementation']
         =  "bagatellen/lua/base/type/aux/Type_implementation.lua",
      ['base.type.Char']   =  "bagatellen/lua/base/type/Char.lua",
      ['base.type.Dict']   =  "bagatellen/lua/base/type/Dict.lua",
      ['base.type.List']   =  "bagatellen/lua/base/type/List.lua",
      ['base.type.Set']    =  "bagatellen/lua/base/type/Set.lua",
      ['base.type.String'] =  "bagatellen/lua/base/type/String.lua"
   }
}
