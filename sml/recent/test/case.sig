signature TestCase =
   sig

      type testcase_t
      type testresult_t

      val get_description: testcase_t -> string
      val perform: testcase_t -> testresult_t

   end;
