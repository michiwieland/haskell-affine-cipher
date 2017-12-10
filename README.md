# Affine Cipher in Haskell
The affine cipher is a substitution cipher, similar to the Caesar cipher.
Each letter is encrypted with the function (a * x + b) mod 26, where b is the magnitude of the shift.

## Variables
```
Private key pair: (a,b)
Numeric value of the plaintext char: x
Numeric value of the encrypted char: y
Alphabet size / modulo: m
```

## Input constraints
- a < b
- a must be co-prime to m
- a and b must be within [0 ... (m-1)]

## Number ranges
- a: [1,3,5,7,9,11,15,17,19,21,23,25] = 12 elements
- b: [0 - 25] = 26 elements
- possible key value pairs using the latin lowercase alphabet: 12 * 26 - 1 = 311

## Encrypt
* `((a * x) + b) mod m`
* `decode a b 'text'`

## Decrypt
* `((a^-1 * (y - b) mod m`
* `encode a b 'text'`

## How to crack
This code uses quadgram statistics to crack an encrypted text. 

1. First a reference text is used to determine the quadgram distribution in english text.
2. Then the ciphertext is deciphered with all possible key combinations => 311 possible combinations
3. The likelihood of each deciphered quadgram is looked up in the reference text. 
4. To determine the fitness of a deciphered text, all log likelihoods are sumed up.
5. The higher the fitness number the more likely the particular keys are correct. Therefore both texts have a similar distribution of characters.

### Usage
* generate blind text with [BLINDTEXTGENERATOR](http://www.blindtextgenerator.com)
* `crack 'text_to_crack' 'blind_text'`
