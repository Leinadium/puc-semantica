# Type Classes

## Definição

```hs
-- classe 
class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool

    -- implementacao default
    x /= y = not (x == y)

data X = XA|XB

-- funcao auxiliar para ser usada na implementacao
eqX :: X -> X -> Bool
eqX XA XA = True
eqX XB XB = True
eqX _  _  = False

-- implementacao
instance Eq X where
    (==) = eqX
    (/=) x y = not (x == y)


-- exemplo de uso da instancia Eq de X
dentro :: Eq a => a -> [a] -> Bool
dentro _ [] = False
dentro y (x:xs) = (y == x) || dentro y xs
```

## Subclasse

```hs
class Eq a => Ord a where
    (>), (>=), (<), (<=) :: a -> a -> Bool
    max, min :: a -> a -> a
    -- implementacoes default
    a >= b = b <= a
    a > b = not (a <= b)
    a < b = not (b <= a)
    max x y = if x <= y then y else x

```

## Deriving

Implementa as funções "óbvias"

```hs
data X = XA|XB deriving Eq
```

## Classes famosas

```hs
class Functor f where
    fmap :: (a -> b) -> f a -> f b
    (<$) :: a -> f b -> f a
    -- implementacoes default
    x <$ f = fmap (const x) f

class Functor f => Applicative f where
    (<*>) :: f (a -> b) -> f a -> f b
    pure  :: a -> f a


class Applicative m => Monad m where
    return :: a -> m a
    (>>=)  :: M a -> (a -> M b) -> M b
    -- implementacoes default
    return = pure 

```

## Exemplo

```hs
type Maybe a = Just a | Nothing

-- declarando unit e bind
unit :: a -> Maybe a
unit x = Just x

bind :: Maybe a -> (a -> Maybe b) -> Maybe b
bind Nothing f = Nothing
bind (Just x) f = f x

instance Monad Maybe where
    return = unit
    (>>=) = bind

instance Applicative Maybe where
    pure = unit
    mf <*> mx = bind mf (\f -> bind mx (\x -> unit (f x)))

instance Functor Maybe where
    fmap f m = bind m (unit . f)

```
