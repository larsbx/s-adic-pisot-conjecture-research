# Dimension-five Brun: an induced obstruction and an average-contraction target

**Status:**
- Lemma R5's matrix and first-return facts: finite-domain theorem.
- Corollary R5 and Lemma I: repository-proved implications.
- Candidate I5: open; no negative drift certificate has been obtained.
- The Brun Pisot condition remains open. No novelty claim is made.

Based on main `b921eea` (including PR #11), not just PR #10. This note
continues the induced-system question in `brun-pisot-condition.md` §5.
All spectral computations below are exact; there are no orbit averages here.

## 1. A first-return negative control on the natural Pisot cylinder

Use the unordered labels of BST23 (6.9)–(6.10). Let

`v = β₁₂ β₂₃ β₃₁ β₁₄ β₄₅ β₅₁`,

the pinned Pisot witness of Theorem C, and let

`w = β₁₂ β₂₁ β₁₃ β₃₄ β₄₅ β₅₄ β₄₃ β₃₁`,

the third expanding witness of Lemma N. Set `u = v w³`, of length 30,
and let `Y = [v]` in the faithful unordered Brun realization.

**Lemma R5 (finite-domain).** The periodic word `u^∞` is admissible. Its
period contains exactly one cyclic occurrence of `v`, so its point in `Y`
has first return time 30. Its incidence matrix is strictly positive and is

| | 1 | 2 | 3 | 4 | 5 |
|---|---:|---:|---:|---:|---:|
| 1 | 6836 | 604 | 5678 | 4061 | 2116 |
| 2 | 3961 | 350 | 3290 | 2353 | 1226 |
| 3 | 3345 | 295 | 2779 | 1988 | 1036 |
| 4 | 1693 | 149 | 1407 | 1007 | 525 |
| 5 | 1357 | 120 | 1127 | 806 | 420 |

Its characteristic polynomial is

`f(z) = z⁵ − 11392z⁴ + 17345z³ − 2558z² + 77z − 1`.

It is irreducible modulo 5, hence over the rationals. Exactly three roots
lie in the open unit disc, and two lie outside the closed unit disc.
The composite is in the mirror Barge class.

*Proof and certificate.* Both connectors are admissible: the last labels
of `v` and `w` have second letter 1, and each first label has first letter
1. Internal admissibility is checked too. The symbol `β₂₃` occurs only once
per period, at the second position of `v`; any occurrence of `v` must use
that symbol in that position. There is therefore exactly one occurrence.
The matrix, positivity, characteristic polynomial, modulo-5 irreducibility,
and open-disc root count are decided by the existing exact primitives in
both `test_brun_five_pisot_cylinder_expanding_return` regressions. The odd
degree irreducibility argument in Lemma N excludes unit-circle roots.
Theorem B gives the letter structure, also checked by the regressions.
The matrix facts are added to the cross-language vector battery. ∎

**Corollary R5 (repository-proved).** The first-return cocycle on this
specific `Y` admits no family of finite norms making every return branch
nonexpanding at every point of `Y`.

*Proof.* At the periodic point above, the return map fixes the base point.
The transverse return operator has the spectrum of the incidence matrix
with its Perron eigenvalue removed (Lemma N's argument). Its spectral
radius is greater than one. A return operator of norm at most one would
have spectral radius at most one, a contradiction. A finite-state adapted
norm returns to the same state here, so it cannot remove this obstruction.
In particular uniform strict contraction on all return branches fails. ∎

This is a statement about `Y = [v]`, not every inducing set. It does not
refute an almost-everywhere negative exponent or an average-contraction
criterion. No connector/non-degeneracy theorem for arbitrary cylinders is
asserted. Theorem B alone cannot imply transverse contraction: both `v`
and `u` satisfy its letter conclusion, with different spectral verdicts.

## 2. A criterion allowing expanding return branches

Let `D` be the transverse cocycle of BST21-3.4, in its fixed coordinate
chart. Let `N(x)` be invertible with
`‖N(x)‖, ‖N(x)⁻¹‖ ≤ K` uniformly, for some `K ≥ 1`.
For a returning point write `s₀ = 0`, `sⱼ₊₁ = sⱼ + τⱼ`, and define

`Bⱼ = N(T^{sⱼ₊₁}x) D^{(τⱼ)}(T^{sⱼ}x) N(T^{sⱼ}x)⁻¹`.

**Lemma I (repository-proved, pathwise implication).** Suppose along this
orbit:

1. `‖D(T^t x)‖ ≤ exp(L)` for every `t`, with a fixed finite `L ≥ 0`;
2. `sⱼ/j → m`, where `1 ≤ m < ∞`;
3. real budgets `bⱼ` satisfy `log‖Bⱼ‖ ≤ bⱼ` and
   `limsup (1/j) Σ_{i<j} bᵢ ≤ −δ` for a fixed `δ > 0`.

Then `limsup_{t→∞} (1/t) log‖D^{(t)}(x)‖ ≤ −δ/m < 0`.

*Proof.* Telescoping the changes of norm and using submultiplicativity gives
`log‖D^{(sⱼ)}(x)‖ ≤ 2 log K + Σ_{i<j} bᵢ`. Divide by `sⱼ` and use (2)–(3).
Furthermore (2) implies `τⱼ/j → 0`: subtract the convergent expressions
`sⱼ₊₁/(j+1)` and `sⱼ/j`, with their respective prefactors. Hence
`τⱼ/sⱼ → 0`. For `sⱼ ≤ t < sⱼ₊₁`, the unfinished suffix adds at most
`L(t − sⱼ) ≤ Lτⱼ`, which is negligible after division by `t`.
This proves the full-time bound, not just a return-subsequence bound. ∎

The lemma uses no induced Lyapunov scaling theorem. For an a.e. Brun
conclusion its hypotheses must hold a.e.; return recurrence, a finite mean,
and convergence of budget averages cannot be replaced by one sampled orbit.
BST21-3.4 then identifies this transverse top exponent with `λ₂`.
Any use of ergodic/Kac theorems to establish the hypotheses requires its own
explicit literature gate; no such new import is made here.

## 3. Candidate I5: five norm states and a signed return budget

The following is a precise **open candidate**, not a certificate:

- Induce on `Y = [v]`.
- Use norm states `c = v a` of depth 7. There are five allowed `a` after
  `β₅₁`: `β₅₁`, or `β₁j` for `j ∈ {2,3,4,5}`.
- Choose one rational positive-definite 4×4 quadratic form `Q_c` per state
  for the coordinates of `D`; take its square-root norm. Outside `Y` extend
  by one fixed norm. A finite set of positive-definite forms has uniform
  comparison constants, so the change of norm is bounded. Cholesky factors
  need not be rational; certify norm inequalities using rational forms.
- Construct at most 256 disjoint return cells `P_i`, with rational upper
  log-norm budgets `b_i`, and a structural bound on the entire omitted
  return tail. The cell count is a practical search target, not a theorem.

On each cell the return time and both norm indices must be fixed. For
return time `r`, partition through **`r+7` symbols**, including tests that
no earlier return to `[v]` occurs. A depth-`r` partition is insufficient.
For a rational bound `q_i > 0`, on a fixed-state cell with affine return
matrix `D_r(x)`, it suffices to certify at every vertex `z` the rational
matrix inequality
`D_r(z)^T Q_out D_r(z) ≤ q_i² Q_in`. Indeed, write an interior matrix as
the convex combination of its vertex matrices; the triangle inequality in
the output norm bounds its operator norm by the largest vertex bound.
Positive semidefiniteness of each rational difference matrix is an exact
finite obligation. Also certify `log q_i ≤ b_i`; the spectral roots or
Cholesky factors need not be approximated. This supplies a finite
description of the *local* norm inequalities; it supplies no tail estimate
or negative average. No positive-cone projective contraction is identified
with transverse contraction.

Here is the exact sign test the candidate must discharge. Work with any
positive unnormalised invariant measure `ν` on `Y`. Let `E` be the omitted
set, and provide rational bounds

`l_i ≤ ν(P_i) ≤ h_i`, `ν(E) ≤ U₀`, `∫_E τ dν ≤ U₁`.

Provide nonnegative rational `a ≥ log K`, `L ≥ log 2`, with a certified
base-coordinate bound `log‖D‖ ≤ log 2` as used in the existing Brun note.
The fallback on `E` is `log‖B‖ ≤ 2a + Lτ`. Thus the fully rational condition

`S = Σ_{b_i<0} b_i l_i + Σ_{b_i≥0} b_i h_i + 2a U₀ + L U₁ < 0`

implies a negative integrated return budget. Also require `ν(Y)>0`, finite
mean return time, and a.e. convergence of its time/budget averages to the
corresponding normalised integrals. These are separate hypotheses, not
outputs of the sign test. Under them Lemma I and BST21-3.4 give `λ₂<0`.

The test is falsifiable: a failed form inequality, inconsistent norm
indices, uncovered returns, or an unbounded/unproved `U₁` rejects the
certificate. `S ≥ 0` means this candidate certificate is inconclusive.
Lemma R5 forces an expanding return to receive a positive budget or to
enter the charged tail; declaring all branches contracting fails exactly.
Failure of a bounded search is not a refutation of every adapted norm.

## 4. Where Lemma D helps, and the remaining obligation

Lemma D can bound `ν(P_i)` by integrating rational density brackets over
certified rational subcells in the ordered chart. For unordered cylinders,
first split into coordinate-order chambers and account for the chart and
its Jacobian; ordered density is not assigned directly to symbolic word
counts. Componentwise brackets away from `x₁=0` give rational bounds when
combined with exact volumes. Use lower masses for negative budgets and
upper masses for positive budgets. A common unknown normalisation cancels
from the sign test.

Near the singular vertex, the bound `ρ ≤ 6/x₁` for `d=5` requires an actual
integral or geometric tail argument. A pointwise infinite supremum there
is not a finite mass bound. Most importantly a small omitted mass `U₀`
does not bound its return-time moment `U₁`. For example, the two-point
probability distribution `P(τ=M²)=1/M`, `P(τ=1)=1−1/M` has long-return mass
`1/M` but moment contribution `M`. This is a logical negative control,
not a proposed Brun distribution.

The next load-bearing structural obligation is therefore a return-time
moment bound for `[v]`, coupled to a finite norm budget with negative sign.
No such bound or sign certificate is established here. Acceleration alone
does not remove it. The existing claim that *any* finite norm description
must encode exponentially many cylinders is not a proved description-size
lower bound; a compressed algebraic description remains possible.

## 5. Validation and boundaries

The new finite certificate uses existing exact matrix, polynomial,
primitivity and letter-map primitives; no new mathematical kernel algorithm
or numerical estimator is introduced. Python and Mojo regressions test
cyclic first return, positivity, the polynomial, irreducibility, disc count,
non-Pisot verdict and mirror Barge membership. The vector battery checks
the independent spectral implementations against each other.

Local validation for this contribution: all 68 Python tests passed;
vendoring, claim governance and declared coverage passed. The Mojo suite
could not start because Pixi failed to fetch
`fsspec-2026.7.0-pyhd8ed1ab_0.conda` from the configured conda-forge endpoint
(connection/tunnel failure). Therefore neither the new Mojo regression nor
the cross-language vector comparison is reported as passed. Declared
coverage alone is not a successful-run receipt. CI remains an integration
obligation.

Lemma I is a written proof, not an executable claim or a formal Lean proof.
Candidate I5's five forms, return cells, tail bounds and negative sign
remain unconstructed. The Pisot condition and conditional status of
Theorems C/C′ remain unchanged.
