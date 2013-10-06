package = 'url_encode'
version = '0.0.1-001'

description = {
   summary = "url encode",
   detailed = [[dito.
   ]],
   license = 'MIT/X11',
}

supported_platforms = { 'unix' }

source = {
   url = 'git://github.com/totesPferd/bagatellen.git'
}

dependencies = { 'lua >= 5.1' }

build = {
   type = 'builtin',
   modules = {
      [ 'urlEncode' ] =  "lua/urlEncode/bin/urlEncode.lua"
   },
}
