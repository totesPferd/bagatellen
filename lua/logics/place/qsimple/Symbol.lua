local SimpleSymbol =  require "logics.place.simple.Symbol"

local Symbol =  SimpleSymbol:__new()

package.loaded["logics.place.qsimple.Symbol"] =  Symbol

function Symbol:qualifying_factory(base, qualifier)
   local retval =  SimpleSymbol.new(self)
   retval.base =  base
   retval.qualifier =  qualifier
   return retval
end

function Symbol:clone()
   local qual_clone =  self.qualifier:__clone()
   return self:qualifying_factory(base, qual_clone)
end

function Symbol:apply_qualifier(qualifier)
   self.qualifier:append_qualifier(qualifier)
end

function Symbol:__eq(other)
   return
         self.base == other.base
     and self.qualifier == other.qualifier
end

function Symbol:get_chopped_qualifier_copy(qualifier)
   local new_qual =  self:get_qualifier():get_rhs_chopped_copy(qualifier)
   return self:qualifying_factory(self:get_base(), new_qual)
end

function Symbol:is_system(system)
   if system == "qsimple"
   then
      return self
   end
end

function Symbol:get_base()
   local qsimple_base_symbol =  self.base:is_system("qsimple")
   if qsimple_symbol
   then
      return self.base:get_base()
   else
      return self.base
   end
end

function Symbol:get_qualifier()
   local qsimple_base_symbol =  self.base:is_system("qsimple")
   if qsimple_symbol
   then
      local base_qualifier =  self.base:get_qualifier():__clone()
      base_qualifier:append_qualifier(self.qualifier)
      return base_qualifier
   else
      return self.qualifier
   end
end

return Symbol
