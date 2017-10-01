local Type =  require "base.type.aux.Type"

local Char =  Type:__new()


package.loaded["base.type.Char"] =  Char
require "base.type.aux.Type_implementation"
local String =  require "base.type.String"


--- Factory method factoring a char.
--  @param char lua character
--  @return char object
function Char:char_factory(char)
   local retval =  self:__new()
   retval.val =  char
   return retval
end

--- Factory method factoring a space.
--  @return space char object
function Char:space_factory()
   return self:char_factory(" ")
end

--- Factory method factoring a newline.
--  @return newline char object
function Char:newline_factory()
   return self:char_factory("\n")
end

--- Factory method factoring a carriage return.
--  @return carriage return char object
function Char:carriage_return_factory()
   return self:char_factory("\r")
end

--- Factory method factoring a form feed.
--  @return form feed char object
function Char:form_feed_factory()
   return self:char_factory("\f")
end

--- Factory method factoring a tab.
--  @return tab char object
function Char:tabulator_factory()
   return self:char_factory("\t")
end

--- Is it a space?
--  @return boolean
function Char:is_space()
   return self.val == " "
end

--- Is it a newline?
--  @return boolean
function Char:is_newline()
   return self.val == "\n"
end

--- Is it a carriage return?
--  @return boolean
function Char:is_carriage_return()
   return self.val == "\r"
end

--- Is it a form feed?
--  @return boolean
function Char:is_form_feed()
   return self.val == "\f"
end

--- Is it a tab?
--  @return boolean
function Char:is_tabulator()
   return self.val == "\t"
end

--- Getting the lua char.
--  @return lua char
function Char:get_content()
   return self.val
end

function Char:__eq(other_char)
   return self.val == other_char:get_content()
end

function Char:__tostring()
   return self.val
end

function Char:__diagnose_single_line(indentation)
   local line =  String:string_factory(
         string.format("(base::type::Char 0x%02X", self.val:byte()) )
   line:append_string(String:string_factory(")"))
   indentation:insert(line)
end

function Char:__diagnose_multiple_line(indentation)
   do
      local line =  String:string_factory("(base::type::Char\n\n")
      line:insert(line)
   end
   do
      local deeper_indentation =  indentation:get_deeper_indentation()
      local line
         =  String:string_factory(string.format("0x%02X", self.val:byte()))
      line:append_string(String:string_factory(" )"))
      deeper_indentation:insert(line)
      deeper_indentation:save()
   end
end
   
return Char
