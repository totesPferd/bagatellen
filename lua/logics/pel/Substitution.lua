local Type =  require "base.type.aux.Type"

local Substitution =  Type:__new()

package.loaded["logics.pel.Substitution"] =  Substitution
local Dict =  require "base.type.Dict"
local Skolem =  require "logics.pel.term.Skolem"

function Substitution:new(d0, d1)
   local retval =  Substitution:__new()
   retval.d0 =  d0
   retval.d1 =  d1
   retval.s =  Dict:empty_dict_factory()
   return retval
end

function Substitution:get_d0()
   return self.d0
end

function Substitution:get_d1()
   return self.d1
end

function Substitution:deref(variable)
   return self.s:deref(variable)
end

function Substitution:complete()
   for variable in self:get_d1():get_variable_list():elems()
   do if not self.s:is_in_key_set(variable)
      then
         self.s:add(variable, Skolem:new(self:get_d0(), variable:get_sort()))
      end
   end
end

function Substitution:get_substituted(substitution)
   local new_d0 =  substitution:get_d0()
   local new_substitution =  Substitution:new(new_d0, self:get_d1())
   for variable, term in self.s:elems()
   do new_substitution:assign(
         variable
      ,  term:get_substituted(substitution) )
   end
   return new_subsitution
end

function Substitution:is_assigned(variable)
   return self.s:is_in_key_set(variable)
end

function Substitution:assign(variable, term)
   self.s:add(variable, term)
end

return Substitution
