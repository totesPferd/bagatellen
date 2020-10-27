signature TestAssertEq =
   sig

      type context_t
      type testcase_t
   
      type T
   
      val assert: string * context_t * T * T -> testcase_t

   end;
