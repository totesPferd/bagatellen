use "collections/combi_type.sig";

structure CombiType: CombiType =
   struct
      datatype T =  NPT of string | UPT
      fun eq (x, y) =  (x = y)
      val point_npt =  NPT
      val point_upt =  UPT
      fun traverse (n_phi, u_phi) (NPT s) =  n_phi(s)
      |   traverse (n_phi, u_phi) UPT =  u_phi()
   end;
