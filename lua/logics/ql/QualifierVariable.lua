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

function QualifierVariable:is_lhs_seq(qualifier)
   retval =  true
   local this_val =  self:get_val()
   if this_val
   then
      retval =  this_val:is_lhs_seq(qualifier)
   end
   return retval
end

function QualifierVariable:get_rhs_chopped_copy(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_rhs_chopped_copy(qualifier)
   end
end

return QualifierVariable
