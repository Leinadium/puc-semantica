# Resolução dos exercícios 3

## Questão 1

`bind (unit x) f = f x`

```hs

bind (unit x) f

-- aplicando a definicao de unit
bind (\m -> (x, m)) f

-- aplicando a definicao de bind
\m -> let (a, m') = (\n -> (x, n)) m    
    in f a m'
    
-- aplicando o lambda dentro do let
\m -> let (a, m') = (x, m) 
    in f a m'

-- resolvendo o let
\m -> f x m        

-- conversão eta
f x

-- provado
```

## Questão 2

`bind m unit = m`

```hs
bind m unit = m

-- para a comparação, entende-se que m é um Cmpt e não uma Mem,
-- porque do lado esquerdo tem um bind que resulta numa Cmpt
bind m unit

-- desenvolvendo o bind
\n -> let (a, m') = m n in 
    unit a m' 

-- desenvolvendo o unit
\n -> let (a, m') = m n in
    (\m -> (a, m)) m'

-- aplicando o lambda gerado do unit
\n -> let (a, m') = m n in
    a m'

-- o let esta escrito como se fosse let A = B in A.
-- parecido com uma transição eta... poderia escrever B direto
\n -> m n

-- transicao eta, removendo o n
m

-- provado
```

## Questão 3

`bind (bind m g) h = bind m (\x -> bind (g x) h)`

```hs
-- todo
```
