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
    (a, m')

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
-- para resolver, tentarei aplicar ambos os lados em uma memoria k
-- e comparar os resultados
-- alem disso, pelos tipos,
-- m e x são Cmpt a, 
--      g é (a -> Cmpt b), 
--      h é (b -> Cmpt c)
-- digamos que:
--      (m k) = (A, k') 
--          em que A é do tipo a, k' é do tipo Mem
--      (g A) = A',
--          em que A' é do tipo Cmpt b
--      (A' k') = (B, k'')
--          em que B é do tipo b e k'' é do tipo Mem


-- lado esquerdo
bind (bind m g) h k
-- desenvolvendo o bind de fora
(\n -> let (a, m') = (bind m g) n in h a m') k
-- aplicando o k no lambda
let (a, m') = (bind m g) k in h a m'
-- desenvolvendo o lambda
let (a, m') = (\n -> let (a', m'') = m n in g a' m'') k in h a m'
-- aplicando o k no lambda
let (a, m') = (let (a', m'') = m k in g a' m'') in h a m'
-- desenvolvendo (m k) de acordo com a regra acima
let (a, m') = (let (a', m'') = (A, k') in g a' m'') in h a m'
-- quebrando o let interno
let (a, m') = g A k' in h a m'
-- desenvolvendo o (g A) de acordo com a regra acima
let (a, m') = A' k' in h a m'
-- desenvolvendo o (A' k') de acordo com a regra acima
let (a, m') = (B, k'') in h a m'
-- quebrando o let
h B k''


-- lado direito
bind m (\x -> bind (g x) h) k
-- desenvolvendo o bind de fora
(\n -> let (a, m') = m n in (\x -> bind (g x) h) a m') k
-- aplicando o k no lambda
let (a, m') = m k in (\x -> bind (g x) h) a m'
-- desenvolvendo (m k) de acordo com a regra acima
let (a, m') = (A, k') in (\x -> bind (g x) h) a m'
-- quebrando o let de fora
(\x -> bind (g x) h) A k'
-- aplicando o A no bind no lambda
bind (g A) h k'
-- desenvolvendo o bind
(\n -> let (a, m') = (g A) n in h a m') k'
-- aplicando o k' no lambda
let (a, m') = (g A) k' in h a m'
-- desenvolvendo o (g A) de acordo com a regra acima
let (a, m') = A' k' in h a m'
-- desenvolvendo o (A' k') de acordo com a regra acima
let (a, m') = (B, k'') in h a m'
-- quebrando o let
h B k'' 


-- provado















-- desenvolvendo o bind de fora
(\n -> let (a, m') = (bind m g) n in
    h a m') k
-- aplicando o k
let (a, m') = (bind m g) k in
    h a m'
-- desenolvendo o bind
let (a, m') = (\n -> let (a, m') = m n in (g a m')) k in h a m'
-- aplicando o k no lambda de dentro
let (a, m') = (let (a', m'') = m k in (g a m')) in h a' m''
-- parando aqui, nao da pra continuar

-- lado direito agora
bind m (\x -> bind (g x) h) k
-- desenvolvendo o bind de fora
(\n -> let (a, m') = m n in
    (\x -> bind (g x) h) a m') k
-- aplicando o k
let (a, m') = m k in
    (\x -> bind (g x) h) a m'
-- aplicando o a no lambda
let (a, m') = m k in
    bind (g a) h m'
-- aplicando o bind
let (a, m') = m k in 
    (\n -> let (a, m'') = (g a) n in h a m'') m'
-- aplicando o m' no lambda
let (a, m') = m k in let (a, m') = (g a) m' in h a m'
```
