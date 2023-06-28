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


-- sp (pula os espacos em brancos, continuando a partir do ultimo)
import Data.Char
sp :: Parser ()
sp = many (sat isSpace) >> return ()

-- char (verifica se o proximo eh um caracter especifico)
char :: Char -> Parser Char
char c = sat (== c)

-- string (verifica se o proximo eh uma string especifica)
string :: String -> Parser String
string [] = sp
string (c:cs) = char c >> string cs

-- exemplo de match num "nome"
name :: Parser String
name = do c  <- sat isAlpha
          cs <- many (sat isAlphaNum)
          sp
          return (c:cs)

```

## Parser de uma expressão

```haskell
-- queremos um parser para as nossas expressoes
data Exp = ExpK Integer | ExpAdd Exp Exp -- ...

-- ExpK
p_int :: Parser String 
p_int = do n <- many1 (sat isDigit)
           sp
           return ExpK (read n)     -- read: transforma uma string para inteiro

-- ExpVar
p_var :: Parser Exp
p_var = do n <- name 
           if (elem n rw) then fail ""
           else
           return ExpVar n
    where rw = ["if", "then", "else", "let", "in"]

-- Ve o parenteses
p_var :: Parser Exp
p_par = do string "("
           e <- p_exp
           string ")"
           return e

-- uma expressao primária (inteiro ou variavel ou parenteses)
-- p_primary = p_int `orelse` p_var `orelse` p_par

-- aplicação
p_app :: Parser Exp
p_app = do lp <- many1 p_primary
           return foldl1 ExpApp lp


-- um parser que aceita várias strings
strings :: [String] -> Parser String
strings [] = fail ""
strings (x:xs) = (string x >> return x) `orelse` strings xs

-- um parser pra pares
pairs :: Parser a -> Parser b -> Parser (a, b)
pairs pa pb = do a <- pa
                 b <- pb
                 return (a, b)


-- e_mul = primary (mulOp primary)*
-- e_add = e_mul (addOp e_mul)
-- e_comp = e_add (compOp e_add)
-- e_mul = binExp primary mulOp

-- uma expressão binaria
-- por exemplo, e_mul = binExp primary ["*", "/", "%"]
binExp :: Parser Exp -> [String] -> Parser Exp
binExp p ops = do e <- p
                  es <- many (pair (strings ops))
                  return buildBinExp e es


buildBinExp :: Exp -> [(String, Exp)] -> Exp
buildBinExp e l = foldl f e l
    where f e (op, e') = (binOp) e e'
          bindOp "+" = ExpAdd
          bindOp "-" = ExpSub
          -- ...


p_if :: Parser Exp
p_if = do string "if"
          c <- p_exp
          string "then"
          tl <- p_exp
          string "else"
          el <- p_exp
          return (ExpIf c th el)


p_lambda :: Parser Exp
p_lambda = do string "\\"
           var <- name
           string "->"
           body <- p_exp
           return (ExpLambda var body)


p_exp :: Parser Exp
p_exp = sp >> (p_if `orelse` p_lambda `orelse` p_let `orelse` p_arith)

```
