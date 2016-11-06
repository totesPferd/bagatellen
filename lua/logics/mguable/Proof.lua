local Super =  require "logics.male.Proof"

local Proof =  Super:__new()


package.loaded["logics.mguable.Proof"] =  Proof
local Dict =  require "base.type.Dict"
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Proof:new()
   return Super.new(self)
end

function Proof:deref(goal)
   for key, rule in self.action:elems()
   do local mgu =  goal:mgu(key)
      if mgu
      then
         return rule:__clone():apply_substitution(mgu)
      end
   end
end

function Proof:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.mguable.Proof "))
   self.action:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Proof:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.mguable.Proof"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self.action:__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Proof
