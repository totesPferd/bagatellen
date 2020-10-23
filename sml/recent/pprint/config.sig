signature PPrintConfig =
   sig
      type config_t =  {
            indent:     int
         ,  page_width: int }
      val config: config_t
   end;
