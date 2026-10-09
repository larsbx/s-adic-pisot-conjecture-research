# G2 completion: spectral certificates, periodic points, the ι embedding

**Status:** kernel specification with proofs and the claims it guards; statuses
as in `claim_governance.toml` and `CLAIMS.md`.

Canonical: `kernel/sadic/{spectrum,periodic}.mojo`. Oracle:
`reference/sadic_reference/{spectrum,periodic,bpa}.py`, which uses different
algorithms (§4). Regressions: `kernel/tests/test_sadic_spectrum.mojo` and
`tests/test_sadic_spectrum.py`. Cross-check: `kernel/vectors.mojo` together
with `tools/cross_check.py`.

Polynomials are monic integer coefficient lists, lowest degree first. Every
verdict has three values: certified (1), certified negative (0), or
inconclusive (−1). Any overflow raises and counts as inconclusive (rule R3).

## 1. Unit-disc count and the Pisot verdict

**Schur–Cohn step.** Let `p` have degree `n` with `p(0) = a₀ ≠ 0`, and put
`p*(z) = zⁿ p(1/z)` and `Tp = a₀ p − aₙ p*`, a polynomial of degree `< n`. Write
`Z(·)` for the number of zeros in the open unit disc.

**Lemma SC.** Suppose `p` has no zero on the unit circle and
`γ = a₀² − aₙ² ≠ 0`.
- If `γ > 0`, then `Z(p) = Z(Tp)`.
- If `γ < 0`, then `Z(p) = n − Z(Tp)`.

*Proof.* On `|z| = 1` we have `|p*(z)| = |p(z)|`.
- If `|a₀| > |aₙ|`, then `|aₙ p*| < |a₀ p|` on the circle, so Rouché gives
  `Z(Tp) = Z(p)`.
- If `|aₙ| > |a₀|`, the same argument gives `Z(Tp) = Z(p*)`. The zeros of `p*`
  are the `1/α` for the zeros `α` of `p` (with `a₀ ≠ 0`), so `Z(p*) = n − Z(p)`. ∎

**Degenerate step.** If `γ = 0`, the kernel replaces `p` by `(2z − 1) p`. This
adds exactly one zero, `1/2`, inside the disc, and gives `|q(0)| = |a₀| ≠ 2|aₙ|`.
It then subtracts 1 from the count. A zero at the origin is split off and
counted directly.

**Termination as a certificate.** A zero `α` of `p` on the circle satisfies
`α = 1/ᾱ`. So it is a common zero of `p` and `p*`, hence of `Tp` and of every
later polynomial in the recursion, and of every `(2z − 1)`-multiple. The same
holds for a reciprocal pair `α, 1/ᾱ`. A run that ends at a nonzero constant
therefore certifies that there is no zero on the circle, and every step was a
valid instance of Lemma SC. A run that meets `Tp ≡ 0` or exhausts its budget
raises.

**Lemma R (reciprocal polynomials).** Let `p` be monic, irreducible over `Q`,
with `p* = ±p`.
- If `deg p ≥ 3`, then `p` is not the minimal polynomial of a Pisot number.
- If `deg p = 2`, then `p` is the minimal polynomial of a Pisot number iff
  `p = z² − tz + 1` with `|t| > 2`.

*Proof.* The zeros of `p` are closed under `α ↦ 1/α` and are simple, since `p`
is irreducible. Suppose exactly one zero `β` has `|β| > 1` and all others lie
in the open disc.
- For `deg p ≥ 3` there is a zero `α ∉ {β, 1/β}`. Then `|α| < 1`, so `1/α` is
  a zero outside the disc, so `1/α = β`. That contradicts `α ≠ 1/β`.
- For `deg p = 2`: `p* = −p` forces `p = z² − 1`, which is reducible. Otherwise
  `p = z² − tz + 1` has real zeros off the circle iff `t² > 4`. ∎

`pisot_verdict(p)`, for an irreducible `p`, applies Lemma R when `p` is
reciprocal. Otherwise it returns `[Z(p) = deg p − 1]`, and −1 if the count is
inconclusive.

Lemma R is needed in practice. Every unimodular quadratic has `|a₀| = |aₙ|`,
and the Schur–Cohn recursion cannot separate a reciprocal pair. Reciprocal
pairs also defeat the Routh array of the oracle.

## 2. Irreducibility certificate

`irreducibility_verdict(f)` works as follows:
1. **Refute.** An integer root `r | f(0)` refutes irreducibility; candidates
   are tried in the order `−1, 1, −2, 2, …`. If `|f(0)|` exceeds `10⁶`, the
   verdict is inconclusive.
2. **Degree ≤ 3.** With no rational root, `f` is irreducible.
3. **Degree ≥ 4.** If `f mod p` is irreducible over `F_p` for some prime
   `p < 200`, then `f` is irreducible over `Q`. Since `f` is monic, a
   factorization over `Z` (Gauss) would reduce to one mod `p` with the same
   degrees. The certificate is the least such prime, found with Rabin's test.
   If there is none, the verdict is inconclusive.

`z⁴ + 1` is irreducible over `Q` yet splits modulo every prime. The kernel
reports it inconclusive, and a test pins that.

## 3. Periodic points

- **Primitivity.** `M` is primitive iff `M^k > 0` for some
  `k ≤ (d−1)² + 1` (Wielandt). `primitivity_exponent` decides this exactly on
  the 0/1 zero pattern of `M`, which determines the zero pattern of every
  power of a non-negative matrix. So it cannot overflow: a first version that
  powered the integer matrix overflowed on 48 non-primitive period-9 Brun
  words.
- **Periodic admissibility.** `w^∞` is admissible in a sofic shift iff the
  partial map `q ↦ run(w, q)` has a cycle.
- **Representatives.** `periodic_words(shift, n)` lists the Lyndon words of
  length `n` that are periodically admissible. These are one representative
  per primitive periodic directive sequence, up to rotation.
- **Verdict pipeline.** `periodic_verdict` runs the pipeline
  primitive → irreducible → Pisot → balanced pair algorithm on the composite
  `σ_w` (vendored `build_bounded` and `nonproductive_states`). It reports the
  first stage that fails, or the BPA outcome.
- **Brun family.** `brun_unordered(d)` is the unordered Brun family of BST23
  (6.9), with the sofic condition (6.10).

## 4. Oracle independence

| Quantity | Mojo (canonical) | Python oracle |
|---|---|---|
| characteristic polynomial | Faddeev–LeVerrier | `det(tI − M)` by elimination, then Lagrange interpolation |
| disc count | Schur–Cohn with the `2z − 1` step | Routh array of the Cayley transform `q(w) = (1−w)ⁿ p((1+w)/(1−w))`, first-column zeros removed by `(w + k)` factors |
| irreducible mod `p` | Rabin's test | enumeration of monic divisors of degree ≤ `d/2` |
| BPA | vendored `substitution_dynamics` | `reference/sadic_reference/bpa.py` |

## 5. Claims guarded by `kernel/tests/test_sadic_spectrum.mojo`

- **IotaEmbeddingPSCCorpus** (finite-domain theorem; the G2 exit criterion).
  The S-adic kernel, run through the embedding `ι`, reproduces the PSC
  programme's standing corpus. Among the substitutions on three letters with
  images of length 1 to 3, exactly **4,554** are primitive, irreducible and
  Pisot by the verdicts above. That is PSC's count, from an independent
  codebase.
- **BrunFourPeriodicPointBPA** (finite-domain theorem). For BST23's periodic
  point `τ = β₁₂∘β₂₃∘β₃₄∘β₄₁` (images `12341, 12, 123, 1234`):
  - `χ = z⁴ − 5z³ + 6z² − 4z + 1` is irreducible, certified mod 2;
  - `χ` is Pisot;
  - `M_τ² > 0`;
  - the balanced pair algorithm terminates.

  This reproduces the finite input of BST23 Theorem 6.7. See
  `docs/sadic-g3-brun4-census.md`.
