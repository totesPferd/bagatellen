local Type =  require "base.type.aux.Type"

local Spec =  Type:__new()


package.loaded["logics.mod.Spec"] =  Spec
local Dict =  require "base.type.Dict"
local Element =  require "logics.mod.Element"
local Indentation =  require "base.Indentation"
local Qualifier =  require "logics.mod.Qualifier"
local Set =  require "base.type.Set"
local String =  require "base.type.String"

function Spec:new()
   local retval =  Spec:__new()
   retval.elems =  Set:empty_set_factory()
   return retval
end

function Spec:get_elems()
   return self.elems
end

function Spec:add_elem(key)
   local qualifier =  Qualifier:id_factory()
   local elem =  Element:new(key, qualifier)
   self.elems:add(elem)
end

function Spec:append_qualword(qualword)
   for elem in self:get_elems():elems()
   do elem:append_qualword(qualword)
   end
end

function Spec:equate(qualword_a, qualword_b)
   if qualword_a == qualword_b
   then
      return
   end

-- Äquivalenzklassen
   local eq_c =  Dict:empty_dict_factory()
   for elem in self:get_elems():elems()
   do local qualifier =  elem:get_qualifier()
      for qualword in qualifier:get_qualwords():elems()
      do eq_c:add(qualword, qualifier)
      end
   end

-- Äquivalenzklassen erweitern
   local common_q =  eq_c:deref(qualword_a)
   common_q:equate(eq_c:deref(qualword_b))
   for qualword in eq_c:keys():elems()
   do    if qualword:is_final_seq(qualword_a)
      or qualword:is_final_seq(qualword_b)
      then
         eq_c:add(qualword, common_q)
      end
   end

-- Drop all elems where qualword_a occurs within
   local s_c =  self:get_elems():__clone()
   for elem in s_c:elems()
   do local qualifier =  elem:get_qualifier()
      if qualifier:is_in(qualword_a)
      then
         self:get_elems():drop(elem)
      end
   end

-- Replace all qualifier where qualword_b within
   for elem in self:get_elems():elems()
   do local qualifier =  elem:get_qualifier()
      if qualifier:is_in(qualword_b)
      then
         elem:set_qualifier(common_q:__clone())
      end
   end
end

function Spec:insert(other, qualword)
   local subspec =  other:__clone()
   subspec:append_qualword(qualword)
   self:get_elems():add_set(subspec:get_elems())
end

function Spec:__clone()
   local retval =  Spec:new()
   for elem in self:get_elems():elems()
   do retval:get_elems():add(elem:__clone())
   end
   return retval
end

function Spec:__eq(other)
   return self:get_elems() == other:get_elems()
end

function Spec:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(base.type.Spec"))
   for elem in self:get_elems():elems()
   do
      indentation:insert(String:string_factory(" "))
      elem:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Spec:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(base.type.Spec"))
   local is_last_elem_multiple_line =  true
   for elem in self:get_elems():elems()
   do
      indentation:insert_newline()
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line =
         elem:__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Spec
