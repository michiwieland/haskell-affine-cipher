# Affine Cipher in Haskell

## Constraints
```
Numeric value of the plaintext char: x
Numeric value of the encrypted char: y
Private key pair: (a,b)
Alphabet size: k
Constraint: a < b
```

## Encrypt
* `((a * x) + b) mod k`
* `decode a b text`

## Decrypt
* `((a^-1 * (y - b) mod k`
* `encode a b text`

## Crack
* generate blind text with [BLINDTEXTGENERATOR](http://www.blindtextgenerator.com)
* `crack text_to_crack blind_text`
