local MALEVariable =  require "logics.male.Variable"

local Variable =  MALEVariable:__new()

package.loaded["logics.pel.Variable"] =  Variable
-- fuer den Code, der eigentlich nicht hierhergehoert
local Constants =  require "logics.pel.Constants"

function Variable:new()
   return MALEVariable.new(self)
end

function Variable:get_compound_expression()
end


-- tut mir leid, geht nicht besser zu machen!
-- ...gehört eigentlich nach logics.qpel
function Variable:get_chopped_qualifier_copy(var_assgnm, qualifier)
   local retval
   local assgnm_val =  var_assgnm:deref(self)
   if assgnm_val
   then
      retval =  assgnm_val
   else
      retval =  self:new()
      var_assgnm:add(var, new_var)

      local val =  self:get_val(Constants.dimension)
      if val
      then
         retval:set_val(
               Constants.dimension
           ,   val:get_chopped_qualifier_copy(var_assgnm, qualifier) )
      end

   end
   return retval
end

return Variable
