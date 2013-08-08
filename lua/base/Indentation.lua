local obj =  require "base.oop.obj"

local Indentation =  obj:__new()

package.loaded["base.Indentation"] =  Indentation
local String =  require "base.type.String"
local config =  require "base.config"

function Indentation:new_factory(params)
   local retval =  self:__new()
   retval.content =  String:empty_string_factory()
   retval.indent =  params.indent or 0
   retval.width =  0
   retval.is_first_line =  true
   retval.is_reset_line =  true
   retval.first_line_symbol =  params.first_line_symbol
   retval.recent_line =
         params.recent_line
      or String:empty_string_factory()
   retval.recommended_width =
         params.recommended_width
      or config.std_page_width
   return retval
end

function Indentation:get_content()
   return self.content
end

function Indentation:get_indent()
   return self.indent
end

function Indentation:get_width()
   return self.width
end

function Indentation:get_deeper_indentation_factory(params)
   local retval =  self:new_factory {
         first_line_symbol =  params.first_line_symbol
      ,  indent =  (params.indent or config.std_indent) + self.indent
      ,  is_reset_line =  self.is_reset_line
      ,  recent_line = self.recent_line:__clone()
      ,  recommended_width =  self.recommended_width }
   retval.upper_indentation = self
   return retval
end

function Indentation:__reset_recent_line()
   self.content:append_string(self.recent_line)
   self.content:append_newline()
   self.recent_line =  String:empty_string_factory()
   self.is_reset_line =  true
end

function Indentation:__append_string(text)
   if self.is_reset_line and not text:is_empty()
   then
      self.recent_line:append_spaces(self.indent)
      self.is_reset_line =  false
   end
   self.recent_line:append_string(text)
end
      

function Indentation:insert(text)
   local is_first_line = true
   for line in text:lines()
   do
      if
            is_first_line
        and (not self.first_line_symbol)
      then
         is_first_line =  false
      else
         self:__reset_recent_line()
         if self.first_line_symbol and self.is_first_line
         then
            self.recent_line:append_spaces(
                  self.indent
               -  self.first_line_symbol:__len() )
            self.recent_line:append(first_line_symbol)
            self.is_first_line =  false
            self.is_reset_line =  false
         end
      end
      self:__append_string(line)
      self.width =  math.max(self.width, self.recent_line:__len())
   end
end


function Indentation:insert_newline()
   self:insert(String:string_factory("\n\n"))
end

function Indentation:save()
   if self.upper_indentation
   then
      self.upper_indentation.content:append_string(self:get_content())
      self.upper_indentation.recent_line =  self.recent_line
      self.upper_indentation.width =  math.max(
            self.upper_indentation.width
         ,  self.width )
   else
      self.content:append_string(self.recent_line)
   end
end

function Indentation:is_too_wide()
   return self.width > self.recommended_width
end


return Indentation
