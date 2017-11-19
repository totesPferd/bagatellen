local MALEObjectVariable =  require "logics.male.ObjectVariable"

local ObjectVariable =  MALEObjectVariable:__new()

package.loaded["logics.qualifier.ObjectVariable"] =  ObjectVariable
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function ObjectVariable:new()
   local retval =  MALEObjectVariable.new(self)
   return retval
end

function ObjectVariable:get_compound_qualifier_cast()
end

function ObjectVariable:get_name()
   return String:empty_string_factory()
end

function ObjectVariable:destruct_terminal(q, terminal)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:destruct_terminal(q, terminal)
   end
end

function ObjectVariable:get_lhs_chopped(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_lhs_chopped(qualifier)
   else
      return qualifier
   end
end

return ObjectVariable
