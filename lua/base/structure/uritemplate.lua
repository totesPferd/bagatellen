-- cf. https://tools.ietf.org/html/rfc6570
URITemplate =  (require "base.oop.obj"):__new()

local function is_empty(s)
   local retval =  false
   if type(s) == "table"
   then
      retval =  true
      for k, v in pairs(s)
      do retval =  false
      end
   end
   return retval
end

function URITemplate:_direct_output(ctxt, s)
   ctxt.result =  ctxt.result .. s
end

function URITemplate:_quoted_output(ctxt, s)
   for _, v in pairs { tostring(s):byte(1, -1) }
   do local c =  string.char(v)
      if (v >= 0x30 and v <= 0x39) or (v >= 0x41 and v <= 0x5A) or (v >= 0x61 and v<= 0x7A) or c == '_' or c == '.' or c == '-'
      then
         self:_direct_output(ctxt, c)
      elseif
           ctxt.item.safe
       and (     c == ':'
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
         self:_direct_output(ctxt, c)
      else
         self:_direct_output(ctxt, string.format("%%%02X", v))
      end
   end
end

function URITemplate:_label_output(ctxt, s)
   if type(s) == "table"
   then
      local first =  true
      local join_str =  ctxt.item.j
      if not(ctxt.item.cur.expand)
      then
         join_str =  ","
      end
      for k, v in pairs(s)
      do if not(first)
         then
            self:_direct_output(ctxt, join_str)
         else
            first =  false
         end
         if type(k) == "string"
         then
            self:_quoted_output(ctxt, k)
            if ctxt.item.cur.expand
            then
               self:_direct_output(ctxt, "=")
            else
               self:_direct_output(ctxt, ",")
            end
         end
         self:_quoted_output(ctxt, v)
      end
   else
      local value
      if ctxt.item.cur.prefix
      then
         value =  s:sub(1, ctxt.item.cur.prefix)
      else
         value =  s
      end
      self:_quoted_output(ctxt, value)
   end
   return true
end

function URITemplate:_query_output(ctxt, s)
   if type(s) == "table"
   then
      local join_str =  ctxt.item.j
      if not(ctxt.item.cur.expand)
      then
         join_str =  ","
         self:_direct_output(ctxt, ctxt.item.cur.name)
         self:_direct_output(ctxt, "=")
      end
      local first =  true
      for k, v in pairs(s)
      do if not(first)
         then
            self:_direct_output(ctxt, join_str)
         else
            first =  false
         end
         if ctxt.item.cur.expand
         then
            if type(k) == "string"
            then
               self:_quoted_output(ctxt, k)
            else
               self:_direct_output(ctxt, ctxt.item.cur.name)
            end
            self:_direct_output(ctxt, "=")
         else
            if type(k) == "string"
            then
               self:_quoted_output(ctxt, k)
               self:_direct_output(ctxt, ",")
            end
         end
         self:_quoted_output(ctxt, v)
      end
   else
      local value
      if ctxt.item.cur.prefix
      then
         value =  s:sub(1, ctxt.item.cur.prefix)
      else
         value =  s
      end
      self:_direct_output(ctxt, ctxt.item.cur.name)
      self:_direct_output(ctxt, "=")
      self:_quoted_output(ctxt, value)
   end
   return true
end

function URITemplate:_semi_path_output(ctxt, s)
   if type(s) == "table"
   then
      local join_str =  ctxt.item.j
      if not(ctxt.item.cur.expand)
      then
         join_str =  ","
         self:_direct_output(ctxt, ctxt.item.cur.name)
         self:_direct_output(ctxt, "=")
      end
      local first =  true
      for k, v in pairs(s)
      do if not(first)
         then
            self:_direct_output(ctxt, join_str)
         else
            first =  false
         end
         if ctxt.item.cur.expand
         then
            if type(k) == "string"
            then
               self:_quoted_output(ctxt, k)
            else
               self:_direct_output(ctxt, ctxt.item.cur.name)
            end
            self:_direct_output(ctxt, "=")
         else
            if type(k) == "string"
            then
               self:_quoted_output(ctxt, k)
               self:_direct_output(ctxt, ",")
            end
         end
         self:_quoted_output(ctxt, v)
      end
   else
      local value
      if ctxt.item.cur.prefix
      then
         value =  s:sub(1, ctxt.item.cur.prefix)
      else
         value =  s
      end
      self:_direct_output(ctxt, ctxt.item.cur.name)
      if value ~= ""
      then
         self:_direct_output(ctxt, "=")
         self:_quoted_output(ctxt, value)
      end
   end
   return true
end

function URITemplate:_string_output(ctxt, s)
   if type(s) == "table"
   then
      local first =  true
      for k, v in pairs(s)
      do if not(first)
         then
            self:_direct_output(ctxt, ",")
         else
            first =  false
         end
         if type(k) == "string"
         then
            self:_quoted_output(ctxt, k)
            if ctxt.item.cur.expand
            then
               self:_direct_output(ctxt, "=")
            else
               self:_direct_output(ctxt, ",")
            end
         end
         self:_quoted_output(ctxt, v)
      end
   else
      local value
      if ctxt.item.cur.prefix
      then
         value =  s:sub(1, ctxt.item.cur.prefix)
      else
         value =  s
      end
      self:_quoted_output(ctxt, value)
   end
   return true
end

function URITemplate:_collecting(ctxt, c)
   self:_direct_output(ctxt, c)
end

function URITemplate:_err_coll(ctxt, c)
   error("err_coll")
end

function URITemplate:_err_expand(ctxt, c)
   error("err_expand")
end

function URITemplate:_err_prefix(ctxt, c)
   error("err_prefix")
end

function URITemplate:_err_tmpl(ctxt, c)
   error("err_tmpl")
end

function URITemplate:_expand_mode(ctxt)
   ctxt.item.cur.expand =  true
end

function URITemplate:_next_var(ctxt)
   self:_next_cur(ctxt)
end

function URITemplate:_prefix_num(ctxt, c)
   local n =  c:byte(1, -1) - 48
   ctxt.item.cur.prefix =  (ctxt.item.cur.prefix or 0) * 10 + n
end

function URITemplate:_tmpl_off(ctxt)
   self:_next_cur(ctxt)
end

function URITemplate:_tmpl_on(ctxt)
   self:_init_cur(ctxt)
end

function URITemplate:_tmpl_op_amp(ctxt)
   ctxt.item.operator =  '&'
   ctxt.item.interprete =  "query"
   ctxt.item.j =  '&'
   ctxt.item.start =  '&'
end

function URITemplate:_tmpl_op_hash(ctxt)
   ctxt.item.operator =  '#'
   ctxt.item.safe =  true
   ctxt.item.start =  '#'
end

function URITemplate:_tmpl_op_label(ctxt, c)
   ctxt.item.operator =  c
   ctxt.item.interprete =  "label"
   ctxt.item.j =  c
   ctxt.item.start =  c
end

function URITemplate:_tmpl_op_plus(ctxt)
   ctxt.item.operator =  '+'
   ctxt.item.safe =  true
end

function URITemplate:_tmpl_op_qm(ctxt)
   ctxt.item.operator =  '?'
   ctxt.item.interprete =  "query"
   ctxt.item.j =  '&'
   ctxt.item.start =  '?'
end

function URITemplate:_tmpl_op_reg(ctxt, c)
   ctxt.item.operator =  c
   ctxt.item.j =  c
   ctxt.item.start =  c
end

function URITemplate:_tmpl_op_sc(ctxt)
   ctxt.item.operator =  ';'
   ctxt.item.interprete =  "semi_path"
   ctxt.item.j =  ';'
   ctxt.item.start =  ';'
end

function URITemplate:_tmpl_reg(ctxt, c)
   ctxt.item.cur.name =  ctxt.item.cur.name .. c
end

function URITemplate:_init_cur(ctxt)
   ctxt.item =  {}
   ctxt.item.first =  true
   ctxt.item.interprete =  "string"
   ctxt.item.j =  ','
   ctxt.item.safe =  false
   ctxt.item.start =  ''
   self:_reset_cur(ctxt)
end

function URITemplate:_reset_cur(ctxt)
   ctxt.item.cur =  {
         ['expand'] = false
      ,  ['name'] = '' }
end

function URITemplate:_next_cur(ctxt)
   local substitute =  ctxt.arg[ctxt.item.cur.name]
   if substitute
   then
      if
            (not(ctxt.item.operator) or ctxt.item.operator == "#" or ctxt.item.interprete ~= "string" or substitute ~= "")
        and (ctxt.item.interprete ~= "label" or not(is_empty(substitute)))
      then
         if ctxt.item.first
         then
            self:_direct_output(ctxt, ctxt.item.start)
         else
            self:_direct_output(ctxt, ctxt.item.j)
         end
         local value
         if ctxt.item.interprete == "label"
         then
            value =  self:_label_output(ctxt, substitute)
         elseif ctxt.item.interprete == "query"
         then
            value =  self:_query_output(ctxt, substitute)
         elseif ctxt.item.interprete == "semi_path"
         then
            value =  self:_semi_path_output(ctxt, substitute)
         elseif ctxt.item.interprete == "string"
         then
            value =  self:_string_output(ctxt, substitute)
         end
         if value
         then
            ctxt.item.first =  false
         end
      end
   end
   self:_reset_cur(ctxt)
end

function URITemplate:new(str)
   local retval =  self:__new()
   retval.str =  str
   return retval
end

function URITemplate:instantiate(arg)
   local ctxt =  { ['arg'] = arg, ['result'] = "" }

   local mode =  "collecting"
   for _, v in pairs { self.str:byte(1,-1) }
   do c =  string.char(v)
      if mode == "collecting"
      then
         if (v >= 0x30 and v <= 0x39) or (v >= 0x41 and v <= 0x5A) or (v >= 0x61 and v <= 0x7A) or c == "-" or c == "." or c == "_" or c == "~" or c == "%"
          or c == ":" or c =="/" or c == "?" or c == "#" or c == "[" or c == "]" or c == "@"
          or c == "!" or c == "$" or c == "&" or c == "'" or c == "(" or c == ")" or c == "*" or c == "+" or c == "," or c == ";" or c == "="
         then
            self:_collecting(ctxt, c)
         elseif c == "{"
         then
            self:_tmpl_on(ctxt)
            mode =  "template_op"
         else
            self:_err_coll(ctxt, c)
         end
      elseif mode == "template_op" or mode == "template"
      then
         if mode == "template_op" and (c == "." or c == "/")
         then
            self:_tmpl_op_label(ctxt, c)
            mode =  "template"
         elseif mode == "template_op" and (c == "=" or c == "," or c == "!" or c == "@" or c == "|")
         then
            self:_tmpl_op_reg(ctxt, c)
            mode =  "template"
         elseif mode == "template_op" and c == "&"
         then
            self:_tmpl_op_amp(ctxt)
            mode =  "template"
         elseif mode == "template_op" and c == "#"
         then
            self:_tmpl_op_hash(ctxt)
            mode =  "template"
         elseif mode == "template_op" and c == "+"
         then
            self:_tmpl_op_plus(ctxt)
            mode =  "template"
         elseif mode == "template_op" and c == "?"
         then
            self:_tmpl_op_qm(ctxt)
            mode =  "template"
         elseif mode == "template_op" and c == ";"
         then
            self:_tmpl_op_sc(ctxt)
            mode =  "template"
         elseif c == "}"
         then
            self:_tmpl_off(ctxt)
            mode =  "collecting"
         elseif (v >= 0x30 and v <= 0x39) or (v >= 0x41 and v <= 0x5A) or (v >= 0x61 and v <= 0x7A) or c == "_" or c == "%" or c == "."
         then
            self:_tmpl_reg(ctxt, c)
            mode =  "template"
         elseif c == "*"
         then
            self:_expand_mode(ctxt)
            mode =  "expand"
         elseif c == ":"
         then
            mode =  "prefix"
         elseif c == ","
         then
            self:_next_var(ctxt)
         else
            self:_err_tmpl(ctxt, c)
            mode =  "template"
         end
      elseif mode == "expand"
      then
         if c == ","
         then
            self:_next_var(ctxt)
            mode =  "template"
         elseif c == "}"
         then
            self:_tmpl_off(ctxt)
            mode =  "collecting"
         else
            self:_err_expand(ctxt, c)
            mode =  "template"
         end
      elseif mode == "prefix"
      then
         if c == ","
         then
            self:_next_var(ctxt)
            mode =  "template"
         elseif c == "}"
         then
            self:_tmpl_off(ctxt)
            mode =  "collecting"
         elseif v >= 0x30 and v <= 0x39
         then
            self:_prefix_num(ctxt, c)
         else
            self:_err_prefix(ctxt, c)
            mode =  "template"
         end
      end
   end

   return ctxt.result
end

return URITemplate
