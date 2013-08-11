package = 'get_cyrillic'
version = '0.0.1-001'

description = {
   summary = "converts Latin to Russian letters",
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
      [ 'getCyrillic' ] =  "lua/getCyrillic/bin/getCyrillic.lua"
   },
}
