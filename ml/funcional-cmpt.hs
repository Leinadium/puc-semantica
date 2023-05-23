type Cmpt a = Mem -> (a -> Mem)

unit :: a -> Cmpt a
unit x = \m -> (x, m)

bind :: Cmpt a -> (a -> Cmpt b) -> Cmpt -> b
bind ca f = \m -> let (x, m') = ca m in
    (f x) m'


eval (ExpApp e1 e2) env = 
    bind (eval e1 env) (\v1 -> 
        bind (eval e2 env) (\v2 -> 
            case v1 of
                ValFunc f = f v2))