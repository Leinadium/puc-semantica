# Mônadas

## Discussões anteriores

```haskell
unit :: a -> [a]
map :: (a -> b) -> ([a] -> [b])

bind :: (a -> [b]) -> ([a] -> [b])
bind f = concat . (map f)

bind2 :: (a -> b -> [c]) -> ([a] -> [b] -> [c])
bind2 op xs ys = bind aux xs
    where aux x = bind aux' ys
        where aux' y = op x y
```

## Requerimentos

- (1) Construtor de tipos ```type M a = ...```

- (2) ```unit :: a -> M a```

- (3) ```bind :: M a -> (a -> M b) -> M b```

- (4) propriedades
  - não existe ```M a -> a``` (impossível retirar da caixinha **até o final**)
  - (1) ```bind (unit x) f = f x```
  - (2) ```bind m unit = m```
  - (3) ```bind (bind m f) g = bind m (\x -> bind (f x) g)```

## Exemplos

```haskell
-- Id:
type M a = a
unit x = x
bind x f = f x

-- Maybe
type M a = Maybe a
unit = Just
bind Nothing f = Nothing
bind (Just x) f = f x

-- Listas
type a = []
unit x = (x:[])
bind xs f = concat (map f xs)
```

## Tipo computacação

```haskell
type Cmpt a = K a -> Result
type K a = a -> Result

unit :: a -> Cmpt a
unit x = \k -> k x

bind :: Cmpt a -> (A -> Cmpt b) -> Cmpt b
bind cp f = \k -> cp (\x -> f x k)
```

## Evaluando

```haskell
data Value = ValInt Integer
           | ValFunc (Value -> Cmpt Value)

eval :: Exp -> Env -> Cmpt Value

eval (ExpK n) env       = unit (ValInt n)

eval (ExpVar v) env     = query env v

eval (ExpAdd e1 e2) env = 
  bind (eval e1 env) (\v1 -> bind (eval e2 env) (\v2 -> aux v1 v2))
    where aux (ValInt i1) (ValInt i2) = unit (ValInt(i1 + i2))

eval (ExpLambda var body) env = 
  unit (ValFunc (\x -> eval body (update var x env)))

eval (ExpApp e1 e2) env = 
  bind (eval e1 env) (\v1 -> bind (eval e2 env) (\v2 -> aux v1 v2))
    where aux (ValFunc f) x = f x
  -- OUTRA OPCAO
  -- bind (eval e1 env) aux
  --  where aux (ValFunc f) = bind (eval e2 env) (\x -> f x)

-- letrec var = e1 in e2
-- letrec var = (\var1 -> e1) in e2
eval (ExpLet var var1 e1 e2) env = eval e2 env'
  where env' = update var (ValFunc (\x -> eval e1 (update var1 x env'))) env


-- formula alternativa
unit :: a -> M a
fmap :: (a -> b) -> M a -> M b
join :: M (M a) -> M a

-- definindo bind em funcao de join e fmap
bind :: M a -> (a -> M b) -> M b
bind m f = join (fmap f m)

-- definindo fmap e bind em funcao de bind e id
fmap f m = bind m (unit . f)
join m = bind m id

-- provando bind
bind m f = bind (fmap f m) id
         = bind (bind m (unit . f)) id
         = bind m (\x -> bind ((unit . f) x) id)
         = bind m (\x -> bind (unit (fx)) id)
         = bind m (\x -> id (fx))
         = bind m (\x -> fx)
         = bind m f

-- provando fmap
fmap f m = bind m (unit . f)
         = join (fmap (unit . f) m)
         = join (fmap unit (fmap f m))
         = fmap f m
-- provando join
join m = bind m id = join (fmap id m) = join m

```
