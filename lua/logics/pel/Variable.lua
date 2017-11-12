local MALEVariable =  require "logics.male.Variable"

local Variable =  MALEVariable:__new()

package.loaded["logics.pel.Variable"] =  Variable
-- fuer den Code, der eigentlich nicht hierhergehoert
local Constants =  require "logics.pel.Constants"
local String =  require "base.type.String"
local ql_dimension =  String:string_factory("ql")

function Variable:new()
   return MALEVariable.new(self)
end

function Variable:get_compound_expression()
end


-- tut mir leid, geht nicht besser zu machen!
-- ...gehört eigentlich nach logics.qpel
function Variable:get_chopped_qualifier_copy(qualifier)
   local retval
   local assgnm_val =  self:get_val(ql_dimension)
   if assgnm_val
   then
      retval =  assgnm_val
   else
      retval =  self:new()
      self:set_val(ql_dimension, retval)

      local val =  self:get_val(Constants.dimension)
      if val
      then
         retval:set_val(
               Constants.dimension
           ,   val:get_chopped_qualifier_copy(qualifier) )
      end

   end
   return retval
end

return Variable
