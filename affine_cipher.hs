import Data.Char

let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

shift :: Char -> Int -> Int -> Char
shift c a b | isLower c = int2let ((let2int c * a + b) `mod` 26)
            | otherwise = c

encode :: Int -> Int -> String -> String
encode a b xs = [shift x a b | x <- xs]

mod_inverse :: Int -> Int -> Int
mod_inverse a m = [x | x <- [1..m], (a*x `mod` m) == 1] !! 0

shift_back :: Char -> Int -> Int -> Char
shift_back c a b | isLower c = int2let ((mod_inverse a 26) * (let2int c - b) `mod` 26)
                 | otherwise = c

decode :: Int -> Int -> String -> String
decode a b xs = [shift_back x a b | x <- xs]