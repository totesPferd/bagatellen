local obj =  require "base.oop.obj"

local config =  obj:__new()
config.std_indent     =   3  -- indent in c++ programs
config.std_page_width =  72  -- page width

return config
