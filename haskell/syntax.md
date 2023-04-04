# Syntax

```haskell
x op y === (op) x y
foo x y === x `foo` y
```

## operador ternario

```hs
(?) :: Bool -> Integer -> (Integer -> Integer)
(?) True x y = x
(?) False x y = y

(#) :: (Integer -> Integer) -> Integer -> Integer
(#) f x = f x
```

## tipos algebricos

```hs
-- booleanos
data Bool = False | True
case b of
    True -> ...
    False -> ...

-- um ponto x, y
data Point = P Double Double
-- exemplo: norma de um ponto
norm :: Point -> Double
norm (P x y) = sqrt (x**2 + y**2)

-- definicao de varias figuras
data Figure = Rect Point Point
            | Circle Point Double
-- exemplo: area
area :: Figure -> Double
area (Rect (P x1 y1) (P x2 y2)) = ...
area (Circle _ r) = pi * r ** 2

-- tipos recursivos
data Nat = Z | S Nat
-- exemplo, funcao recursiva add
add :: Nat -> Nat -> Nat
add Z n = n
add (S m) n = S (add m n)
```

## Lista

```hs
-- lista de inteiros
data List = Empty | Cons Integer List

sum :: List -> Integer
sum Empty = 0
sum Const x xs = x + sum(xs) 

-- lista de qualquer tipo
data List a = Empty | Cons a (List a)
data [a]    = []    | a : [a]       -- definicao de lista em Haskell
-- [3, 5, 7] = 3 : (5 : (7 : []))


-- definicao de uma funcao de ordenacao de lista
sort :: [Integer] -> [Integer]
sort [] = []
sort (x:xs) = insert x (sort xs)
insert :: Integer -> [Integer] -> [Integer]
insert x [] = [x]
insert x (y:ys) | x <= y = x : y : ys
                | otherwise = y : insert x ys

-- definicao do quick sort
qsort :: [Integer] -> [Integer]
qsort [] = []
qsort (x:xs) = qsort [y | y <- xs, y <= x] ++ [x] ++ qsort [y | y <- xs, y > x]

-- quick sort utilizando filter
qsort2 :: [Integer] -> [Integer]
qsort2 [] = []
qsort2 (x:xs) = qsort2 (filter (<= x) xs) ++ [x] ++ qsort2 (filter (> x) xs)

-- reverse
reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = (reverse xs) ++ [x]

-- slice - truque de haskell
-- ((+) 1) === (+ 1)


-- sublistas
sub1 :: [a] -> [[a]]
sub1 [] = [[]]
sub1 (x:xs) = map (x:) s ++ s
    where s = sub1 xs

-- combinatoria
comb :: [a] -> Integer -> [[a]]
comb xs 0 = [[]]
comb [] n = []
comb (x:xs) n = map(x:) comb xs (n-1)  ++ comb xs n

-- permutacao

-- insere a na posicao x
insert :: a -> Integer -> [a] -> [a]
insert x 0 ys = x:ys
insert x n (y:ys) = y : insert x (n-1) ys

perm :: [a] -> [[a]]
perm [] = [[]]
perm (x:xs) = concat (map aux ++ (perm xs))
    where aux ys = map aux' [0..length ys]
        where aux' i = insert x i ys
-- outra forma
perm (x:xs) = [insert i ys | ys <- perm xs, i <- [0..length xs]]


```
