# T1: a uniform overlap bound from uniform balance

**Status:** two repository-proved statements (Lemma S, Theorem T1) under
explicitly named hypotheses, with *human review pending*, followed by the open
theorem target T1′. This is the methodology's G4 target T1: the S-adic lift of
PSC `docs/overlap-finiteness-and-coincidence-density-2026-09-13.md`,
Theorem 2.1 (PSC PR #72). Nothing here proves finiteness of a balanced-pair
graph, productivity, or the S-adic Pisot conjecture.

## Setting

- `σ = (σ_n)` is a directive sequence of non-erasing substitutions on `d`
  letters.
- `L^{(k)}` is the language of the shifted sequence `(σ_{k+n})_n` (BST19 §2.2).
- `π` is the Parikh map.
- A **swap pair at depth `k` and level `N > k`** is `U = σ_{[k,N)}(ab)`,
  `V = σ_{[k,N)}(ba)` for letters `a ≠ b`. Its **swap walk** is
  `Δ(j) = π(U[:j]) − π(V[:j])`.

In PSC the recursion between levels is inflation by the single substitution.
Here it is the identity `σ_{[k,N)} = σ_k ∘ σ_{[k+1,N)}`, so depth `k` and depth
`k+1` are related by inflation under `σ_k`, and the overlap graph lives over
the shift orbit.

Tiles at depth `k` are measured by the **level-0 letter lengths**
`ℓ^{(k)}_a = |σ_{[0,k)}(a)|`, which satisfy `ℓ^{(k)ᵀ} = ℓ^{(k−1)ᵀ} M_{k−1}`. A
depth-`k` word `w` then tiles `[0, ⟨ℓ^{(k)}, π(w)⟩)`, and inflation by `σ_k`
preserves these lengths. An **overlap type at depth `k`** is `(i, j, v)`:
- `i`, `j` are the letters of a top tile of `U` and a bottom tile of `V` whose
  interiors meet;
- `v = π(V[:q]) − π(U[:p])` is the integer vector between their starting
  vertices, at positions `p` and `q`.

## Lemma S (swap-walk bound)

If `L^{(k)}` is `C`-balanced, then `‖Δ(j)‖_∞ ≤ C` for every swap pair at depth
`k`, every level `N` and every `j`.

*Proof.* Put `x = σ_{[k,N)}(a)` and `y = σ_{[k,N)}(b)`. Both lie in `L^{(k)}`,
and so do their factors.
- If `j ≤ min(|x|, |y|)`: `Δ(j) = π(x[:j]) − π(y[:j])`, the difference of two
  factors of length `j`.
- If `|y| < j ≤ |x|`: `Δ(j) = π(x[j−|y|:j]) − π(y)`, two factors of length `|y|`.
- If `|x| < j ≤ |y|`: `Δ(j) = π(x) − π(y[j−|x|:j])`, symmetrically.
- If `j > max(|x|, |y|)`: `Δ(j) = π(x[j−|y|:]) − π(y[j−|x|:])`, two suffixes of
  length `|x| + |y| − j`.

In every case each coordinate of `Δ(j)` is a difference of letter counts in
two equal-length factors of `L^{(k)}`, so it is at most `C` in absolute value. ∎

Lemma S does not use legality of `ab`, the Pisot condition, or unimodularity.
It replaces PSC's bounded-discrepancy theorem (G1b-1), where the bound came
from the Pisot spectrum of one matrix.

## Theorem T1 (uniform overlap bound)

Assume:
- **(H2) uniform balance:** every `L^{(k)}` is `C`-balanced, the "uniformly
  balanced" condition of BST19 §3.2 and [DHS13];
- **(H3) bounded length ratio:** `ℓ^{(k)}_a ≤ R · ℓ^{(k)}_b` for all `k` and
  all letters `a, b`.

Then every overlap type `(i, j, v)` occurring at any depth satisfies
`‖v‖_∞ ≤ B := C + R(1 + dC)`. So at most `d²(2B + 1)^d` overlap types occur
over the whole shift orbit.

*Proof.* This is PSC Theorem 2.1 with Lemma S in place of bounded discrepancy,
using the depth-`k` lengths `ℓ = ℓ^{(k)}`.
1. Let the top tile start at `x = ⟨ℓ, π(U[:p])⟩` and the bottom tile at
   `y = ⟨ℓ, π(V[:q])⟩`. Then `v = (π(V[:q]) − π(V[:p])) − Δ(p)`.
2. The `p`-th vertex of `V` lies at `y_p = x − ⟨ℓ, Δ(p)⟩`, so
   `|x − y_p| ≤ ‖ℓ‖₁ C`.
3. The interiors meet, so `|x − y| < ℓ_max`. Hence
   `|y − y_p| < ℓ_max + ‖ℓ‖₁ C`.
4. Every tile between those two vertices has length at least `ℓ_min`, so
   `|q − p| < (ℓ_max + ‖ℓ‖₁ C)/ℓ_min ≤ R + dRC`, using
   `‖ℓ‖₁ ≤ d ℓ_max ≤ dRℓ_min`.
5. `‖π(V[:q]) − π(V[:p])‖_∞ ≤ |q − p|` and `‖Δ(p)‖_∞ ≤ C`. Adding gives
   `‖v‖_∞ ≤ B`.
6. The count follows: `i, j` range over `d` letters each and `v` over the box
   `[−B, B]^d`. ∎

*Remarks.*
1. For a periodic sequence `w^∞` with `M_w` primitive and Pisot, (H2) holds
   (Adamczewski 2003) and (H3) holds by Perron–Frobenius. T1 then contains
   PSC Theorem 2.1 for the substitution `σ_w`, up to the choice of length
   functional.
2. (H3) fails for Arnoux–Rauzy sequences with arbitrarily long runs of a
   single `α_i`: one letter's image length grows along the run while another
   letter's stays at 1. Such sequences have unbounded weak partial quotients,
   so they lie outside the every-sequence class of BST19 Theorem 3.8.
3. BST19 Theorem 3.1 assumes C-balance only along recurring return times,
   which is weaker than (H2).

## T1′ (open theorem target)

Find a finiteness statement for the depth-indexed overlap types that needs
only the hypotheses of BST19 Theorem 3.1 (C-balance along the return times
`n_k + ℓ_k`) in place of (H2) and (H3). Natural first step: restrict the
graph to the depths `n_k + ℓ_k` and bound the types there. Between two such
depths the recurring block `σ_{[0,ℓ)}` acts by a fixed inflation.
