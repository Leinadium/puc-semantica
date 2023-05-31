# Exercicios 3

**Considere as definições abaixo:**

```haskell
type Mem = Int

type Cmpt a = Mem -> (a, Mem)

unit :: a -> Cmpt a
unit x = \m -> (x, m)

bind :: Cmpt a -> (a -> Cmpt b) -> Cmpt b
bind ca f = \m -> let (a, m') = ca m in
                    f a m'
```

Baseado nessas definições, prove as seguintes igualdades:

- 1. `bind (unit x) f = f x`

- 2. `bind m unit = m`

- 3. `bind (bind m g) h = bind m (\x -> bind (g x) h)`
