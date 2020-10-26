signature TestCase =
   sig

      type state_t

      type testcase_t =  {
            description: string
         ,  perform: unit -> (TextIO.outstream * state_t -> unit) Option.option }
      type testsuite_t =  {
            description: string
         ,  perform: TextIO.outstream * state_t -> bool }

      val name_testcase: string * testcase_t -> testcase_t

      val simple_testsuite:  testcase_t -> testsuite_t

   end;
