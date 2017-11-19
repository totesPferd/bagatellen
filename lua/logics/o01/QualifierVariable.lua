local MALEVariable =  require "logics.male.Variable"

local QualifierVariable =  MALEVariable:__new()

package.loaded["logics.ql.QualifierVariable"] =  QualifierVariable

function QualifierVariable:new()
   return MALEVariable:__new(self)
end

function QualifierVariable:get_qualifier_variable()
   return self
end

function QualifierVariable:get_compound_variable()
end

function QualifierVariable:is_id()
   local this_val =  self:get_val()
   if this_val
   then
      return false
   else
      return true
   end
end

function QualifierVariable:get_name()
   return String:empty_string_factory()
end

function QualifierVariable:destruct_terminal(terminal)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:destruct_terminal(terminal)
   end
end

function QualifierVariable:get_lhs_chopped(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_lhs_chopped(qualifier)
   elseif qualifier:is_id()
   then
      return self
   end
end

function QualifierVariable:get_rhs_chopped_copy(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_rhs_chopped_copy(qualifier)
   elseif qualifier:is_id()
   then
      return self:copy(), qualifier
   end
end

function QualifierVariable:append_qualifier(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      this_val:append_qualifier(qualifier)
   else
      self:set_val(qualifier)
   end
end

function QualifierVariable:lu(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:lu(qualifier)
   else
      self:set_val(qualifier)
      return true
   end
end

function QualifierVariable:get_id_qualifier_end()
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_id_qualifier_end()
   else
      return self
   end
end

return QualifierVariable
