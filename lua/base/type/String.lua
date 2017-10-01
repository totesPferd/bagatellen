local Type =  require "base.type.aux.Type"

local String =  Type:__new()

package.loaded["base.type.String"] =  String
require "base.type.aux.Type_implementation"
local Char =  require "base.type.Char"


--- Factory method factoring string related to a lua string.
--  @param string lua string
--  @return a string object
function String:string_factory(string)
   local retval =  self:__new()
   retval.val =  string
   return retval
end

--- Factory method factoring an empty string.
--  @return an empty string object
function String:empty_string_factory()
   return self:string_factory("")
end

--- Appending a char at the right-hand side of my string.
--  @param char the char to be appended
function String:append_char(char)
   self.val =  self.val .. char:get_content()
end

--- Appending a string at the right-hand side of my string.
--  @param string to be appended
function String:append_string(string)
   self.val =  self.val .. string:get_content()
end

--- Prepending a char at the right-hand side of my string.
--  @param char the char to be prepended
function String:prepend_char(char)
   self.val =  char:get_content() .. self.val
end

--- Prepending a string at the right-hand side of my string.
--  @param string to be prepended
function String:prepend_string(string)
   self.val =  string:get_content() .. self.val
end

--- Appending several spaces.
--  @param nr number of spaces to be appended
function String:append_spaces(nr)
   self.val =  self.val .. string.rep(" ", nr)
end

--- Appending a newline.
function String:append_newline()
   self.val =  self.val .. "\n"
end

function String:parenthesis_off_depending_factory(is_too_wide)
   local retval
   if is_too_wide
   then
      retval =  self:string_factory(")")
   else
      retval =  self:string_factory(" )")
   end
   return retval
end

--- Iterator iterating all chars.
--  @usage Use it as follows:<blockquote><code>
--  for c in s:chars()<br/>
--  do &laquo; ... do this and that with char c ... &raquo;<br/>
--  end
--  </code></blockquote>
function String:chars()
   function f(s, var)
      if not var
      then
         s.content =  self:__clone()
      end
      if s.content:is_empty()
      then
         return
      end
      local retval =  s.content:get_head()
      s.content:cut_head()
      return retval
   end
   return f, {}
end

--- Iterator iterating over the lines contained in it.
--  @usage Use it as follows: <blockquote><code>
--  for line in s:lines()<br/>
--  do &laquo; ... do this and that with line ... &raquo;<br/>
--  end</code></blockquote>
function String:lines()
   function f(s, var)
      if not var
      then
         s.content =  self:__clone()
      end
      if s.content:is_empty()
      then
         return
      end
      local retval =  self:empty_string_factory()
      repeat
         local recent_char =  s.content:get_head()
         s.content:cut_head()
         if not recent_char:is_newline()
         then
            retval:append_char(recent_char)
         end
      until recent_char:is_newline() or s.content:is_empty()
      return retval
   end
   return f, {}
end

--- Getting the lua string represented by my string.
--  @return lua string
function String:get_content()
   return self.val
end

--- Getting the first char.
--  cp/m styles newline will be exchanged by unix style newlines.
--  string should not be empty.
--  @return char
function String:get_head()
   local char_at_head =  self.val:sub(1, 1)
   if char_at_head == "\r"
   then
      local look_ahead =  self.val:sub(2, 1)
      if look_ahead == "\n"
      then
         char_at_head =  "\n"
      end
   end
   return Char:char_factory(char_at_head)
end

--- Cutting the first char.
--  cp/m style newlines will be exchanged by unix style newlines.
--  string should not be empty.
function String:cut_head()
   local char_at_head =  self.val:sub(1, 1)
   if char_at_head == "\r"
   then
      local look_ahead =  self.val:sub(2, 1)
      if look_ahead == "\n"
      then
         self.val =  self.val:sub(3)
      else
         self.val =  self.val:sub(2)
      end
   else
      self.val =  self.val:sub(2)
   end
end

--- Is my string empty?
--  @return boolean
function String:is_empty()
   return self.val == ""
end

function String:__concat(other)
   local retval =  self:string_factory(self.val)
   retval:append_string(other)
   return retval
end

--- Capitalizing initial letter
function String:capitalize_initial()
   local val =  self.val:sub(1, 1):upper() .. self.val:sub(2)
   self.val =  val
end

function String:__len()
   return #self.val
end

function String:__eq(other)
   return self.val == other:get_content()
end

function String:__lt(other)
   return self.val < other:get_content()
end

function String:__le(other)
   return self.val <= other:get_content()
end

function String:__tostring()
   return self.val
end

function String:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(base::type::String "
      .. self.val
      .. ")" ))
end

function String:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(base::type::String"))
   indentation:insert_newline()
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      deeper_indentation:insert(String:string_factory(self.val))
      deeper_indentation:insert(String:string_factory(" )"))
      deeper_indentation:save()
   end
end
   
return String
