local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Stream =  Type:__new()

package.loaded["redland.Stream"] =  Stream
local Indentation =  require "base.Indentation"
local Node =  require "redland.Node"
local Stmt =  require "redland.Stmt"
local String =  require "base.type.String"

function Stream:bindings_stream_factory(bindings_stream)
   local retval =  Stream:__new()
   retval.val =  bindings_stream
   return retval
end

function Stream:elems()
   function f(s, var)
      if not s:is_eos()
      then
         local ctxt =  s:get_context()
         local stmt =  s:get_stmt()
         s:next()
         return stmt, ctxt
      end
   end
   return f, self
end

function Stream:get_context()
   local raw_context =  bindings_redland_module.stream.get_context(
         self:get_bindings_stream() )
   if raw_context
   then
      return Node:bindings_node_factory(raw_context)
   end
end

function Stream:get_stmt()
   local raw_stmt =  bindings_redland_module.stream.get_stmt(
         self:get_bindings_stream() )
   if raw_context
   then
      return Stmt:bindings_stmt_factory(raw_stmt)
   end
end

function Stream:is_eos()
   return bindings_redland_module.stream.is_eos(
         self:get_bindings_stream() )
end

function Stream:new_empty(world, stream_string)
   local bindings_world =  world:get_bindings_world()
   local bindings_stream =  bindings_redland_module.stream.new_empty(
         bindings_world )
   return self:bindings_stream_factory(bindings_stream)
end

function Stream:next()
   return bindings_redland_module.stream.next(
         self:get_bindings_stream() )
end

function Stream:get_bindings_stream()
   return self.val
end

function Stream:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland.Stream)" ))
end

function Stream:__diagnose_multiple_line(indentation)
   return Stream:__diagnose_single_line(indentation)
end

return Stream


