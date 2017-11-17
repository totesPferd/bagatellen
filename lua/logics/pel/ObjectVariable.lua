local MALEObjectVariable =  require "logics.male.ObjectVariable"

local ObjectVariable =  MALEObjectVariable:__new()

package.loaded["logics.pel.ObjectVariable"] =  ObjectVariable
-- fuer den Code, der eigentlich nicht hierhergehoert
local String =  require "base.type.String"

function ObjectVariable:new()
   return MALEObjectVariable.new(self)
end

function ObjectVariable:get_compound_expression()
end


-- tut mir leid, geht nicht besser zu machen!
-- ...gehört eigentlich nach logics.qpel
function ObjectVariable:get_chopped_qualifier_copy(qualifier)
   local retval
   local assgnm_val =  self.assgnm
   if assgnm_val
   then
      retval =  assgnm_val
   else
      retval =  self:new()
      self.assgnm =  retval

      local val =  self:get_val()
      if val
      then
         retval:set_val(
               val:get_chopped_qualifier_copy(qualifier) )
      end

   end
   return retval
end

function ObjectVariable:destruct_compound_expression(symbol, aritiy)
end

return ObjectVariable
