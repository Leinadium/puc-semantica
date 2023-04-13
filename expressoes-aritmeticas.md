# Expressões aritméticas

## Sintaxe concreta

```text
E = Number | 
    E BOp E | 
    UOp E |
    '(' E ')'

Bop = '+' | '-' | '*'
UOp = '-'
```

## Sintaxe Abstrata em Haskell

```hs
data E = Econst Number
       | EBin BOp E E
       | EUm E
        deriving show

data BOp = OpAdd | OpSub | OpMul | OpDiv
           deriving show

type Number = Integer 

-- exemplo para (5 + 3) * -8
e1 = Ebin OpMul (EBin Opadd (Econst 5) (Econst 3)) (EUm (EConst 8))
```

## Semantica ?

```hs
-- igual ao Option do Rust
-- note: data Maybe a = Nothing | Just a

evalOp :: BOp -> (Number -> Number -> Maybe Number)
evalOp OpAdd = \xy -> Just(x + y)
evalOp OpSub = \xy -> Just(x - y)
evalOp OpMul = \xy -> Just(x * y)
evalOp OpDiv = div

-- note: fmap
-- propaga os erros
-- fmap :: (a -> b) -> Maybe a -> Maybe b
-- fmap f Nothing = Nothing
-- fmap f (Just x) = Just (f x)

-- note: fmap2, que propaga ou causa erros
fmap2 :: (a -> b -> Maybe c) -> Maybe a -> Maybe b -> Maybe c
fmap2 op Nothing _ = Nothing
fmap2 op _ Nothing = Nothing
fmap2 op Just (x) Just (y) = op x y

eval :: E -> Maybe Integer
eval (EConst n) = Just n
eval (EBin op e1 e2) = fmap2 (evalOp op) (eval e1) (eval e2)
eval (Um e) = fmap negate (eval e)



-- note: bind
-- bind :: (a -> Maybe b) -> Maybe a -> Maybe b
bind2 :: (a -> b -> Maybe c) -> Maybe a -> Maybe b -> Maybe c
bind2 op ma mb = bind (\a -> bind (op) a mb) ma

-- composicao dupla
comp2 :: (c -> d) -> (a -> b -> c) -> a -> b -> d
comp2 f g x y = f (g x y)
-- ou
comp2 = (.) (.) (.)
```
