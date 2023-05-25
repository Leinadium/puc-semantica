# I/O em Haskell

Como ter efeitos colaterais em uma linguagem funcional pura?

**Fantasia**:

```haskell
type IO a = (input, output) -> (a, input, output)   -- monada
```

**Real:**

```haskell
main :: IO ()   -- () :: () [funcao void: () é um tipo de funcao sem argumentos]


return :: a -> M a      -- o unit real do haskell
( >>= )                 -- o bind real do haskell

-- putChar e putString
putChar :: Char -> IO()

putString :: String -> IO()
putString [] = return ()
putString (x:xs) = putChar x >>= (\_ -> putString xs)

-- getChar e getString
getChat :: IO Char
getLine :: IO String
getLine = getChar >>= 
    (\c -> if c == '\n' then return "" 
        else getLine >>= (\cs -> return (c:cs)))

(>>) io1 io2 = io1 >> = (\_ -> io2)     -- bind jogando fora o valor do io1
-- usando no putString
putString (x:xs) = putChar x >> putString xs

-- (do) = encadeia funcoes usando >>
-- (<-) = bind com a funcao sendo o corpo
-- usando no getLine
getLine = do
    c <- getChar
    if c == \n' then return ''
        else do cs <- getLine
            return (c:cs)
```