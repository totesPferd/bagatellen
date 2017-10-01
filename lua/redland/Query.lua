local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Query =  Type:__new()


package.loaded["redland.Query"] =  Query
local Indentation =  require "base.Indentation"
local Results =  require "redland.Results"
local String =  require "base.type.String"

function Query:bindings_query_factory(bindings_query)
   local retval =  Query:__new()
   retval.val =  bindings_query
   return retval
end

function Query:get_bindings_query()
   return self.val
end

function Query:execute(model)
   return Results:bindings_results_factory(
        bindings_redland_module.query.execute(
              self:get_bindings_query()
           ,  model:get_bindings_model() ))
end

function Query:get_limit()
   return bindings_redland_module.query.get_limit(
         self:get_bindings_query() )
end

function Query:get_offset()
   return bindings_redland_module.query.get_offset(
         self:get_bindings_query() )
end

function Query:new(world, name, query_string)
   return Results:bindings_results_factory(
         bindings_redland_module.query.new(
               world:get_bindings_world()
            ,  name
            ,  query_string ))
end

function Query:set_limit(val)
   return bindings_redland_module.query.set_limit(
         self:get_bindings_query()
      ,  val )
end

function Query:set_offset(val)
   return bindings_redland_module.query.set_offset(
         self:get_bindings_query()
      ,  val )
end

function Query:__clone()
   return self:bindings_query_factory(bindings_redland_module.query.__clone(self:get_bindings_query()))
end

function Query:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland::Query)" ))
end

function Query:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Query

