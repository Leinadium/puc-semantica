# Conceitos do Cálculo Lambda

## Teorema de Church

```
Se P --(*)--> Q e P --(*)-->Q', existe um Z tal que
   Q --(*)--> Z e Q --(*)-->Z

```

Só existe uma forma normal.

Começando pelo λ mais de fora, vai sempre chegar na melhor forma. 
    Porém pode não ser a forma mais eficiente...


## Algumas conversões

### Conversão α

Basicamente conversão de nome de variável

```
λx --(α)--> λy   M[x <- y])
  y not in FV(E2)

```

### Conversão beta

Basicamente aplicação

```
(λx. E1) E2 --(β)--> M[E1 <- E2]

```

### Conversão eta

```
(λx. E1 x) --(η)--> E1
```





λ