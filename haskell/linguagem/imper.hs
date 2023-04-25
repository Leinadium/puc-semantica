-----------------------------                                             -- 001
-- Simple Imperative Language                                             -- 002
-----------------------------                                             -- 003
                                                                          -- 004
                                                                          -- 005
-- variables are just names                                               -- 006
type Var = String                                                         -- 007
                                                                          -- 008
-- values are always integers (for now)                                   -- 009
type Value = Integer                                                      -- 010
                                                                          -- 011
-- a Memory maps variables to Values                                      -- 012
type Mem = Var -> Value                                                   -- 013
                                                                          -- 014
                                                                          -- 015
-- auxiliary function to map Values to Booleans                           -- 016
isTrue :: Value -> Bool                                                   -- 017
isTrue i = (i /= 0)                                                       -- 018
                                                                          -- 019
                                                                          -- 020
-- An empty memory                                                        -- 021
emptyMem :: Mem                                                           -- 022
emptyMem v = error ("invalid access to variable '" ++ v ++ "'")           -- 023
                                                                          -- 024
-- update the value of a variable in a memory                             -- 025
update :: Var -> Value -> Mem -> Mem                                      -- 026
update var val m = \v -> if v == var then val else m v                    -- 027
                                                                          -- 028
                                                                          -- 029
--------------------------------------------------------------------      -- 030
-- Abstract Syntax Tree for Expressions                                   -- 031
data Exp = ExpN Integer          -- constants                             -- 032
         | ExpVar Var            -- variables                             -- 033
         | ExpAdd Exp Exp        -- e1 + e2                               -- 034
         | ExpSub Exp Exp        -- e1 - e2                               -- 035
         | ExpMul Exp Exp        -- e1 * e2                               -- 036
         | ExpDiv Exp Exp        -- e1 / e2                               -- 037
         | ExpNeg Exp            -- -e                                    -- 038
                                                                          -- 039
                                                                          -- 040
-- Evaluates an expression in a given memory                              -- 041
evalExp :: Exp -> Mem -> Value                                            -- 042
                                                                          -- 043
evalExp (ExpN i) m = i                                                    -- 044
evalExp (ExpVar v) m = m v                                                -- 045
evalExp (ExpAdd e1 e2) m = (evalExp e1 m) + (evalExp e2 m)                -- 046
evalExp (ExpSub e1 e2) m = (evalExp e1 m) - (evalExp e2 m)                -- 047
evalExp (ExpMul e1 e2) m = (evalExp e1 m) * (evalExp e2 m)                -- 048
evalExp (ExpDiv e1 e2) m = (evalExp e1 m)  `div` (evalExp e2 m)           -- 049
evalExp (ExpNeg e) m = -(evalExp e m)                                     -- 050
                                                                          -- 051
                                                                          -- 052
----------------------------------------------------------------------    -- 053
-- Abstract Syntax Tree for Statements (commands)                         -- 054
data Cmd = CmdAsg Var Exp            -- assignment (var = exp)            -- 055
         | CmdIf Exp Cmd Cmd         -- if exp then c1 else c2            -- 056
         | CmdSeq Cmd Cmd            -- c1; c2                            -- 057
         | CmdWhile Exp Cmd          -- while e do c                      -- 058
         | CmdSkip                   -- do nothing                        -- 059
                                                                          -- 060
evalCmd :: Cmd -> Mem -> Mem                                              -- 061
                                                                          -- 062
evalCmd (CmdSkip) m = m                                                   -- 063
evalCmd (CmdSeq c1 c2) m = evalCmd c2 (evalCmd c1 m)                      -- 064
evalCmd (CmdIf e ct ce) m =                                               -- 065
  if isTrue(evalExp e m)                                                  -- 066
    then (evalCmd ct m) else (evalCmd ce m)                               -- 067
evalCmd (CmdAsg v e) m = update v (evalExp e m) m                         -- 068
                                                                          -- 069
evalCmd (CmdWhile e c) m = w m                                            -- 070
  where w = \m -> (if isTrue(evalExp e m) then w (evalCmd c m) else m)    -- 071
                                                                          -- 072
                                                                          -- 073
-------------------------------------------------------------------       -- 074
-------------------------------------------------------------------       -- 075
-- example                                                                -- 076
                                                                          -- 077
-- x = 10; r = 1; while x do r = r * x; x = x - 1 end; result = r         -- 078
cmd1 = let x = ExpVar "x"                                                 -- 079
           r = ExpVar "r" in                                              -- 080
  CmdSeq                                                                  -- 081
    (CmdSeq                                                               -- 082
      (CmdSeq (CmdAsg "x" (ExpN 10))                                      -- 083
              (CmdAsg "r" (ExpN 1)))                                      -- 084
      (CmdWhile (ExpVar "x")                                              -- 085
                (CmdSeq (CmdAsg "r" (ExpMul r x))                         -- 086
                        (CmdAsg "x" (ExpSub x (ExpN 1))))))               -- 087
    (CmdAsg "result" r)                                                   -- 088


cmd2 = CmdSeq 
    (CmdAsg "result" (ExpN 27))
    (CmdWhile (ExpN 1) CmdSkip)
                                                                          -- 089
-------------------------------------------------------------------       -- 090
-- code to show the final value of "result" after running "cmd1" on       -- 091
-- an initially empty memory                                              -- 092
                                                                          -- 093
finalMem = evalCmd cmd2 emptyMem                                          -- 094
                                                                          -- 095
main = print (finalMem "result")                                          -- 096
                                                                          -- 097