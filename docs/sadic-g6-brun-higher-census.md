# Brun periodic points in every dimension

**Status:**
- Theorem B and Corollary B′: repository-proved. B′ rests on the imported
  Barge 2016 Theorem 3.13 and a reversal lemma proved here.
- Theorem C: conditional theorem. Its only open hypothesis is the Pisot
  condition for Brun with `d = 5` or `d = 6`.
- §4: census evidence for `d = 5, 6`.

Nothing here proves the Pisot condition, nor the S-adic Pisot conjecture for
any algorithm.

Notation: `brun_unordered(d)`, the unordered Brun family of BST23 (6.9),
`β_{i,j}: j ↦ ij, k ↦ k`, with admissibility (6.10): `β_{i,j}` is followed by
itself or by some `β_{j,k}`.

## 1. Theorem B (Brun composites are in the mirror Barge class)

**Theorem B.** Let `w = (p₁,q₁) … (pₙ,qₙ)` be an admissible word of labels
`β_{p_t,q_t}` in dimension `d`, and let `σ_w = β_{p₁,q₁} ∘ … ∘ β_{pₙ,qₙ}`.
1. The last letter of `σ_w(a)` is `a` for every letter `a`.
2. If every letter occurs among the `p_t, q_t`, then every image `σ_w(a)`
   begins with `p₁`.
3. If `σ_w` is primitive, every letter occurs.

So every primitive Brun composite is constant on initial letters and
injective on final letters.

*Proof.*
1. `β_{p,q}` sends each letter `a` to a word ending in `a`. The last letter
   of `σ(τ(a))` is the last letter of `σ(last letter of τ(a))`, so the
   final-letter map of a composite is the composite of identities.
2. The initial-letter map of `β_{p,q}` is the collapse `c_{q→p}`: it sends
   `q` to `p` and fixes every other letter. So the initial-letter map of `σ_w`
   is `f = c_{q₁→p₁} ∘ … ∘ c_{qₙ→pₙ}`, and the collapse `c_{qₙ→pₙ}` acts first.
   Admissibility gives `p_{t+1} = q_t` wherever the label changes. Follow a
   letter `x` from the right:
   - While it is fixed, it stays `x`.
   - At the first collapse that moves it, it becomes some `p_t`.
   - From then on it equals the current `p`. Each later collapse either
     repeats the label or has `q_{s} = p_{s+1}`, which is the current value,
     and maps it to `p_s`.
   - If `x = p_t` is never moved before index `t`, the first change of label
     to the left of `t` collapses it in the same way. If there is no such
     change, `x = p₁` already.

   In every case a letter that occurs ends at `p₁`.
3. A letter that occurs in no label is fixed by every `β` and appears in no
   image of another letter, so its row of `M_w` is a unit vector. ∎

Theorem B is checked exhaustively on every admissible periodic word with
`d = 3` (period ≤ 7), `d = 4` (≤ 6) and `d = 5` (≤ 5), in both languages
(`test_theorem_b`).

**Novelty boundary.** Barge 2016 §4.2 makes the same observation for the
3-letter ordered Brun substitutions of [BBJS] and for Arnoux–Rauzy. The
unordered `d`-letter family needs the admissibility argument above. No
novelty claim is made.

## 2. Corollary B′ (pure discrete spectrum for every Pisot periodic point)

**Lemma Rev (reversal).** Let `σ̃(a)` be the reversal of `σ(a)`. Then
`σ` and `σ̃` have the same incidence matrix. The tiling space `Ω_σ̃` is the
image of `Ω_σ` under the reflection `T ↦ −T`, which conjugates the
translation action at time `t` to the action at time `−t`. The eigenvalues
of the two flows are therefore negatives of each other, so one has pure
discrete spectrum iff the other does.

*Proof.* The map is a homeomorphism `Ω_σ → Ω_σ̃` that intertwines `T − t`
with `T̃ + t`, because the reflected tiling of `σ(a)` reads `σ̃(a)` from left
to right. A function `f` satisfies `f(T − t) = e^{2πiαt} f(T)` iff its
reflection is an eigenfunction with eigenvalue `−α`. The `L²` spans of
eigenfunctions correspond. ∎

**Corollary B′.** In every dimension `d`, if `σ_w` is the composite of a
primitive admissible Brun word and its inflation is a Pisot number, then the
tiling flow `(Ω_{σ_w}, R)` has pure discrete spectrum.

*Proof.* By Theorem B, `σ̃_w` is injective on initial letters and constant on
final letters, and it is primitive with the same Pisot inflation. Barge 2016
Theorem 3.13 gives pure discrete spectrum for `(Ω_{σ̃_w}, R)`, and Lemma Rev
transfers it to `σ_w`. ∎

This covers every Pisot composite the census caps, including the `d = 5, 6`
ones whose balanced-pair graphs exceed every budget tried.

## 3. Theorem C (Brun `d = 5, 6`: only the Pisot condition is missing)

**Theorem C (conditional).** Let `d ∈ {5, 6}` and suppose the unordered Brun
algorithm `(Δ, T_B, A_B, ν_B)` in dimension `d` satisfies the Pisot
condition. Then for `ν_B`-a.e. `x`, the S-adic system `(X_{φ_B(x)}, Σ)` is a
bounded natural coding of a minimal translation on `T^{d−1}`. In particular it has pure discrete
spectrum.

*Proof.* Apply BST23 Theorem 3.1. Its hypotheses other than the Pisot
condition are:
1. **Positive.** The matrices `ᵗM_{β_{i,j}}` are non-negative and unimodular.
2. **`ν_B ∘ T_B ≪ ν_B`, faithful substitutive realization `φ_B`, positive
   range of every point.** BST23 §6.5 states all three for the unordered
   Brun algorithm in arbitrary dimension `d ≥ 3`, before it specializes to
   `d = 4`. They are verified in the arXiv text.
3. **A periodic Pisot point with pure discrete spectrum.**
   - Take `w = (0,5,8,2,15,16)`, that is `β₁₂β₂₃β₃₁β₁₄β₄₅β₅₁`, for `d = 5`;
     and `w = (0,6,10,2,16,8,24,25)`, that is `β₁₂β₂₃β₃₁β₁₄β₄₂β₂₅β₅₆β₆₁`,
     for `d = 6`. Let `x₀` be the dominant right eigenvector of `M_w`.
   - As in BST23's argument for `τ` in §6.5, `φ_B(x₀) = w^∞` is admissible.
   - `M_w` is a Pisot matrix: irreducible and Pisot, certified by the
     kernel.
   - The balanced pair algorithm terminates on `σ_w`
     (`test_brun_five_periodic_point` and `test_brun_six_periodic_point`, in
     Mojo and Python).
   - BST23 Proposition 6.1 then gives pure discrete spectrum of the
     *symbolic* system.

Every hypothesis except the Pisot condition is therefore met. ∎

The Pisot condition for Brun `d = 5, 6` has numerical support only (BST21).
For `7 ≤ d ≤ 10` the same argument needs a periodic point on which the
balanced pair algorithm terminates. Corollary B′ gives the flow version for every Pisot
point, but the transfer to the symbolic system (Barge 2016 Remark 4.2,
citing Clark–Sadun) has not been verified here.

## 4. Census evidence (`kernel/brun_census.mojo … orbits`)

The census counts one word per orbit under rotation and letter permutation,
weighted by orbit size. A relabelling permutes the family and conjugates the
composite, so every verdict is an orbit invariant. On `d = 4` the weighted
orbit census reproduces the full census exactly.

**`d = 5`, BPA budgets 2,000,000 states and length 200,000:**

| period | words | orbits | not primitive | reducible `χ` | not Pisot | PIP | BPA terminates | BPA capped | in mirror Barge class |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ≤ 5 | 844 | 20 | 820 | 24 | 0 | 0 | 0 | 0 | 0 |
| 6 | 2,580 | 38 | 2,280 | 0 | 0 | 300 | 60 | 240 | 300 |
| 7 | 11,160 | 122 | 8,760 | 240 | 0 | 2,160 | 1,800 | 360 | 2,160 |
| 8 | 48,750 | 496 | 33,000 | 840 | 300 | 14,610 | 12,390 | 2,220 | 14,610 |

**`d = 6`, BPA budgets 200,000 states and length 20,000:**

| period | words | orbits | not primitive | reducible `χ` | not Pisot | PIP | BPA terminates | BPA capped | in mirror Barge class |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| ≤ 5 | 1,984 | 20 | 1,984 | 0 | 0 | 0 | 0 | 0 | 0 |
| 6 | 7,735 | 39 | 7,615 | 0 | 120 | 0 | 0 | 0 | 0 |
| 7 | 39,990 | 125 | 37,830 | 0 | 1,440 | 720 | 0 | 720 | 720 |
| 8 | 209,790 | 532 | 185,850 | 1,800 | 14,400 | 7,740 | 1,440 | 6,300 | 7,740 |

Observations:
- No balanced-pair run **fails**. Every capped run hits the **length**
  budget, not the state budget: all 24 capped `d = 5` orbits and all 11
  capped `d = 6` orbits were re-run and report the length budget. One `d = 5` period-6 composite reaches a
  reachable irreducible pair of length 112,328 with only 423 states.
- The capped composites have a second root of modulus about 0.89–0.94
  (numerical, for illustration only). Weak contraction makes the
  balanced-pair graph very large, which fits Corollary B′: their flows have
  pure discrete spectrum.
- Irreducibility is never inconclusive. The `d = 5` period-5 polynomial
  `(z² − z + 1)(z³ − 5z² + 4z − 1)` is refuted by the factor search; no prime
  certificate exists for it.
