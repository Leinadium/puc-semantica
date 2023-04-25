# Exercicio 2

Nos dois exercicios a seguir, escreva apenas o código extra e as mudanças necessárias no código original (mais ou menos como se fosse um `diff`). Use os números de linha para indicar onde as mudanças se encaixam no código original.

## Parte 1

No interpretador "Simple Imperative Language" [1](http://www.inf.puc-rio.br/~roberto/sem/imper.hs.html), acrescente um
comando de atribuição múltipla: na sintaxe, esse comando é composto
de uma lista de variáveis e uma lista de expressões. Na semântica,
ele atribui o valor de cada expressão à variável correspondente.
(Escreva uma função auxiliar para fazer a recursão sobre as listas.)
Decida o que fazer caso as listas tenham tamanhos diferentes.

```haskell
data Cmd = CmdAsg [Var] [Exp]       -- linha 55

-- novas linhas
evalAttr :: [Var] -> [Exp] -> Mem -> Mem
evalAttr [] [] m = m
evalAttr [] e:es m = m
evalAttr v:vs [] m = m
evalAttr v:vs e:es m = update v (evalExp e m) (evalAttr vs es m)
evalAttr v:vs e:es m = evalAttr vs es (update v (evalExp e m) m )

evalCmd (CmdAsg vs es) m = evalAttr(vs es m)
```

## Parte 2

No interpretador "Imperative Language CPS" [2](http://www.inf.puc-rio.br/~roberto/sem/imper-cont.hs.html), acrescente um comando
"repeat-until", que repete um bloco de código até uma condição ser
verdadeira. O teste no "repeat-until" é feito no final, logo o bloco
é sempre executado ao menos uma vez.

```haskell
data Cmd = -- ...
         | CmdRepeat Exp Cmd    -- linha 80

evalCmd (CmdRepeat e c) m k = evalCmd(CmdSeq c (CmdWhile (ExpNot e) c)) m k  -- linha 92



```
