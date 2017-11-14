local Type =  require "base.type.aux.Type"

local Concept =  Type:__new()

package.loaded["logics.ql.Concept"] =  Concept
local Qualifier =  require "logics.ql.Qualifier"

function Concept:new(symbol)
   local retval =  self:__new()
   retval.symbol =  symbol
   return retval
end

function Concept:get_symbol()
   return self.symbol
end

function Concept:get_base_qualifier()
   return self:get_symbol(), Qualifier:id_factory()
end

function Concept:get_concept()
   return self
end

function Concept:destruct_concept(concept)
   if self == concept
   then
      return self
   end
end

function Concept:equate(val)
   local other_concept =  val:destruct_concept(self)
   if other_concept
   then
      return true
   else
      return false
   end
end

function Concept:devar(var_assgnm)
   return self
end

function Concept:__eq(other)
   local retval =  false
   local other_concept =  other:get_concept()
   if other_concept
   then
      retval =
            self:get_symbol() == other:get_symbol()
   end
   return retval
end

return Concept
