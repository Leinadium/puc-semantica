# Escapes

Continuações como valor de primeira ordem

## `setjmp` / `longjmp`

Comandos no C

```c
jmp_buf b;

if (int v = setjmp(b) == 0) {
    // ...
    // ...
    longjmp(b, 1)  // -> faz o setjmp retornar com o valor 1, pula pro else
    
} else {
    // ...
}
```

## call-with-current-continuation

Da linguagem `scheme/lisp`, também chamado de `call/cc`

Se não usar o `ret`, `call/cc` retorna com o valor da funcao normalmente.
Se usar `ret(x)`, `call/cc` retorna com o valor x, terminando a função. 

```scheme
call/cc (function (ret)
         ...
         ...
         ret(123)
         ...

         end)
```

E se acontecer algo como

```scheme
local X
call/cc (function (ret)
         ...
         ...
         X = ret
         ...
         return 10
         end)
...
X(27)       ???
```

`call/cc` vai retornar novamente com o valor 27, no contexto do retorno de `call/cc`.


```scheme
function getK ()
    return call_cc(function (ret)
                      ret(ret)
                   end)
end

...

local k = getK()
...
...
..
k(10)
```