# exercicio relacionado a monadas

```haskell
type Env = [(String, Cmpt Value)]

query :: String -> Env -> Cmpt (Cmpt Value)
query v [] = error ...
query v [(v', c):xs] = if v==v' then unit c
                       else query v xs

eval :: Exp -> Env -> Cmpt Value 
eval (ExpVar v) env

```
