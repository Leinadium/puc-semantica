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
  return = pure
  (>>=) = bind


failX :: String -> Parser a
failX _ = Parser (\s -> [])

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
sat p = item >>= (\c -> if p c then return c else failX "")

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

-- char_sp(x) = x\w+
-- nao usado mais, em favor do string :(
char_sp :: Char -> Parser Char
char_sp x = 
  do char x
     sp
     return x 

-- string (copiado do professor)
string :: String -> Parser ()
string [] = sp
string (x:xs) =
  do char x
     string xs
     return ()

-- strings (copiado do professor)
strings :: [String] -> Parser String
strings [] = failX ""
strings (x:xs) = (string x >> return x) `orelse` strings xs


-----------------------------------------------------------------------
data Exp = ExpK Float
         | ExpAdd Exp Exp
         | ExpSub Exp Exp
         | ExpMul Exp Exp
         | ExpDiv Exp Exp
           deriving Show


-- int = [0-9]+
p_int :: Parser Exp
p_int =
  do n <- many1 (sat isDigit)
     sp
     return (ExpK (read n)) -- read: transforma uma string para inteiro

-- parenteses = \(int\)
p_par :: Parser Exp
p_par = do char_sp '('
           e <- p_exp
           char_sp ')'
           return e

-- primary (simples)
p_simples = p_int `orelse` p_par

-- buildBinExp (copiado do professor)
buildBinExp :: Exp -> [(String, Exp)] -> Exp
buildBinExp e l = foldl f e l
  where
    f e (op, e') = binOp op e e'
    binOp :: String -> (Exp -> Exp -> Exp)
    binOp "+" = ExpAdd
    binOp "-" = ExpSub
    binOp "*" = ExpMul
    binOp "/" = ExpDiv


-- expressao binaria (copiado do professor)
binExp :: Parser Exp -> [String] -> Parser Exp
binExp elem ops =
  do e <- elem
     es <- many (pair (strings ops) elem)
     return (buildBinExp e es)

p_mul :: Parser Exp
p_mul = binExp p_simples ["*", "/"]

p_sum :: Parser Exp
p_sum = binExp p_mul ["+", "-"]

p_exp = sp >> p_sum



---------------------------------------------
-------------- fazendo o eval ---------------
---------------------------------------------
-- data Maybe a = Just a | Nothing

type Value = Maybe Float

unitM :: a -> Maybe a
unitM x = Just x

bindM :: Value -> (Float -> Value) -> Value
bindM Nothing f = Nothing
bindM (Just x) f = f x


evalExp :: Exp -> Value

evalExp (ExpK x) = Just (x)

evalExp (ExpAdd e1 e2) = bindM (evalExp e1) (\v1 -> bindM (evalExp e2) (\v2 -> unitM (v1 + v2)))

evalExp (ExpSub e1 e2) = bindM (evalExp e1) (\v1 -> bindM (evalExp e2) (\v2 -> unitM (v1 - v2)))

evalExp (ExpMul e1 e2) = bindM (evalExp e1) (\v1 -> bindM (evalExp e2) (\v2 -> unitM (v1 * v2)))

evalExp (ExpDiv e1 e2) = bindM (evalExp e1) (\v1 -> bindM (evalExp e2) (\v2 -> divisao v1 v2))
  where divisao x1 x2 = if (x2 == 0) then Nothing else unitM (x1 / x2) 


applyExp :: [(Exp, String)] -> Value
applyExp [] = Nothing
applyExp ( (e, s):xs ) = if s == "" then evalExp(e) else Nothing

eval :: String -> Value
eval s = applyExp (apply p_exp s)


prog = " 14 + 23 - (4 / 3)  "

main = print (eval prog)