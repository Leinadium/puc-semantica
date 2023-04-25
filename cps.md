# CPS (Continuation-Passing Style)

```hs
f :: A -> B -> C
f' :: A -> B -> (C -> Res) -> Res
```

exemplo fibonacci

```hs
fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib(n-1) + fib(n-2)

fib' :: Integer -> (Integer -> a) -> a
fib' 0 k = k 0
fib' 1 k = k 1
fib' n k = fib' (n-1)(\n' -> fib'(n-2) (\n'' -> k (n' + n'')))

```

fazendo a linguagem

```haskell
evalCmd :: Cmd -> Mem -> (Mem -> Res) -> Res
evalCmd CmdSkip m k = k m
evalCmd (CmdAssg var e) m k = update m var (eval e m) k
evalCmd (CmdSeq c1 c2) m k = evalCmd c1 m (\m' -> evalCmd c2 m' k)
                                    -- ou (flip(evalCmd c2) k)
evalCmd (CmdWhile cond body) m k = w m
    where w m' k' = if eval cmd m' == 0 then k m'
                    else evalCmd body m' (\m'' -> w m'')

-- ...

type Mem = String -> (Integer -> Res) -> Res
emptyMem :: Mem
emptyMem var k = print (var ++ " undefined")

query :: Mem -> String -> (Integer -> Res) -> Res
query m var k = m var k

update :: Mem -> String -> Integer -> (Mem -> Res) -> Res
update m var x k = k (\var' k' -> if var' == var then k' x else m var' k')

```
