use "general/dict_set_simple/dict_impl.sig";
use "general/dict_zip.sig";

functor DictSetSimpleDictZip (X:
   sig
      structure DictA: DictSetSimpleDictImpl
      structure DictB: DictSetSimpleDictImpl
         where type key_t =  DictA.key_t
      structure DictResult: DictSetSimpleDictImpl
         where type key_t =  DictA.key_t
         and   type val_t =  DictA.val_t * DictB.val_t
   end ): DictZip =
   struct

      structure DictA =  X.DictA
      structure DictB =  X.DictB
      structure DictResult =  X.DictResult

      exception ZipSrcDoesNotAgree
      local
         fun deref_direct(k, d)
           = case (DictB.deref(k, d)) of
                Option.NONE =>  raise ZipSrcDoesNotAgree
             |  Option.SOME v => v
      in
         fun zip ((a: DictA.T), (b: DictB.T))
           = List.foldl
                (
                   fn ({ key = k, value = v}, d) =>  DictResult.set(k, (v, deref_direct(k, b)), d) )
                (DictResult.empty: DictResult.T)
                a
      end

   end
