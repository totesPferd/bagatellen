local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local World =  Type:__new()


package.loaded["redland.World"] =  World
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function World:bindings_world_factory(bindings_world)
   local retval =  World:__new()
   retval.val =  bindings_world
   return retval
end

function World:new()
   local bindings_world =  bindings_redland_module.world.new()
   return(self:bindings_world_factory(bindings_world))
end

function World:get_bindings_world()
   return self.val
end

function World:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland::World)" ))
end

function World:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return World


