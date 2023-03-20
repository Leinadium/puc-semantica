# Conceitos Básicos do Cálculo Lambda

```
E = var             --> variável
  / E E             --> aplicação (E1 aplicado a E2)
  / λvar. E         --> abstração 
  / constante       --> não existe no lambda calculo puro
```

**O corpo da abstração se extende o máximo possível**:

```
λx.x y  --> lambda x de (x aplicado a y)
```

**Aplicação é da direita pra esquerda**

```f g x``` = ```(f g) x```


## Variáveis Livres e Ligadas (free/bound variables)

- **Ligada**: dentro de um lambda com aquele nome
  - λx.x    <-- x está ligado
- **Livre**: nao estão num lambda
  - λx.x y  <-- y está livre


### Definição formal:

```
FV(x)     = {x}
FV(E1 E2) = FV(E1) U FV(E2)
FV(λx. E) = FV(E) - {x}       <-- x virou bound 
```

## Substituição:

(nos exemplos abaixo, x e y nao sao variaveis, só representações, metavariaveis)

```
E1 [x <- E2]

x[x <- E] = E

y[x <- E] = y
  se x != y

(E1 E2)[x <- E3] = (E1 [x <- E3]) (E2 [x <- E3])

(λx.E1)[x <- E2] = (λx.E1)
  pois nao tem nenhum x livre pra substituir

(λy.E1)[x <- E2] = λy.(E1[x<-E2])
  se x != y, 
  y not in FV(E2)
    pois temos que ver se tem x livre la dentro
    e nao queremos que capture (tem que renomear)

(λy.E1)[x <- E2] = λz.(E1[y <- z][x <- E2])
  se x != y
  com z "fresh"
  pois queremos renomear as variaveis, afinal
  o que tiver dentro de E2 nao deve ser capturado
```

## Combinador:

Uma expressão lambda sem variáveis livres.
No lambda cálculo só existem combinadores

- *identidade (id)*: ```λx.x```

- *funcao constante (K)*: ```λx.λy.x```

- *flip*: ```λf.λx.λy.f y z```

- *aplicador*: ```λg.λf.λx.g (f x)```

- *retorna ela mesmo (omega)*: ```λx.x x```