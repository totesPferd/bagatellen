use "pkg/set.sml";
use "pkg/string.sml";
use "pprint/base.sig";
use "test/assert.sig";
use "test/case.sig";
use "testsuites/test_assert_eq_for_string_set.fun";

functor SetSuite(X:
   sig
      structure Base: PPrintBase
      structure Case: TestCase
         where type state_t =  Base.state_t
      structure Set: Set
         where type base_t = string
   end ): TestSuite =
   struct
      open X.Case

      type context_t =  context_t
      structure TestAssert =  TestAssert(X)
      structure TestAssertEqForStringSet =  TestAssertEqForStringSet(X)
      structure TestAssertEqForString =  TestAssertEqForString(
         struct
            type context_t =  context_t
            structure Base = X.Base
            structure Case = X.Case
         end )

      val suite =  collect_testcases (
            "set"
         ,  [
                  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "drei"
                     val expected =  in_a
                  in
                     TestAssertEqForStringSet.assert ("adjunct #1", (), expected, X.Set.adjunct (in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "elf"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                  in
                     TestAssertEqForStringSet.assert ("adjunct #2", (), expected, X.Set.adjunct (in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf", "elf" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf" ]
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "elf" ]
                  in
                     TestAssertEqForStringSet.assert ("cut #1", (), expected, X.Set.cut (in_a, in_b))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "drei"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf", "sieben" ]
                  in
                    TestAssertEqForStringSet.assert ("drop #1", (), expected, X.Set.drop(in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "elf"
                     val expected = in_a
                  in
                    TestAssertEqForStringSet.assert ("drop #2", (), expected, X.Set.drop(in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf", "elf" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf" ]
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf" ]
                  in
                     TestAssertEqForStringSet.assert ("intersect #1", (), expected, X.Set.intersect (in_a, in_b))
                  end
               ,  let
                     val in_a =  X.Set.empty
                  in
                    TestAssert.assert ("is_empty #1", X.Set.is_empty(in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                  in
                    TestAssert.assert ("is_empty #2", not (X.Set.is_empty(in_a)))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     fun f s =  s ^ " Eier"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei Eier", "drei Eier", "fuenf Eier", "sieben Eier" ]
                  in
                    TestAssertEqForStringSet.assert ("map #1", (), expected, X.Set.map f in_a)
                  end
               ,  let
                     val in_a =  "zwei"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei" ]
                  in
                    TestAssertEqForStringSet.assert ("singleton #1", (), expected, X.Set.singleton in_a)
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                  in
                     TestAssert.assert ("subseteq #1", X.Set.subseteq(in_a, in_b))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                  in
                     TestAssert.assert ("subseteq #2", not(X.Set.subseteq(in_a, in_b)))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                  in
                     TestAssert.assert ("subseteq #3", X.Set.subseteq(in_a, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben", "elf" ]
                     val expected =  in_b
                  in
                    TestAssertEqForStringSet.assert ("union #1", (), expected, X.Set.union(in_a, in_b))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "fuenf", "elf" ]
                     val in_b =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf" ]
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "elf" ]
                  in
                     TestAssertEqForStringSet.assert ("union #2", (), expected, X.Set.union (in_a, in_b))
                  end
               ,  let
                     val in_a =  "zwei"
                     val expected =  List.foldl X.Set.adjunct X.Set.empty [ "zwei" ]
                  in
                    TestAssertEqForStringSet.assert ("singleton #1", (), expected, X.Set.fe in_a)
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "drei"
                  in
                    TestAssert.assert ("is_in #1", X.Set.is_in(in_b, in_a))
                  end
               ,  let
                     val in_a =  List.foldl X.Set.adjunct X.Set.empty [ "zwei", "drei", "fuenf", "sieben" ]
                     val in_b =  "elf"
                  in
                    TestAssert.assert ("is_in #2", not(X.Set.is_in(in_b, in_a)))
                  end ])
   end;
