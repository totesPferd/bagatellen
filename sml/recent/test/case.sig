signature TestCase =
   sig

      type state_t

      type testcase_t
      type testresult_t

      val get_description: testcase_t -> string
      val perform: testcase_t -> testresult_t
      val is_passed: testresult_t -> bool
      val explain: TextIO.outstream * testresult_t -> state_t -> unit

   end;
