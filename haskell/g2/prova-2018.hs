-- questão 1
type K a = a -> Result

type Cmpt a = Mem -> (Value, Mem)

-- questão 2
unit :: a -> Cmpt a
unit x -> 