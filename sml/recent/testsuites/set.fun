use "pprint/base.sig";
use "test/assert.sig";
use "test/assert_eq.sig";
use "test/case.sig";
use "test/suite.sig";

functor SetSuite(X:
   sig
      structure Base: PPrintBase
      structure Set: Set
         where type base_t = string
      structure Case: TestCase
         where type state_t =  Base.state_t
      structure Assert: TestAssert
         where type testcase_t =  Case.testcase_t
      structure AssertEqForString: TestAssertEq
         where type context_t =  unit
           and type testcase_t =  Case.testcase_t
           and type T =  string
      structure AssertEqForStringSet: TestAssertEq
         where type context_t =  unit
           and type testcase_t =  Case.testcase_t
           and type T =  Set.T
   end ): TestSuite =
   struct
      open X.Case

      type context_t =  unit

      val suite =  collect_testcases (
            "set"
         ,  [
                  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "drei"
                     val expected =  in_a
                  in
                     X.AssertEqForStringSet.assert ("adjunct #1", (), expected, X.Set.adjunct (in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "elf"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                  in
                     X.AssertEqForStringSet.assert ("adjunct #2", (), expected, X.Set.adjunct (in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf", "elf" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf" ]
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "elf" ]
                  in
                     X.AssertEqForStringSet.assert ("cut #1", (), expected, X.Set.cut (in_a, in_b))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "drei"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf", "sieben" ]
                  in
                    X.AssertEqForStringSet.assert ("drop #1", (), expected, X.Set.drop(in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "elf"
                     val expected = in_a
                  in
                    X.AssertEqForStringSet.assert ("drop #2", (), expected, X.Set.drop(in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf", "elf" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf" ]
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf" ]
                  in
                     X.AssertEqForStringSet.assert ("intersect #1", (), expected, X.Set.intersect (in_a, in_b))
                  end
               ,  let
                     val in_a =  X.Set.empty
                  in
                    X.Assert.assert ("is_empty #1", X.Set.is_empty(in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                  in
                    X.Assert.assert ("is_empty #2", not (X.Set.is_empty(in_a)))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     fun f s =  s ^ " Eier"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei Eier", "drei Eier", "fuenf Eier", "sieben Eier" ]
                  in
                    X.AssertEqForStringSet.assert ("map #1", (), expected, X.Set.map f in_a)
                  end
               ,  let
                     val in_a =  "zwei"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei" ]
                  in
                    X.AssertEqForStringSet.assert ("singleton #1", (), expected, X.Set.singleton in_a)
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                  in
                     X.Assert.assert ("subeq #1", X.Set.subeq(in_a, in_b))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                  in
                     X.Assert.assert ("subeq #2", not(X.Set.subeq(in_a, in_b)))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                  in
                     X.Assert.assert ("subeq #3", X.Set.subeq(in_a, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                     val expected =  in_b
                  in
                    X.AssertEqForStringSet.assert ("union #1", (), expected, X.Set.union(in_a, in_b))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf", "elf" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf" ]
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "elf" ]
                  in
                     X.AssertEqForStringSet.assert ("union #2", (), expected, X.Set.union (in_a, in_b))
                  end
               ,  let
                     val in_a =  "zwei"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei" ]
                  in
                    X.AssertEqForStringSet.assert ("singleton #1", (), expected, X.Set.fe in_a)
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "drei"
                  in
                    X.Assert.assert ("is_in #1", X.Set.is_in(in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "elf"
                  in
                    X.Assert.assert ("is_in #2", not(X.Set.is_in(in_b, in_a)))
                  end ])
   end;
