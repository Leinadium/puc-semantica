# Linguagem Funcional Simples CPS

```haskell
eval :: Exp -> Env -> (Value -> Result) -> Result

eval (ExpK n) env k = k (ValInt n)

-- pra abstrair todas as operações de aritmetica
arith :: (Integer -> Integer -> Integer) -> Value -> Value -> Value
arith op (ValInt n1) (ValInt n2) = ValInt(op n1 n2)     -- ou ValInt(n1 `op` n2)
arith _ e@(ValError _) _ = e

eval (ExpAdd e1 e2) env k = eval e1 env (\v1 -> eval e2 env (\v2 -> k (aux v1 v2)))
    where aux (ValInt n1) (ValInt n2) = ValInt(n1 + n2)
    -- ..
    where aux e@(ValError _) _ = 

```

abstraindo a operacao

```haskell
arith :: (Integer -> Integer -> Integer) -> Value -> Value -> Value
arith op (ValInt n1) (ValInt n2) = ValInt(op n1 n2)

binOp :: (Value -> Value -> Value) -> ((Value -> Result) -> Result) -> ((Value -> Result) -> Result) -> (Value -> Result) -> Result 
binOp op c1 c2 k = c1 (\v1 -> c2 (\v2 -> k (op v1 v2)))
```

abstraindo a computação

```haskell
type K a = a -> Result
type Cmpt a = (K a) -> Result     -- (resultado de um "eval e1 env")

binOp :: (Value -> Value -> Value) -> Cmpt Value -> Cmpt Value -> Cmpt Value
binOp op c1 c2 k = c1 (\v1 -> c2 (\v2 -> k (op v1 v2)))


eval (ExpAdd e1 e2) env k =
    binOp (arith (+)) (eval e1 env) (eval e2 env) k

type Value = -- ...
           | ValFunc (Value -> Cmpt Value)
eval (ExpLambda v body) env k = k (ValFunc (\x k' -> eval body (update v x env) k'))


eval (expApp e1 e2) env l = binOp auxOp (eval e1 env) (eval e2 env) k
    where auxOp (ValFunc f) v = f v

```

as coisas ficaram loucas

```haskell
unit :: Value -> Cmpt Value
unit v = \k -> k v
-- unit v k = k v

arith :: (Integer -> Integer -> Integer) -> Value -> Value -> Cmpt Value
arith op (ValInt n1) (ValInt n2) = unit (ValInt (op n1 n2))

eval (expK n) env = unit (Val Func n)

eval (expApp e1 e2) env = binOp auxOp (eval e1 env) (eval e2 env) 
    where auxOp (ValFunc f) v = f v

```
