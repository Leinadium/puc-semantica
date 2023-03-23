main = print (fact 100)

fact :: Integer -> Integer
fact = \n -> case n of
             0 -> 1
             m -> n * fact(n - 1)