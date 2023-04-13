# Resolução dos exercicios 1

Daniel Guimarães - 1910462

Arquivo melhor visualizado em um editor compativel com o formato `markdown`.

## Questao 1

```haskell
map f [] = []
map f (x:xs) = f x : map f xs

(.) f g x = f (g x)

len [] = 0
len (x:xs) = 1 + len xs

reverse [] = []
reverse (x:xs) = reverse xs ++ [x] 
```

Prove as propriedades abaixo:

### Questão 1(a)

```map (g . f) = map g . map f```

```text
Caso base: Seja x = []
Então:  (1) -->  map (g . f) [] = []
        (2) --> map g . map f x = map g (map f x) = map g [] = []
        (1) = (2)

Passo indutivo: Seja x:xs
        (1) --> map (g . f) x:xs = 
              = (g . f) x : map (g . f) xs
              = g (f x) : map (g . f) xs
      (HI)  === g (f x) : map g . map f xs
              = g (f x) : map g (map f xs)

        (2) --> (map g . map f) x:xs
              = map g (map f x:xs)
              = map g (f x : map f xs)
              = g (f x) : map g (map f xs) 
```

### Questão 1(b)

```len . reverse = len```

```text
Caso base: Seja x = []
Então:  (1) -> len . reverse [] = len (reverse []) = len([]) = 0
        (2) -> len [] = 0
        (1) = (2)

Passo indutivo: Seja x:xs
        (1) -> len . reverse x:xs
             = len (reverse x:xs)
             = len (reverse xs ++ [x])
             = 1 + len (reverse xs)

        (2) -> len x:xs = 1 + len(xs)
    (HI)  ===  1 + len . reverse xs
            =  1 + len (reverse xs)
```

## Questão 2

Considere a definição de naturais abaixo:

```haskell
data Nat = Z | S Nat
```

### Questão 2(a)

Defina uma função para subtração truncada (monus de naturais)

```haskell
sub :: Nat -> Nat -> Nat
sub Z _ = Z
sub n Z = n
sub (S m) (S n) = sub m n
```

### Questão (b)

Prove que, para todo n, sub n n = Z

```text
Caso base: seja n = Z
Então: sub Z Z = Z (por definicao)

Passo indutivo: Seja para um n = (S x)
Então, sub n n = sub (S x) (S x) = sub x x
          (HI) = Z
```

## Questao 3

Defina uma relação que retorna "true" se e somente se o primeiro número
for menor que o segundo

```haskell
less :: Nat -> Nat -> Bool
less _ Z = False
less m n | (sub m n == Z) = True 
         | otherwise      = False
```

## Questao 4

Considere a definição de árvores binárias abaixo:

```haskell
data BinTree a = EmptyTree | Node a (BinTree a) (BinTree a) deriving show
```

### Questao 4(a)

Escreva uma funçao que retorne o somatória dos elementosde uma árvore

```haskell
sum :: BinTree Integer -> Integer
sum EmptyTree = 0
sum Node x n1 n2 = x + sum(n1) + sum(n2)
```

### Questao 4(b)

Escreva uma função que retorne a altura de uma árvore

```haskell
max :: Integer -> Integer -> Integer
max m n | m >= n    = m
        | otherwise = n

height :: BinTree a -> Integer
height EmptyTree = 0
height Node _ n1 n2 = 1 + max(h1, h2)
           where h1 = height(n1)
                 h2 = height(n2)
```

### Questão 4(c)

Escreva uma função que retorne uma lista e todos os elementos
de uma árvore em "in order".

```haskell
flat :: BinTree a -> List a
flat EmptyTree = []
flat Node x n1 n2 = flat n1 : x : flat n2
```
