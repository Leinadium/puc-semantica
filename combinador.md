# Combinador

```text
K x y   = x
S x y z = (x z) (y z)
I x = x         (I = S K K)
```

qualquer expressão lambda pode ser escrita com os combinadores K e S

## Abstração

```text
\x.e = |e|(x)

|x|(x)     = I
|y|(x)     = K y
|e1 e2|(x) = S |e1|(x) |e2|(x)
|\y. e|(x) = ||e|(y)|(x)

```
