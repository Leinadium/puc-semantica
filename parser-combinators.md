# Parser Combinators

A ideia que queremos ter é ago desse tipo

```haskell
-- usando type
-- (mas ele nao cria um tipo novo)
type Parser a = String -> [ (a, String) ]

-------------------------------------------
-- usando data
-- (cria um P que contem a funcao, mas não é ideal)
data Parser a = P (String -> [(a, String)])

-------------------------------------------
-- usando newtype
newtype Parser a = P (String -> [a, String])

apply :: Parser a -> String -> [(a, String)]
apply (P f) s = f s     -- primeira opcao
apply (P f) = f         -- segunda opcao (so desempacota)
```

Fazendo o nosso mônada

```haskell
unit :: a -> Parser a
unit x = P (\s -> [(x, s)])

bind :: Parser a -> (a -> Parser b) -> Parser B
bind m f = P (\s -> concat (map f' (apply m s)))
    where f' (a, s') = apply (f a) s'

-- chatice
instance Functor Parser where
    fmap f m = bind m (unit . f)
instance Applicative Parser where
    pure = unit
    pf <*> px = bind pf(\f -> bind px (\x-> unit (f x)))
instance Monad Parser where
    return = unit
    (>>=) = bind
    fail _ = P (\s -> [])

```

## Parser

```haskell

-- parser que somente le um caracter
item :: Parser Char
item = P f
    where f [] = []
          f(x:xs) = [(x, xs)]

-- parser que le um caracter se ele satisfaz a funcao
sat :: (Char -> Bool) -> Parser Char
sat p = item >>= (\c -> if p c then return c else fail "")
sat p = do c <- item if p c then return c else fail ""  -- outra forma, usando do

--- ou, de regex. Casa se um dos parsers casarem
(+++) :: Parser a -> Parser a -> Parser a
p +++ p' = P (\s -> apply p s ++ apply p' s)

-- ou com else
orelse :: Parser a -> Parser a -> Parser a
p `orelse` p' = P (\s = let l = apply ps in
                        if null l then apply p' s
                            else l)

-- many (0 ou mais, equivalente ao *)
many :: Parser a -> Parser [a]
many p = many1 p `orelse` return []

-- many (1 ou mais, equivalente ao +)
many1 :: Parser a -> Parser [a]
many1 p = do  x <- p
             xs <- many p
             return (x:xs)
```
