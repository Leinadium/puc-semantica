# Resolução dos exercicios 1

## Definição basica

```haskell
map f [] = []
map f (x:xs) = f x : map f xs

(.) f g x = f (g x)

len [] = 0
len (x:xs) = 1 + len xs

reverse [] = []
reverse (x:xs) = reverse xs ++ [x] 
```

## Questao 1

Prove as propriedades abaixo:

### map (g . f) = map g . map f

```text
Caso base:
    map

```
