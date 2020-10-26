signature TestCase =
   sig

      type state_t

      type testcase_t = {
            description: string
         ,  perform: unit -> (TextIO.outstream * state_t -> unit) Option.option }

      val name_testcase: string * testcase_t -> testcase_t

   end;
