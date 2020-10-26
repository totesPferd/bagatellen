signature TestResult =
   sig

      type state_t

      type testresult_t =  (TextIO.outstream * state_t -> unit) Option.option

      val is_passed: testresult_t -> bool
      val explain: TextIO.outstream * testresult_t -> state_t -> unit

      val name_testresult: string -> testresult_t -> testresult_t

   end;
