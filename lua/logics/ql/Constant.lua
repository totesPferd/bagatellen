local Type =  require "base.type.aux.Type"

local Constant =  Type:__new()

package.loaded["logics.ql.Constant"] =  Constant
local Qualifier =  require "logics.ql.Qualifier"

function Constant:new(symbol)
   local retval =  self:__new()
   retval.symbol =  symbol
   return retval
end

function Constant:get_symbol()
   return self.symbol
end

function Constant:get_base_qualifier()
   return self:get_symbol(), Qualifier:id_factory()
end

function Constant:get_variable()
end

function Constant:get_constant()
   return self
end

function Constant:be_a_variable(variable)
end

function Constant:destruct_constant(constant)
   if self == constant
   then
      return self
   end
end

function Constant:equate(val)
   local other_constant =  val:destruct_constant(self)
   if other_constant
   then
      return true
   else
      return false
   end
end

function Constant:devar(var_assgnm)
   return self
end

function Constant:__eq(other)
   local retval =  false
   local other_constant =  other:get_constant()
   if other_constant
   then
      retval =
            self:get_symbol() == other:get_symbol()
   end
   return retval
end

return Constant
