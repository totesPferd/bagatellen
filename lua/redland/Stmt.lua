local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Stmt =  Type:__new()

package.loaded["redland.Stmt"] =  Stmt
local Indentation =  require "base.Indentation"
local Node =  require "redland.Node"
local String =  require "base.type.String"

function Stmt:bindings_stmt_factory(bindings_stmt)
   local retval =  Stmt:__new()
   retval.val =  bindings_stmt
   return retval
end

function Stmt:apply_substitution(substitution)
   local subject =  self:get_subject()
   local object =  self:get_object()
   if subject
   then
      self:set_subject(subject:apply_substitution(substitution))
   end
   if object
   then
      self:set_object(object:apply_substitution(substitution))
   end
   return
end

function Stmt:clear()
   bindings_redland_module.stmt.clear(self:get_bindings_stmt())
end

function Stmt:get_bindings_stmt()
   return self.val
end

function Stmt:get_object()
   local bindings_node
      =  bindings_redland_module.stmt.get_object(self:get_bindings_stmt())
   if bindings_node
   then
      return Node:bindings_node_factory(bindings_node)
   end
end

function Stmt:get_predicate()
   local bindings_node
      =  bindings_redland_module.stmt.get_predicate(self:get_bindings_stmt())
   if bindings_node
   then
      return Node:bindings_node_factory(bindings_node)
   end
end

function Stmt:get_subject()
   local bindings_node
      =  bindings_redland_module.stmt.get_subject(self:get_bindings_stmt())
   if bindings_node
   then
      return Node:bindings_node_factory(bindings_node)
   end
end

function Stmt:is_complete()
   return bindings_redland_module.stmt.is_complete(self:get_bindings_stmt())
end

function Stmt:is_match(other)
   return bindings_redland_module.stmt.is_match(
         self:get_bindings_stmt()
      ,  other:get_bindings_stmt() )
end

function Stmt:new(world)
   local bindings_world =  world:get_bindings_world()
   local bindings_stmt =  bindings_redland_module.stmt.new(
         bindings_world )
   return self:bindings_stmt_factory(bindings_stmt)
end

function Stmt:set_object(node)
   bindings_redland_module.stmt.set_object(
         self:get_bindings_stmt()
      ,  node:get_bindings_node() )
end

function Stmt:set_predicate(node)
   bindings_redland_module.stmt.set_predicate(
         self:get_bindings_stmt()
      ,  node:get_bindings_node() )
end

function Stmt:set_subject(node)
   bindings_redland_module.stmt.set_subject(
         self:get_bindings_stmt()
      ,  node:get_bindings_node() )
end

function Stmt:__clone()
   return Stmt:bindings_stmt_factory(
         bindings_redland_module.stmt.__clone(self:get_bindings_stmt()) )
end

function Stmt:__eq(other)
   return self:get_bindings_stmt() == other:get_bindings_stmt()
end

function Stmt:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(redland::Stmt "))
   self:get_subject():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_predicate():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_subject():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Stmt:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(redland::Stmt"))
   indentation:insert_newline()
   local is_last_elem_multiple_line =  true
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      self:get_subject():__diagnose_complex(deeper_indentation)
      deeper_indentation:insert_newline()
      self:get_predicate():__diagnose_complex(deeper_indentation)
      deeper_indentation:insert_newline()
      is_last_elem_multiple_line
         =  self:get_object():__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Stmt


