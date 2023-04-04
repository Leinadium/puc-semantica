# Exercicios 1

```haskell
map f [] = []
map f (x:xs) = f x : map f xs

(.) f g x = f (g x)

len [] = 0
len (x:xs) = 1 + len xs

reverse [] = []
reverse (x:xs) = reverse xs ++ [x]
```

## Usando as definições acima, prove as propriedades abaixo

* ```map (g . f) = map g . map f```

* ```len . reverse = len```


## Considere a definição de naturais abaixo

```haskell
data Nat = Z | S Nat
```

* Defina uma função ( ```sub :: Nat -> Nat -> Nat``` ) para subtração truncada (monus) de naturais.

* Prove que, para todo n, sub n n = Z

## Defina uma relação (less :: Nat -> Nat -> Bool) que retorna "true" se e somente se o primeiro número for menor que o segundo


## Considere a definição de árvores binárias abaixo

```haskell
data BinTree a = EmptyTree | Node a (BinTree a) (BinTree a) deriving (Show)
```

* Escreva uma função que retorne o somatório dos elementos de uma árvore.

* Escreva uma função que retorne a altura de uma árvore.

* Escreva uma função que retorne uma lista de todos os elementos de uma árvore em "in order".
