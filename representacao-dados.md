# Representação de Dados

## Booleans

```
TRUE = (λx.λy. x)     -- retorna o primeiro
FALSE = (λx.λy. y)    -- retorna o segundo
IF = (λc.λt.λe. c t e)  -- meio estupido
```

```
a and b = if a then b else a
AND = (λa.λb. a b a)


a or b = if a then a else b
OR = (λa.λb. a a b)


NOT = λa. a FALSE TRUE
```


## Numeros naturais

```
n = repetir/aplicar alguma coisa f (n vezes) em algum valor
n = λf. λz. f(f(f(f...[n vezes]...(f z))))...)

```

```
zero = λf.λv. v
one = λf.λv. f v
two = λf.λv. f (f v)
...
```

```
inc = λn.λf.λz f(n f z)     -- dado um numero, funcao e valor
                            -- aplique n vezes, e depois
                            -- mais uma vez

add = λm.λn.(m inc n)       -- aplique inc sobre n, m vezes

mul = λm.λn.(λf.λz m(nf)z) 
```