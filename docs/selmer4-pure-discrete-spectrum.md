# Selmer with four coordinates: a.e. pure discrete spectrum

**Status:**
- Theorem S: repository-proved. It rests on the imported BST23 Theorem 3.1
  and BST21 Theorem 5.4 (computer-assisted, rigorous error control), on
  Lemma F proved here, and on one finite-domain witness.
- Novelty boundary: BST23 Theorem 3.3 already yields a.e. pure discrete
  spectrum for *some* acceleration `T^k` with *some* faithful realization,
  once a periodic Pisot point with positive range exists. Theorem S is the
  explicit instance for `T` itself and a concrete realization.
- Corollary S′ (bounded remainder sets for all words): repository-proved,
  from BST23 Theorem 3.8 and the right-proper word of Lemma P.
- No novelty is claimed beyond that.

Convention: `d` counts coordinates, as everywhere in this repository. BST21
writes `d = 3` (projective) for this case.

## 1. The algorithm and its realization

BST21 §5.1 (gate §11) defines the sorted Selmer map
`T(x₁,…,x₃) = κ(ord(1 − x₃, x₁, x₂, x₃))` on
`∆ = {1 ≥ x₁ ≥ x₂ ≥ x₃ ≥ 0}`, with matrix `A = S_a` on
`∆_a = {2x₃ > 1}` and `A = S_b` on `∆_b = {2x₃ < 1 ≤ x₂ + x₃}`:

```
S_a = 0 1 0 0      S_b = 0 1 0 0
      0 0 1 0            0 0 1 0
      1 0 0 1            1 0 0 0
      1 0 0 0            1 0 0 1
```

Both matrices are nonnegative with `|det| = 1`, so the algorithm is
*positive*. Almost every orbit enters the absorbing set `∆_S = ∆_a ∪ ∆_b`
and stays there. On `∆_S` the measure `dµ_S = c dx₁dx₂dx₃/(x₁x₂x₃)` is an
ergodic invariant probability measure (BST21 §5.1, citing Schweiger and
Lagarias (H1)–(H5)). BST23 allows any `∆ ⊆ {‖x‖₁ = 1}`, so we take `∆_S`,
transported to the 1-norm chart, as the domain.

**Realization.** By BST23 Definition 2.2, a substitution selection is
*faithful* when it depends only on `A(x)`, with incidence matrix `ᵗA(x)`.
We take (1-based letters):
- `σ_a: 1 ↦ 2, 2 ↦ 3, 3 ↦ 14, 4 ↦ 1` (incidence matrix `ᵗS_a`);
- `σ_b: 1 ↦ 2, 2 ↦ 3, 3 ↦ 1, 4 ↦ 41` (incidence matrix `ᵗS_b`);
- `ϕ(x) = σ_a` on `∆_a` and `σ_b` on `∆_b`.

This is `selmer4()` in `kernel/sadic/directive.mojo` and in the oracle.
Theorem S holds for all four orderings of the two-letter images. The mixed
ordering chosen here is also right proper on a word (Corollary S′); the
orderings `14, 14` and `41, 41` never are: in both unmixed cases both
last-letter maps are permutations, so no composite is right proper.

## 2. Lemma F (full branches)

**Lemma F.** Both branches of `T` map onto the absorbing set:
`T(∆_a) = T(∆_b) = ∆_S` up to boundaries. Hence:
- every word in `{a, b}ⁿ` is the cylinder word of a nonempty cylinder;
- the follower sets `Tⁿ∆⁽ⁿ⁾(x)` all equal `∆_S`;
- every point has positive range (BST23 Definition 2.8), since
  `inf_n µ_S(Tⁿ∆⁽ⁿ⁾(x)) = 1`.

*Proof.* Work homogeneously with `y = (y₀ ≥ y₁ ≥ y₂ ≥ y₃)`, where `x = κ(y)`
and `L(y)A = y`. Let `z = (z₀ ≥ … ≥ z₃)` lie in the absorbing cone,
`z₂ + z₃ ≥ z₀`.

- **Branch a.** Put `y = zS_a = (z₂ + z₃, z₀, z₁, z₂)`. Then:
  - `y` is sorted, because `z₂ + z₃ ≥ z₀ ≥ z₁ ≥ z₂`;
  - `2y₃ > y₀` reads `2z₂ > z₂ + z₃`, which holds for `z₂ > z₃`;
  - `y₂ + y₃ ≥ y₀` reads `z₁ + z₂ ≥ z₂ + z₃`, which holds.

  So `y ∈ ∆_a`. Moreover `L(y)`, computed as "subtract `y₃` from `y₀` and
  sort", gives `(z₀, z₁, z₂, z₃) = z`.
- **Branch b.** Put `y = zS_b = (z₂ + z₃, z₀, z₁, z₃)`. Then:
  - `y` is sorted, because `z₁ ≥ z₃`;
  - `2y₃ < y₀` reads `z₃ < z₂`;
  - `y₂ + y₃ ≥ y₀` reads `z₁ + z₃ ≥ z₂ + z₃`.

  So `y ∈ ∆_b`, and `L(y) = z`.

Every point of `∆_S` therefore has a preimage in each branch. The equalities
of follower sets follow by induction, and positive range follows. ∎

**Positive cylinder measure.** Nonemptiness alone would not imply positive
measure. On the strict interior of the absorbing cone, each inverse branch
above, followed by chart normalization, is a projective diffeomorphism with
nonzero Jacobian. For any finite branch word, composing these inverse
branches maps a nonempty open subset of that interior into its cylinder.
The density `c/(x₁x₂x₃)` is positive there; hence every finite branch cylinder
has positive `µ_S` measure. Boundary points and their iterated preimages may
be discarded as null sets throughout this argument.

## 3. The periodic Pisot point

**Witness** (`test_selmer_four_periodic_point`, Mojo and Python; claim
`SelmerFourPeriodicPointBPA`). Let `w = a a b b` and
`σ_w = σ_a ∘ σ_a ∘ σ_b ∘ σ_b`. The incidence matrix `M_w` is primitive with
characteristic polynomial `z⁴ − 2z³ − z + 1`, irreducible and Pisot, as
certified by the kernel. The balanced pair algorithm from the swap seeds
terminates on `σ_w`. The same holds for all four orderings of the images
`14`.

Let `x₀` be the dominant right eigenvector of `M_w`. By Lemma F,
`ϕ(x₀) = w^∞`, as in BST23's Cassaigne–Selmer argument (§6.2), and `x₀` has
positive range. `σ_w` is unimodular, Pisot and irreducible, so by BST23
Proposition 6.1 `ϕ(x₀)` has pure discrete spectrum.

## 4. Theorem S

**Theorem S.** For `µ_S`-almost every `x ∈ ∆_S`, the S-adic dynamical
system `(X_{ϕ(x)}, Σ)` of the sorted Selmer algorithm with four coordinates
is a bounded natural coding of the minimal translation by `π′(x)` on `T³`.
In particular, its measure-theoretic spectrum is purely discrete.

*Proof.* We apply BST23 Theorem 3.1 to `(∆_S, T, A, µ_S)`. Its hypotheses
are met as follows:
1. **Positive.** `S_a, S_b ∈ ℕ^{4×4}` with `|det| = 1` (§1).
2. **Pisot condition.** BST21 Theorem 5.4 gives `λ₂(A) < −0.000436459` for
   this cocycle and measure.
   - BST21 writes `L(y) = yA⁻¹` on rows. BST23 writes `T(x) = ᵗA⁻¹x / ‖·‖₁`.
     These are the same cocycle `A⁽ⁿ⁾ = A(Tⁿ⁻¹x)⋯A(x)` in two charts.
   - Unimodularity gives `Σλᵢ = 0`, so `λ₂ < 0` forces `λ₁ > 0`.
3. **`µ_S ∘ T ≪ µ_S`.** `µ_S` is equivalent to Lebesgue measure on `∆_S`,
   and `T` is a piecewise projective diffeomorphism there.
4. **Faithful realization.** `ϕ` of §1.
5. **A periodic Pisot point with positive range and pure discrete
   spectrum.** `x₀` of §3, with positive range by Lemma F. ∎

**What it adds.** With BST23 Theorem 6.2 (Cassaigne–Selmer, three
coordinates), Theorem S covers the Selmer algorithm in every dimension where
its Pisot condition is known. For five or more coordinates the Pisot
condition is numerically false (BST21; ABMST Conjecture 18.4).

## 5. Corollary S′ (bounded remainder sets for all words)

**Lemma P.** The composite `σ_{baabaab}` is right proper: every image ends
with letter 1. With the composition convention of §3, its images are
`1 ↦ 24131`, `2 ↦ 32241`, `3 ↦ 1`, `4 ↦ 321`.
`test_selmer_four_right_proper_word` pins all four images in Mojo and
Python; `kernel/vectors.mojo` and `tools/cross_check.py` compare them
directly across languages. This finite witness establishes properness of
the composite, not the measure-theoretic conclusion by itself.

**Corollary S′.** For `µ_S`-almost every `x ∈ ∆_S`, the directive sequence
`ϕ(x)` is right proper. Hence for every word `i₀i₁⋯iₙ` of its language, the
set `F_{i₀} ∩ R⁻¹F_{i₁} ∩ ⋯ ∩ R⁻ⁿF_{iₙ}` is a bounded remainder set of the
translation `R` of Theorem S. In particular, every `−R′_{ϕ(x)}(i₀⋯iₙ)` is a
bounded remainder set.

Here `F_i = −R′_{ϕ(x)}(i)` is a letter subtile in the bounded fundamental
domain `F = −R′_{ϕ(x)}`. In the displayed intersection the atoms are
identified with their images on `T³`. Equivalently, on `F` use the associated
domain exchange `R̃` and form `F_{i₀} ∩ R̃⁻¹F_{i₁} ∩ ⋯ ∩ R̃⁻ⁿF_{iₙ}`.
The symbolic cylinder `[i₀⋯iₙ] ⊆ X_{ϕ(x)}`, this geometric cylinder, and the
word subtile defined in BST23 Definition 2.7 are distinct constructions;
Theorem 3.8 supplies the bounded-remainder conclusion for the geometric
cylinder and for the negative projected word subtile. Sets are interpreted
modulo null boundaries, as in BST23 Definitions 2.4–2.6.

Explicitly, for each finite language word `v` its toral set `C_v` has a
constant `C(x,v)` such that
`|Σ_{j=0}^{N−1} 1_{C_v}(R^j z) − N λ(C_v)| ≤ C(x,v)`
for all `N` and Haar-almost every `z`. The constant need not be uniform over
word lengths or over `x`. There are countably many finite words, so a single
full-measure set of `z` can be used for all of them. This makes no assertion
about every boundary orbit, every Selmer parameter, or a uniform balance
bound for all words.

*Proof.* Let `u = baabaab`.
- Let `B_u ⊆ ∆_S` be the **branch** cylinder with itinerary `u`, distinct
  from a word cylinder in the Selmer language. By Lemma F and its positive
  cylinder measure argument, `µ_S(B_u) > 0`. Birkhoff's ergodic theorem
  applied to `1_{B_u}` gives visit frequency `µ_S(B_u) > 0` for almost every
  `x`, and therefore infinitely many occurrences of `u`.
- Intersect this full-measure set with the one in Theorem S. Fix such an
  `x` and any `k`, and choose an occurrence starting at `m ≥ k`; put
  `n = m + 7 > k`.
  Then `σ_{[k,n)} = σ_{[k,m)} ∘ σ_u`. If `σ_u(i)` ends with `j` for every
  `i`, then `σ_{[k,n)}(i)` ends with the last letter of `σ_{[k,m)}(j)`,
  which does not depend on `i`. All substitutions are non-erasing; when
  `m = k` the outer composite is the identity. So `ϕ(x)` is right proper in the sense of
  BST23 §2.3.
- Theorem S gives a natural coding with respect to the partition
  `{−R′_{ϕ(x)}(i)}` of a bounded fundamental domain, the Rauzy fractal.
  This has exactly four atoms for a translation on `T³`, as required by
  BST23 Theorem 3.8. Its S-adic hypothesis and right properness give the
  conclusion for every finite language word, not just letters. ∎

This is the four-coordinate analogue of BST23 Theorem 6.2(iii).
The general all-word bounded-remainder theorem is imported from BST23,
not newly proved here. The repository contribution is the explicit mixed
Selmer realization, Lemmas F and P, and their application to Theorem S.
The provisional survey in gate §12 is not a dependency and establishes no
exhaustive priority or literature-completeness claim.

