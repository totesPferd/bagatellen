-- cf. https://tools.ietf.org/html/rfc6570
local is_empty =  require "utils.table.is_empty"
local FSM =  (require "base.oop.obj"):__new()

function FSM:new(str)
   local retval =  self:__new()
   retval.ctxt =  {}
   retval.str =  str
   return retval
end

-- abstract methods
function FSM:eval_regular_char(s)
end
function FSM:eval_next_var()
end
function FSM:eval_tmpl_off()
end
--

function FSM:_err_coll(c)
   error("err_coll")
end

function FSM:_err_expand(c)
   error("err_expand")
end

function FSM:_err_prefix(c)
   error("err_prefix")
end

function FSM:_err_tmpl(c)
   error("err_tmpl")
end

function FSM:_expand_mode()
   self.ctxt.item.cur.expand =  true
end

function FSM:_next_var()
   self:eval_next_var()
end

function FSM:_prefix_num(c)
   local n =  c:byte(1, -1) - 48
   self.ctxt.item.cur.prefix =  (self.ctxt.item.cur.prefix or 0) * 10 + n
end

function FSM:_tmpl_off()
   self:eval_tmpl_off()
end

function FSM:_tmpl_on()
   self:_init_cur()
end

function FSM:_tmpl_op_amp()
   self.ctxt.item.operator =  '&'
   self.ctxt.item.interprete =  "query"
   self.ctxt.item.j =  '&'
   self.ctxt.item.start =  '&'
end

function FSM:_tmpl_op_hash()
   self.ctxt.item.operator =  '#'
   self.ctxt.item.safe =  true
   self.ctxt.item.start =  '#'
end

function FSM:_tmpl_op_label(c)
   self.ctxt.item.operator =  c
   self.ctxt.item.interprete =  "label"
   self.ctxt.item.j =  c
   self.ctxt.item.start =  c
end

function FSM:_tmpl_op_plus()
   self.ctxt.item.operator =  '+'
   self.ctxt.item.safe =  true
end

function FSM:_tmpl_op_qm()
   self.ctxt.item.operator =  '?'
   self.ctxt.item.interprete =  "query"
   self.ctxt.item.j =  '&'
   self.ctxt.item.start =  '?'
end

function FSM:_tmpl_op_reg(c)
   self.ctxt.item.operator =  c
   self.ctxt.item.j =  c
   self.ctxt.item.start =  c
end

function FSM:_tmpl_op_sc()
   self.ctxt.item.operator =  ';'
   self.ctxt.item.interprete =  "semi_path"
   self.ctxt.item.j =  ';'
   self.ctxt.item.start =  ';'
end

function FSM:_tmpl_reg(c)
   self.ctxt.item.cur.name =  self.ctxt.item.cur.name .. c
end

function FSM:_init_cur()
   self.ctxt.item =  {}
   self.ctxt.item.first =  true
   self.ctxt.item.interprete =  "string"
   self.ctxt.item.j =  ','
   self.ctxt.item.safe =  false
   self.ctxt.item.start =  ''
   self:_reset_cur()
end

function FSM:_reset_cur()
   self.ctxt.item.cur =  {
         ['expand'] = false
      ,  ['name'] = '' }
end

function FSM:open()
   local mode =  "collecting"
   for _, v in pairs { self.str:byte(1,-1) }
   do c =  string.char(v)
      if mode == "collecting"
      then
         if
               (v >= 0x30 and v <= 0x39)
            or (v >= 0x41 and v <= 0x5A)
            or (v >= 0x61 and v <= 0x7A)
            or c == "-"
            or c == "."
            or c == "_"
            or c == "~"
            or c == "%"
            or c == ":"
            or c =="/"
            or c == "?"
            or c == "#"
            or c == "[" or c == "]"
            or c == "@"
            or c == "!"
            or c == "$"
            or c == "&"
            or c == "'"
            or c == "(" or c == ")"
            or c == "*"
            or c == "+"
            or c == ","
            or c == ";"
            or c == "="
         then
            self:eval_regular_char(c)
         elseif c == "{"
         then
            self:_tmpl_on()
            mode =  "template_op"
         else
            self:_err_coll(c)
         end
      elseif mode == "template_op" or mode == "template"
      then
         if mode == "template_op" and (c == "." or c == "/")
         then
            self:_tmpl_op_label(c)
            mode =  "template"
         elseif
               mode == "template_op"
          and (
                    c == "="
                 or c == ","
                 or c == "!"
                 or c == "@"
                 or c == "|" )
         then
            self:_tmpl_op_reg(c)
            mode =  "template"
         elseif mode == "template_op" and c == "&"
         then
            self:_tmpl_op_amp()
            mode =  "template"
         elseif mode == "template_op" and c == "#"
         then
            self:_tmpl_op_hash()
            mode =  "template"
         elseif mode == "template_op" and c == "+"
         then
            self:_tmpl_op_plus()
            mode =  "template"
         elseif mode == "template_op" and c == "?"
         then
            self:_tmpl_op_qm()
            mode =  "template"
         elseif mode == "template_op" and c == ";"
         then
            self:_tmpl_op_sc()
            mode =  "template"
         elseif c == "}"
         then
            self:_tmpl_off()
            mode =  "collecting"
         elseif
              (v >= 0x30 and v <= 0x39)
           or (v >= 0x41 and v <= 0x5A)
           or (v >= 0x61 and v <= 0x7A)
           or c == "_"
           or c == "%"
           or c == "."
         then
            self:_tmpl_reg(c)
            mode =  "template"
         elseif c == "*"
         then
            self:_expand_mode()
            mode =  "expand"
         elseif c == ":"
         then
            mode =  "prefix"
         elseif c == ","
         then
            self:_next_var()
         else
            self:_err_tmpl(c)
            mode =  "template"
         end
      elseif mode == "expand"
      then
         if c == ","
         then
            self:_next_var()
            mode =  "template"
         elseif c == "}"
         then
            self:_tmpl_off()
            mode =  "collecting"
         else
            self:_err_expand(c)
            mode =  "template"
         end
      elseif mode == "prefix"
      then
         if c == ","
         then
            self:_next_var()
            mode =  "template"
         elseif c == "}"
         then
            self:_tmpl_off()
            mode =  "collecting"
         elseif v >= 0x30 and v <= 0x39
         then
            self:_prefix_num(c)
         else
            self:_err_prefix(c)
            mode =  "template"
         end
      end
   end
end

function FSM:is_none_quote_necessary(c)
   local retval =  false
   local v =  string.byte(c, 1, -1)
   if 
         (v >= 0x30 and v <= 0x39)
      or (v >= 0x41 and v <= 0x5A)
      or (v >= 0x61 and v <= 0x7A)
      or c == '_'
      or c == '.'
      or c == '-'
      then
         retval =  true
      elseif
            self.ctxt.item.safe
        and (
                  c == ':'
               or c == '/'
               or c == '?'
               or c == '#'
               or c == '[' or c == ']'
               or c == '@'
               or c == '!'
               or c == '$'
               or c == '&'
               or c == "'"
               or c == '(' or c == ')'
               or c == '*'
               or c == '+'
               or c == ','
               or c == ';'
               or c == '=' )
      then
         retval =  true
      end
   return retval
end

local OutputFSM =  FSM:__new()

function OutputFSM:new(arg, str)
   local retval =  FSM.new(self, str)
   retval.arg =  arg
   retval.result =  ""
   return retval
end

function OutputFSM:_direct_output(s)
   self.result =  self.result .. s
end

function OutputFSM:_quoted_output(s)
   for _, v in pairs { tostring(s):byte(1, -1) }
   do local c =  string.char(v)
      if self:is_none_quote_necessary(c)
      then
         self:_direct_output(c)
      else
         self:_direct_output(string.format("%%%02X", v))
      end
   end
end

function OutputFSM:eval_label()
   if type(self.ctxt.item.cur.substitute) == "table"
   then
      local first =  true
      local join_str =  self.ctxt.item.j
      if not(self.ctxt.item.cur.expand)
      then
         join_str =  ","
      end
      for k, v in pairs(self.ctxt.item.cur.substitute)
      do if not(first)
         then
            self:_direct_output(join_str)
         else
            first =  false
         end
         if type(k) == "string"
         then
            self:_quoted_output(k)
            if self.ctxt.item.cur.expand
            then
               self:_direct_output("=")
            else
               self:_direct_output(",")
            end
         end
         self:_quoted_output(v)
      end
   else
      local value
      if self.ctxt.item.cur.prefix
      then
         value =  string.sub(
               self.ctxt.item.cur.substitute
            ,  1
            ,  self.ctxt.item.cur.prefix )
      else
         value = self.ctxt.item.cur.substitute 
      end
      self:_quoted_output(value)
   end
   return true
end

function OutputFSM:eval_query()
   if type(self.ctxt.item.cur.substitute) == "table"
   then
      local join_str =  self.ctxt.item.j
      if not(self.ctxt.item.cur.expand)
      then
         join_str =  ","
         self:_direct_output(self.ctxt.item.cur.name)
         self:_direct_output("=")
      end
      local first =  true
      for k, v in pairs(self.ctxt.item.cur.substitute)
      do if not(first)
         then
            self:_direct_output(join_str)
         else
            first =  false
         end
         if self.ctxt.item.cur.expand
         then
            if type(k) == "string"
            then
               self:_quoted_output(k)
            else
               self:_direct_output(self.ctxt.item.cur.name)
            end
            self:_direct_output("=")
         else
            if type(k) == "string"
            then
               self:_quoted_output(k)
               self:_direct_output(",")
            end
         end
         self:_quoted_output(v)
      end
   else
      local value
      if self.ctxt.item.cur.prefix
      then
         value =  string.sub(
               self.ctxt.item.cur.substitute
            ,  1
            ,  self.ctxt.item.cur.prefix )
      else
         value =  self.ctxt.item.cur.substitute
      end
      self:_direct_output(self.ctxt.item.cur.name)
      self:_direct_output("=")
      self:_quoted_output(value)
   end
   return true
end

function OutputFSM:eval_semi_path()
   if type(self.ctxt.item.cur.substitute) == "table"
   then
      local join_str =  self.ctxt.item.j
      if not(self.ctxt.item.cur.expand)
      then
         join_str =  ","
         self:_direct_output(self.ctxt.item.cur.name)
         self:_direct_output("=")
      end
      local first =  true
      for k, v in pairs(self.ctxt.item.cur.substitute)
      do if not(first)
         then
            self:_direct_output(join_str)
         else
            first =  false
         end
         if self.ctxt.item.cur.expand
         then
            if type(k) == "string"
            then
               self:_quoted_output(k)
            else
               self:_direct_output(self.ctxt.item.cur.name)
            end
            self:_direct_output("=")
         else
            if type(k) == "string"
            then
               self:_quoted_output(k)
               self:_direct_output(",")
            end
         end
         self:_quoted_output(v)
      end
   else
      local value
      if self.ctxt.item.cur.prefix
      then
         value =  string.sub(
               self.ctxt.item.cur.substitute
            ,  1
            ,  self.ctxt.item.cur.prefix )
      else
         value =  self.ctxt.item.cur.substitute
      end
      self:_direct_output(self.ctxt.item.cur.name)
      if value ~= ""
      then
         self:_direct_output("=")
         self:_quoted_output(value)
      end
   end
   return true
end

function OutputFSM:eval_string()
   if type(self.ctxt.item.cur.substitute) == "table"
   then
      local first =  true
      for k, v in pairs(self.ctxt.item.cur.substitute)
      do if not(first)
         then
            self:_direct_output(",")
         else
            first =  false
         end
         if type(k) == "string"
         then
            self:_quoted_output(k)
            if self.ctxt.item.cur.expand
            then
               self:_direct_output("=")
            else
               self:_direct_output(",")
            end
         end
         self:_quoted_output(v)
      end
   else
      local value
      if self.ctxt.item.cur.prefix
      then
         value =  string.sub(
               self.ctxt.item.cur.substitute
            ,  1
            ,  self.ctxt.item.cur.prefix )
      else
         value =  self.ctxt.item.cur.substitute
      end
      self:_quoted_output(value)
   end
   return true
end

function OutputFSM:is_label_empty()
   return is_empty(self.ctxt.item.cur.substitute)
end

function OutputFSM:is_string_empty()
   return self.ctxt.item.cur.substitute == ""
end

function OutputFSM:eval_regular_char(s)
   self:_direct_output(s)
end

function OutputFSM:pre_eval_next_var()
   self.ctxt.item.cur.substitute =  self.arg[self.ctxt.item.cur.name]
   return type(self.ctxt.item.cur.substitute) ~= "nil"
end

function OutputFSM:eval_next_var()
   if self:pre_eval_next_var()
   then
      if
            (
                  not(self.ctxt.item.operator)
               or self.ctxt.item.operator == "#"
               or self.ctxt.item.interprete ~= "string"
               or not(self:is_string_empty()) )
        and (
              self.ctxt.item.interprete ~= "label"
           or not(self:is_label_empty()) )
      then
         if self.ctxt.item.first
         then
            self:eval_regular_char(self.ctxt.item.start)
         else
            self:eval_regular_char(self.ctxt.item.j)
         end
         local value
         if self.ctxt.item.interprete == "label"
         then
            value =  self:eval_label()
         elseif self.ctxt.item.interprete == "query"
         then
            value =  self:eval_query()
         elseif self.ctxt.item.interprete == "semi_path"
         then
            value =  self:eval_semi_path()
         elseif self.ctxt.item.interprete == "string"
         then
            value =  self:eval_string()
         end
         if value
         then
            self.ctxt.item.first =  false
         end
      end
   end
   self:_reset_cur()
end

function OutputFSM:eval_tmpl_off()
   return self:eval_next_var()
end


local URITemplate =  (require "base.oop.obj"):__new()

function URITemplate:new(str)
   local retval =  self:__new()
   retval.str =  str
   return retval
end

function URITemplate:instantiate(arg)
   local outputFSM =  OutputFSM:new(arg, self.str)
   outputFSM:open()
   return outputFSM.result
end

return URITemplate
