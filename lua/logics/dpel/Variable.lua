local PELVariable =  require "logics.pel.Variable"

local Variable =  PELVariable:__new()

package.loaded["logics.dpel.Variable"] =  Variable
local String =  require "base.type.String"

local pel_dimension =  String:string_factory("pel")

function Variable:new()
   return PELVariable.new(self)
end

function Variable:get_name()
   return self.name
end

function Variable:set_name(name)
   self.name =  name
end

function Variable:get_non_nil_name()
   return self:get_name() or String:string_factory("?")
end

function Variable:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::dpel::Variable "))
   indentation:insert(self:get_non_nil_name())
   local val =  self:get_val(pel_dimension)
   if val
   then
      indentation:insert(String:string_factory(" "))
      val:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Variable:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true

   indentation:insert(String:string_factory("(logics::dpel::term::Variable"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(self:get_non_nil_name())
   local val =  self:get_val(pel_dimension)
   if val
   then
      deeper_indentation:insert_newline()
      is_last_elem_multiple_line
         =  val:__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Variable
