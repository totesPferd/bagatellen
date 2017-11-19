local MALEObjectVariable =  require "logics.male.ObjectVariable"

local ObjectVariable =  MALEObjectVariable:__new()

package.loaded["logics.qualifier.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new()
   return MALEObjectVariable.new(self)
end

function ObjectVariable:get_compound_qualifier_cast()
end

function ObjectVariable:is_id()
   local this_val =  self:get_val()
   if this_val
   then
      return false
   else
      return true
   end
end

function ObjectVariable:get_name()
   return String:empty_string_factory()
end

function ObjectVariable:destruct_terminal(terminal)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:destruct_terminal(terminal)
   end
end

function ObjectVariable:get_lhs_chopped(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_lhs_chopped(qualifier)
   elseif qualifier:is_id()
   then
      return self
   end
end

function ObjectVariable:get_rhs_chopped_copy(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_rhs_chopped_copy(qualifier)
   elseif qualifier:is_id()
   then
      return self:copy(), qualifier
   end
end

function ObjectVariable:lu(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:lu(qualifier)
   else
      self:set_val(qualifier)
      return true
   end
end

function ObjectVariable:append_qualifier(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      this_val:append_qualifier(qualifier)
   else
      self:set_val(qualifier)
   end
end

function ObjectVariable:get_id_qualifier_end()
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_id_qualifier_end()
   else
      return self
   end
end

return ObjectVariable
