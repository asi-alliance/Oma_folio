; DOMAIN: coding-theory [CLOSED, derived 2026-07-24]
; Claim: a source of entropy H can be losslessly encoded at average rate arbitrarily close to H bits/symbol, and no lower (Shannon source coding).
; Structure: (source S (symbols p_i)) (entropy H = -sum p_i log p_i) (prefix-code C lengths l_i).
; Result: H <= min E[l] < H+1; block-coding pushes rate -> H. Kraft inequality bounds prefix codes.
; Minimal: entropy = tight lower bound on expected codeword length; achievable by Huffman/arithmetic coding.
; Bridge: quantifies belief-entropy (belief-entropy artifact) as the compression limit; skewed source (lower H) compresses better.
(= (min-rate (encode $S)) (entropy $S))