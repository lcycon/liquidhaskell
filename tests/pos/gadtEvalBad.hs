
module Eval where


import Language.Haskell.Liquid.Prelude (liquidError)

data Expr = I     Int
          | B     Bool
          | Equal Expr Expr
          | Plus  Expr Expr
          deriving (Eq, Show)


{-@ evalOK :: e:ValidExpr  -> {v:ValidExpr | ((isValue v) && (((eType e) = (eType v))))} @-}
evalOK     :: Expr -> Expr
evalOK     = undefined

{-@ eval           :: e:ValidExpr  -> {v:ValidExpr | ((isValue v) && (((eType e) = (eType v))))} @-}
eval e@(I _)       = e
eval e@(B _)       = e
eval (Plus e1 e2)  = (evalOK e1) -- `plus` (eval e2)
eval (Equal e1 e2) = (eval e1) `equal` (eval e2)

{-@ plus :: e1:IntExpr -> e2:IntExpr -> IntExpr @-}
plus (I i) (I j)   = I (i + j)
plus _       _     = liquidError "don't worry, its impossible" 

{-@ toInt :: IntExpr -> Int @-}
toInt (I i) = i
toInt _     = liquidError "impossible"

{-@ equal          :: e1:BoolExpr -> e2:BoolExpr -> BoolExpr @-}
equal (I i) (I j)  = B (i == j)
equal (B x) (B y)  = B (x == y)
equal _       _    = liquidError "don't worry, its impossible" 

-- | Why the hell is expandAlias not inlining the defs of TInt and TBool?!
-- Ah, I get it: it isn't expanding them in the MEASURE definitions...OHO.

{-@ predicate TInt X   = ((eType X) = 0) @-}
{-@ predicate TBool X  = ((eType X) = 1) @-}

{-@ type ValidExpr     = {v: Expr | (isValid v)               } @-}
{-@ type IntExpr       = {v: Expr | ((isValue v) && (TInt  v))} @-}
{-@ type BoolExpr      = {v: Expr | ((isValue v) && (TBool v))} @-}

{-@ measure isValue       :: Expr -> Prop
    isValue (I i)         = true
    isValue (B b)         = true
    isValue (Equal e1 e2) = false 
    isValue (Plus e1 e2)  = false
  @-}  

{-@ measure eType       :: Expr -> Int 
    eType (I i)         = 0
    eType (Plus  e1 e2) = 0
    eType (B b)         = 1
    eType (Equal e1 e2) = 1
  @-}

{-@ measure isValid       :: Expr -> Prop
    isValid (I i)         = true
    isValid (B b)         = true
    isValid (Equal e1 e2) = (((eType e1) = (eType e2)) && (isValid e1) && (isValid e2))
    isValid (Plus e1 e2)  = ((TInt e1) && (TInt e2) && (isValid e1) && (isValid e2))
  @-}


