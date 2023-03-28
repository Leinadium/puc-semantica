-- provar que
-- add m (add n p) = add (add m n) p

-- definir subtracao de Nat

-- definir um concat para SExp a

-- exercicio 1 (escreva a funcao or)
-- (||) :: Bool -> Bool -> Bool
-- (||) True _ = True
-- (||) False x = x

-- exercicio 4 (escreva uma funcao que verifique se um valor pertence a uma dada lista)
find :: (Eq a) => a -> [a] -> Bool
find _ [] = False
find a (x:xs) = (a == x) || find a xs


main = print (find 10 [5, 15, 20, 30])
