{-# FlexibleInstances #-}

module FirstDictUse where
import FirstDictImpl
import Dict

instance Dict.Dict [(k, v)] k v where
   get = FirstDictImpl.get
   set = FirstDictImpl.set
