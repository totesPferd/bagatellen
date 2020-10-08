signature PPrintConfig =
   sig
      type config =  {
            indent:     int
         ,  page_width: int }
      val config: config
   end;
