package = 'logics'
version = '0.0.1-001'

description = {
   summary = "some useful things which are useful in particular for OOP",
   detailed = [[Make it possible to program object-oriented as used.
Moreover it contains some data types.
   ]],
   license = 'MIT/X11'
}

supported_platforms = { 'unix' }

source = {
      url = 'git://github.com/totesPferd/bagatellen.git'
}

dependencies = { 'lua >= 5.1' }

build = {
      type = 'builtin'
   ,  modules = {
            ['bindings.redland'] =  {
                  sources = {
                        "c/lua/bindings/redland/defs.c"
                     ,  "c/lua/bindings/redland/formatter.c"
                     ,  "c/lua/bindings/redland/hash.c"
                     ,  "c/lua/bindings/redland/main.c"
                     ,  "c/lua/bindings/redland/model.c"
                     ,  "c/lua/bindings/redland/node.c"
                     ,  "c/lua/bindings/redland/parser.c"
                     ,  "c/lua/bindings/redland/query.c"
                     ,  "c/lua/bindings/redland/results.c"
                     ,  "c/lua/bindings/redland/serializer.c"
                     ,  "c/lua/bindings/redland/stmt.c"
                     ,  "c/lua/bindings/redland/store.c"
                     ,  "c/lua/bindings/redland/transaction.c"
                     ,  "c/lua/bindings/redland/uri.c"
                     ,  "c/lua/bindings/redland/world.c" }
               ,  libraries = {
                        "rdf" }
               ,  incdirs = {
                        "/usr/include/rasqal"
                     ,  "/usr/include/raptor2" }}
         ,  ['redland.BlankNode']   =  "lua/redland/BlankNode.lua"
         ,  ['redland.LiteralNode'] =  "lua/redland/LiteralNode.lua"
         ,  ['redland.Node']        =  "lua/redland/Node.lua"
         ,  ['redland.Uri']         =  "lua/redland/Uri.lua"
         ,  ['redland.UriNode']     =  "lua/redland/UriNode.lua"
         ,  ['redland.World']       =  "lua/redland/World.lua" }}
