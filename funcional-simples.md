# Linguagem Funcional Simples

```haskell
data Exp = ExpK Integer
         | ExpVar String
         | ExpAdd Exp Exp
         -- ...
         | ExpLambda String Exp
         | ExpApp Exp Exp
         | ExpIf Exp Exp Exp
         | ExpLet String Exp Exp -- let recursivo (letrec): let var = exp1 in exp2    
```

```haskell
-- implementacao de env pode ser igual ao mem

data Value = ValK Integer
           | ValLambda String Exp Env
           | ValError String


eval :: Exp -> Env -> Value

eval (ExpAdd e1 e2) env = aux (eval e1) (eval e2)
    where aux (ValK n1) (ValK n2) = ValK(n1 + n2)

eval (ExpLambda var body) env = ValLambda var body env

-- apply
eval (ExpApp e1 e2) env = aux (eval e1 env) (eval e2 env)
    where aux (ValLambda var body env') v = 
        eval body (update var v env')

-----------------------------------------------------
-- nova definicao do lambda usando uma nova definicao
data Value = -- ...
           | ValFunc (Value -> Value)

eval (ExpLambda var body) env = ValFunc (\x -> eval body (update var x env))

eval (ExpApp e1 e2) env = aux (eval e1 ev) (eval e2 env)
    where aux (ValFunc f) v = f v
-- funciona por conta da visibilidade lexica do haskell
-- embedding

-- let rec
eval (ExpLet var exp body) env = eval body env'
    where env' = updat var (eval exp env') env
```
