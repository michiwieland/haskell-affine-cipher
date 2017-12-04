import Data.Char
import Data.Maybe

let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

shift :: Char -> Int -> Int -> Char
shift c a b | isLetter c = int2let ((let2int c * a + b) `mod` 26)
            | otherwise = c

isCoprime :: Int -> Int -> Bool
isCoprime a b = gcd a b == 1

valid_param :: Int -> Bool
valid_param a = isCoprime a 26

encode :: Int -> Int -> String -> Maybe String
encode a b xs | valid_param a = Just [shift x a b | x <- xs]
              | otherwise = Nothing

mod_inverse :: Int -> Int -> Maybe Int
mod_inverse a m | isCoprime a m = Just ([x | x <- [1..m], (a*x `mod` m) == 1] !! 0)
                | otherwise = Nothing

shift_back :: Char -> Int -> Int -> Maybe Char
shift_back c a b | not (valid_param a) = Nothing
                 | isLetter c = Just (int2let (inv * (let2int c - b) `mod` 26))
                 | otherwise = Just c
                 where inv = fromJust (mod_inverse a 26)

decode :: Int -> Int -> String -> Maybe String
decode a b xs | not (valid_param a) = Nothing
              | otherwise = Just (map fromJust [shift_back x a b | x <- xs])