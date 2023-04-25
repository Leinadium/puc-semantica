-- nova definicao de exp
data Exp = EConst Integer
         | EAdd Exp Exp
         | -- ...
         | EVar String


-- agora, eval precisa receber a expressao e a memoria
eval :: Exp -> Mem -> Integer
eval (EVar v)     m = query m v
eval (EConst n)   m = n
eval (EAdd e1 e2) m = eval e1 m + eval e2 m
-- ...

-- definicao de comandos
data Cmd = CmdAssg  String Exp
         | CmdIf    Exp Cmd Cmd
         | CmdWhile Exp Cmd
         | CmdSeq   Cmd Cmd
         | CmdSkip  -- comando vazio


evalCmd :: Cmd -> Mem -> Mem
evalCmd CmdSkip m         = m
evalCmd (CmdSeq c1 c2) m  = evalCmd c2 (evalCmd c1 m)
evalCmd (CmdAssg v e) m   = update m v (eval e m)    -- a definir

evalCmd (CmdWhile cond body) m = w m
    where w m = if (eval cond m) == 0 then m
                else w (evalCmd body m)

-- definicao de memoria
query  :: Mem -> String -> Integer
update :: Mem -> String -> Integer -> Mem

-- "axiomas" da memoria:
-- query (update m var n) var = n
-- query (update m var1 n) var 2 = query m var2    [para var1 != var2]

type Mem = String -> Integer
emptyMem :: Mem
emptyMem = \var -> 0

query  :: Mem -> String -> Integer
query m var = m var

update :: Mem -> String -> Integer -> Mem
update m var n = \var' -> if var' == var then n else m var'


-- main loop
main = print (query (evalCmd prog emptyMem) "result")