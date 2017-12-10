import Data.Char
import Data.Maybe
import Data.List

let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

-- ENCODE
shift :: Char -> Int -> Int -> Char
shift c a b | isLetter c = int2let ((x * a + b) `mod` 26)
            | otherwise = c
            where x = let2int c

-- two integers a and b are relatively prime or coprime if their greatest common divisor is one
isCoprime :: Int -> Int -> Bool
isCoprime a b = gcd a b == 1

valid_param :: Int -> Bool
valid_param a = isCoprime a 26

encode :: Int -> Int -> String -> Maybe String
encode a b xs | valid_param a = Just [shift x a b | x <- xs]
              | otherwise = Nothing

-- DECODE
mod_inverse :: Int -> Int -> Maybe Int
mod_inverse a m | isCoprime a m = Just ([x | x <- [1..m], (a * x `mod` m) == 1] !! 0)
                | otherwise = Nothing

shift_back :: Char -> Int -> Int -> Maybe Char
shift_back c a b | not (valid_param a) = Nothing
                 | isLetter c = Just (int2let (inv * (y - b) `mod` 26))
                 | otherwise = Just c
                 where inv = fromJust (mod_inverse a 26)
                       y = let2int c

decode :: Int -> Int -> String -> Maybe String
decode a b xs | not (valid_param a) = Nothing
              | otherwise = Just (map fromJust [shift_back x a b | x <- xs])

-- CRACK
quadgram :: [Char] -> [[Char]]
quadgram s = [take 4 (drop (i*1) str) | i <- [0..l]]
             where str = map toLower (filter isLetter s)
                   l = length str - 4

count :: Eq a => a -> [a] -> Int
count x = length . filter (==x)

rmdups :: Eq a => [a] -> [a]
rmdups [] = []
rmdups (x:xs) = x : filter (/= x) (rmdups xs)

freq :: Eq a => [a] -> [(a, Int)]
freq vs = [(v, count v vs) | v <- rmdups vs]

divFloat :: Int -> Int -> Float
divFloat a b = (fromIntegral a) / (fromIntegral b)

-- single probability of a quadgram = count(quadgram) divided by the total number of quadgrams in the training sample
prob :: [(a, Int)] -> [(a, Float)]
prob vs = [(a, divFloat f l) | (a, f) <- vs]
          where l = sum [f | (_, f) <- vs]

ln :: (Floating a, Eq a) => a -> a
ln 0 = fromIntegral 0
ln a = log a

-- fitness is equal to the sum of all quadgram probabilities
fitness :: String -> String -> Float
fitness s refText = sum [ln (fromMaybe 0 (lookup qd probabilities)) | qd <- quadgram s]
            where probabilities = prob(freq (quadgram refText))

-- bruteforce all combinations of private key pairs and take the combination with the highest fitness
crack :: String -> String -> String
crack s refText = fromJust (decode a b s)
                  where a = fst result
                        b = snd result
                        result = snd (ordered_fits !! 0)
                        ordered_fits = sort [(f, p) | (f, p) <- fits, f /= 0.0]
                        fits = [((fitness (fromJust (decode a b s)) refText), (a, b)) | a <- [1,3,5,7,9,11,15,17,19,21,23,25], b <- [0..25]]
