# Map - Reduce

```hs
map :: (a -> b) -> [a] -> [b] 
map f [] = []
map f (x:xs) = f x : map f xs
```

No haskell,
reduce === fold === accumulate

```hs
-- fold right
-- op: operacao
-- z : caso base
-- lista: lista de operacoes
-- = x1 op (x2 op (x3 op (...)))
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr op z [] = z
foldr op z (x:xs) = x `op` (foldr op z xs)
```

```hs
-- fold left
-- op: operacao
-- z : caso base
-- lista: lista de operacoes
-- = (((acc op x2) op x3) op x4 ...)
foldr :: (a -> b -> b) -> b -> [a] -> b
foldl op acc [] = acc
foldl op acc [x:xs] = foldl op (acc `op` x) xs
```
