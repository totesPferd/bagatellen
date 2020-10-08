{-# LANGUAGE MultiParamTypeClasses #-}

module Dict where

class Dict d k v where

   get :: (d, k)    -> v
   set :: (d, k, v) -> d
