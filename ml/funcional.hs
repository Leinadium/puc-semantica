-- funcoes novas

-- usando uma implementacao de lista e indice
-- get :: [a] -> Integer -> a
-- get (x:xs) 0 = x
-- get (x:xs n) = get xs (n-1)
-- set :: [a] -> Integer -> a -> [a]
-- set (x:xs) 0 y = y:xs
-- sex (x:xs) n y = x:(set xs (n-1)y)
-- ref :: [a] -> a -> ([a], Integer)
-- ref xs x = (xs ++ [x], length)



-- cria uma referencia (Location) com o valor
-- ref :: Value -> Location
-- pega o valor de uma referencia (Location)
-- get :: Location -> Value
-- coloca o valor de uma referencia (Location)
-- set :: Location  -> Value -> Value


set :: Mem -> Int -> Value -> Mem
get :: Mem -> Int -> Value
newref :: Mem -> Value -> (Int, Mem)

data Value = ValInt Integer
           | ValRef Integer
           | ValFunc (Value -> Mem -> (Value, Mem))

-- uma expressão, env, uma memoria, e retorna o valor com a memoria atualizada
eval :: Exp -> Env -> Mem -> (Value, Mem)

-- expressão constante
eval (ExpK n) env m = (ValInt n, m)
-- avaliação de variável
eval (ExpVal v) env m = (query env v, m)
-- adicao
eval (ExpAdd e1 e2) env m = 
    let (v1, m') = eval e1 env m in
        let (v2, m'') = eval e2 env m' in
            (aux v1 v2, m'')
    where aux (ValInt a) (ValInt b) = ValInt (a + b)
    -- ... casos de erro

-- deref
eval (ExpDeRef e) env m = 
    let (v, m') = eval e env m in 
        case v of
            ValRef r = (get m' r, m')
            -- ... casos de erro

-- assg
eval (ExpAssg e1 e2) env m =
    let (v1, m') = eval e1 env m in
        let (v2, m'') = eval e2 env m' in
            case v1 of
                ValRef r = (v2, set m'' r v2)
                -- ... casos de erro

-- newref
eval (ExpNewRef e) env m =
    let (v, m') = eval e env m in
        newref m' v

-- lambda
eval (ExpLambda v e) env m = 
    (ValFunc (\x m' -> eval x (update v x env) m'), m)

-- aplicação de lambda
eval (ExpApp e1 e2) env m =
    let (v1, m') = eval e1 env m in
        let (v2, m'') = eval e2 env m' in
            case v1 of
                ValFunc f = f v2 m''