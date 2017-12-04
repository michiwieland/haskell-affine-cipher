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