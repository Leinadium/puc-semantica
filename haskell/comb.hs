insert1 :: a -> Int -> [a] -> [a]
insert1 x 0 ys = x:ys
insert1 x n (y:ys) = y : insert1 x (n-1) ys

perm1 :: [a] -> [[a]]
perm1 [] = [[]]
perm1 (x:xs) = [insert1 x i ys | ys <- perm1 xs, i <- [0..(length xs)]]

