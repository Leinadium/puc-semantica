data Nat = Z | S Nat deriving Show

-- declaracao de add
add :: Nat -> Nat -> Nat
add Z n = n
add (S m) n = S (add m n)

fromI :: Integer -> Nat
fromI 0 = Z
fromI n = S (fromI (n-1))

fromNat :: Nat -> Integer
fromNat Z = 0
fromNat (S n) = 1 + fromNat(n)

-- declaracao de sub
sub :: Nat -> Nat -> Nat
sub Z _ = Z
sub n Z = n
sub (S m) (S n) = sub m n 

-- reverse (pesado, pois muitas recursos no ++)
rev :: [a] -> [a]
rev [] = []
rev (x:xs) = (rev xs) ++ [x]