local SimpleTerm =  require "logics.place.simple.Term"

local Term =  SimpleTerm:__new()

package.loaded["logics.place.qsimple.Term"] =  Term
local List =  require "base.type.List"
local QSimpleSymbol =  require "logics.place.qsimple.Symbol"
local Qualifier =  require "logics.place.qualified.Qualifier"

function Term:new(symbol, args)
   return SimpleTerm.new(self, symbol, args)
end

function Term:clone()
   local new_symbol =  self:get_symbol():clone()
   local new_args =  List:empty_list_factory()
   for arg in self:get_args():elems()
   do new_args:append(arg:clone())
   end
   return self:new(new_symbol, new_args)
end

function Term:apply_qualifier(qualifier)
   self:get_symbol():apply_qualifier(qualifier)
   for arg in self:get_args():elems()
   do arg:apply_qualifier(qualifier)
   end
end

function Term:__eq(other)
   local other_term =  other:get_term():is_system("qsimple")
   if other_term
   then
      return
            self:get_symbol() == other:get_symbol()
        and self:get_args() == other:get_args()
   else
      return false
   end
end

function Term:is_system(system)
   if system == "qsimple"
   then
      return self
   end
end

function Term:get_chopped_qualifier_copy(qualifier)
   local new_qual =  self:get_qualifier():get_rhs_chopped_copy(
         qualifier )
   local base =  self:get_base()
   if base
   then
      local new_symbol =  base:get_symbol():get_chopped_qualifier_copy(
            qualifier )
   -- for map function
      local new_args =  List:empty_list_factory()
      for arg in self:args():elems()
      do new_args:append(arg:get_chopped_qualifier_copy(qualifier))
      end
      return Term:new(new_symbol, new_args)
   end
end

function Term:get_base()
   local qualifier =  self:get_qualifier()
   if qualifier
   then
      if qualifier:is_id()
      then
         return self
      else
         local qsymbol =  self:get_symbol():is_system("qsimple")
         if qsymbol
         then
            local new_symbol =  qsymbol:get_chopped_qualifier_copy(
                  qualifier )
-- good for map:
            local new_args =  List:empty_list_factory()
            for arg in self:get_args():elems()
            do local qarg =  arg:is_system("qsimple")
               if qarg
               then
                  new_args:append(qarg:get_chopped_qualifier_copy(
                        qualifier ))
               else
                  return
               end
            end
            return self:new(new_symbol, new_args)
         end
      end
   end
end

function Term:get_qualifier()
   local qsimple_symbol =  self:get_symbol():is_system("qsimple")
   if qsimple_symbol
   then
      local qualifier_accu =  qsimple_symbol:get_qualifier()
      for arg in self:get_args():elems()
      do local qualifier_aux =  qualifier_accu:get_longest_common_tail(
               arg:get_qualifier() )
         if qualifier_aux
         then
            qualifier_accu =  qualifier_aux
         else
            return Qualifier:id_factory()
         end
      end
      return qualifier_accu
   end
end

return Term
