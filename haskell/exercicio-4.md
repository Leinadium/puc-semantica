# Exercicio 4

Usando as técnicas de Parser Combinator vistas em aula, escreva
um avaliador simples de expressões aritméticas em Haskell.
Seu avaliador deve tratar os quatro operadores aritméticos usuais
(+,-,*,/) e expressões entre parênteses. Mais exatamente, você
deve implementar uma função como descrita abaixo:

```haskell
-- tipo:
eval :: String -> Maybe Double

-- exemplos:
eval " 14 + 23 - (4 / 3)  "  -- > Just 35.666666666667
eval "25-14"      -- > Just 11
eval " 24 - "     -- > Nothing
```

Você deve basear sua implementação em [1]. Copie esse arquivo
até a definição "sp" (linha 68), e a partir daí desenvolva
sua parte.

O exercício deve ser entregue como um único arquivo contendo o
programa em Haskell. Comente tudo que achar necessário.

[1 - http://www.inf.puc-rio.br/~roberto/sem/parser.hs.html](http://www.inf.puc-rio.br/~roberto/sem/parser.hs.html)

## Parser completo

```haskell


import Data.Char

newtype Parser a = Parser (String -> [(a, String)])

apply :: Parser a -> (String -> [(a, String)])
apply (Parser f) = f


unit :: a -> Parser a
unit x = Parser (\s -> [(x, s)])

bind :: Parser a -> (a -> Parser b) -> Parser b
bind m f  = Parser (\s -> concat (map f' (apply m s)))
   where f' (a, s) = apply (f a) s


instance Functor Parser where
  fmap f m = bind m (unit . f)


instance Applicative Parser where
  pure = unit
  pf <*> px = bind pf (\f -> bind px (\x -> unit (f x)))


instance Monad Parser where
  return = unit
  (>>=) = bind
  fail _ = Parser (\s -> [])


item :: Parser Char
item = Parser f
  where f [] = []
        f (x:xs) = [(x, xs)]

(+++) :: Parser a -> Parser a -> Parser a
p +++ p' = Parser f
  where f s = apply p s ++ apply p' s

orelse :: Parser a -> Parser a -> Parser a
p `orelse` p' = Parser f
  where f s = let l = apply p s in if null l then apply p' s else l


sat :: (Char -> Bool) -> Parser Char
sat p = item >>= (\c -> if p c then return c else fail "")

char :: Char -> Parser Char
char c = sat (== c)

pair :: Parser a -> Parser b -> Parser (a,b)
pair pa pb =
  do a <- pa
     b <- pb
     return (a,b)

many :: Parser a -> Parser [a]
many p = many1 p `orelse` return []

many1 :: Parser a -> Parser [a]
many1 p =
  do x <- p
     xs <- many p
     return (x:xs)

sp :: Parser ()
sp = many (sat isSpace) >> return ()

string :: String -> Parser ()
string [] = sp
string (x:xs) =
  do char x
     string xs
     return ()

strings :: [String] -> Parser String
strings [] = fail ""
strings (x:xs) = (string x >> return x) `orelse` strings xs

name :: Parser String
name =
  do name <- many1 (sat isAlphaNum)
     sp
     return name

----------------------------------------------------------------------
type Var = String

data Exp = ExpK Integer          -- constants
         | ExpVar Var            -- variables
         | ExpAdd Exp Exp        -- e1 + e2
         | ExpSub Exp Exp        -- e1 - e2
         | ExpMul Exp Exp        -- e1 * e2
         | ExpDiv Exp Exp        -- e1 / e2
         | ExpIf Exp Exp Exp     -- if e1 then e2 else e3
         | ExpApp Exp Exp        -- e1 e2
         | ExpLambda Var Exp     -- \x -> e
         | ExpLetrec Var Var Exp Exp        -- letrec x=(\x'->e') in e
             deriving Show


-- int = digit+
p_int :: Parser Exp
p_int =
  do n <- many1 (sat isDigit)
     sp
     return (ExpK (read n))


-- var = alphanum+   (except reserved words)
p_var :: Parser Exp
p_var =
  do name <- name
     if (elem name rw) then fail ""
                       else return (ExpVar name)
  where
    rw = ["if", "then", "else", "letrec", "in"]


-- par = '(' exp ')'
p_par :: Parser Exp
p_par =
  do string "("
     x <- p_exp
     string ")"
     return x


p_primary :: Parser Exp
p_primary = p_int `orelse` p_var `orelse` p_par


-- app = primary+
p_app :: Parser Exp
p_app =
  do exps <- many1 p_primary
     return (foldl1 ExpApp exps)


buildBinExp :: Exp -> [(String, Exp)] -> Exp
buildBinExp e l = foldl f e l
  where
    f e (op, e') = binOp op e e'
    binOp :: String -> (Exp -> Exp -> Exp)
    binOp "+" = ExpAdd
    binOp "-" = ExpSub
    binOp "*" = ExpMul
    binOp "/" = ExpDiv

-- binExp = elem (ops elem)*
binExp :: Parser Exp -> [String] -> Parser Exp
binExp elem ops =
  do e <- elem
     es <- many (pair (strings ops) elem)
     return (buildBinExp e es)

p_mul :: Parser Exp
p_mul = binExp p_app ["*", "/"]

p_sum :: Parser Exp
p_sum = binExp p_mul ["+", "-"]

p_arith = p_sum

-- if = 'if' exp 'then' exp 'else 'exp
p_if :: Parser Exp
p_if =
  do string "if"
     cond <- p_exp
     string "then"
     th <- p_exp
     string "else"
     el <- p_exp
     return (ExpIf cond th el)

-- lambda = '\' name '->' exp
p_lambda :: Parser Exp
p_lambda =
  do string "\\"
     var <- name
     string "->"
     body <- p_exp
     return (ExpLambda var body)

-- let = 'letrec' name '=' '\' name '->' exp 'in' exp
p_let :: Parser Exp
p_let =
  do string "letrec"
     var <- name
     string "="
     string "\\"
     var' <- name
     string "->"
     f <- p_exp
     string "in"
     bd <- p_exp
     return (ExpLetrec var var' f bd)
     

p_exp :: Parser Exp
p_exp = sp >> (p_let `orelse` p_lambda `orelse` p_if `orelse` p_arith)
----------------------------------------------------------------------

prog = "\\x -> letrec y = \\x -> x * 5 in if x then y a b else b * 25"


main = print (apply p_exp prog)
```