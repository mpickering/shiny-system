{-# LANGUAGE TemplateHaskell #-}
module Target where

import Control.Lens

iden = ()

iden2 = $([| () |])
