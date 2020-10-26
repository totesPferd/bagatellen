signature TestCase =
   sig

      type state_t

      type testcase_t = { description: string, perform: TextIO.outstream * state_t -> bool }

   end;
