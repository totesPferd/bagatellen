signature TestAssert =
   sig

      type testcase_t

      val assert: string * bool -> testcase_t

   end;
