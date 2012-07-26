module Deptup where

import Language.Haskell.Liquid.Prelude

{-@ data Pair a b <p :: a -> b -> Bool> = P (x :: a) (y :: b<p x>) @-} 
data Pair a b = P a b

incr x      = x + 1

baz x       = P x (incr x)

bazList xs  = map baz xs 

n           = choose 0
xs          = [0..n]

chk (P x y) = liquidAssert (x < y)
prop_baz    = map chk $ bazList xs 
