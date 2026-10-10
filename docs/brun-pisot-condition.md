# The Brun Pisot condition: what is proved, and what a proof for `d ≥ 5` costs

**Status:**
- Lemma D: repository-proved.
- §3: feasibility evidence (floating point), not a proof.
- The Brun Pisot condition for `5 ≤ d ≤ 10` remains an **open** theorem
  target. It is Conjecture 18.4 of ABMST (gate §10).

## 1. Where the Brun proof stands

Combining the gated results with Theorems C and C′
(`docs/sadic-g6-brun-higher-census.md`), for the unordered Brun algorithm:

| `d` | a.e. pure discrete spectrum (bounded natural codings) | Pisot condition |
|---|---|---|
| 3 | proved (BST19-3.10) | proved (ABMST-10.13, Avila–Delecroix) |
| 4 | proved (BST23-6.7) | proved (ABMST-10.13, Schratzberger; Hardcastle–Khanin) |
| 5–10 | **conditional on the Pisot condition** (Theorem C′; Theorem C for `d = 5, 6, 7`) | **open**: numerical `λ₂ < 0` only (BST21) |
| ≥ 11 | the lever does not apply | numerically false (BST21) |

So for `d = 5..10`, an unconditional proof needs exactly one statement:
`λ₂ < 0` for the Brun cocycle.

## 2. Lemma D (exact density brackets)

Work in BST21's chart `x = (x₁ ≥ x₂ ≥ … ≥ x_{d−1})`, with `ι(x) = (1, x)`.
ABMST-10.6, reindexed, gives the ordered Brun density

`ρ(x) = (x₁⋯x_{d−1})⁻¹ Σ_{S ⊆ {2,…,d−1}} (−1)^{|S|} / (1 + Σ_{k∈S} x_k)`.

**Lemma D.** Let `m = d − 2` and `B(x) = Π_{k=2}^{d−1} [0, x_k]`. Then

`ρ(x) = (m! / x₁) · avg_{t ∈ B(x)} (1 + t₁ + … + t_m)^{−(m+1)}`.

Consequently:
1. `m! / ((1+m)^{m+1} x₁) ≤ ρ(x) ≤ m! / x₁`;
2. `ρ` is nonincreasing in each coordinate. So on any set with
   componentwise bounds `a ≤ x ≤ b` we have `ρ(b) ≤ ρ ≤ ρ(a)`, and both
   bounds are rational at rational points.

*Proof.* Write `E_y g(s) = g(s + y)`. The alternating sum is
`(−1)^m Π_{k=2}^{d−1} (E_{x_k} − 1) g(0)` with `g(t) = 1/(1+t)`. Each factor
satisfies `(E_y − 1) h(s) = ∫₀^y h′(s+t) dt`, so the sum equals
`(−1)^m ∫_{B(x)} g^{(m)}(t₁+…+t_m) dt`. Since
`g^{(m)}(t) = (−1)^m m! (1+t)^{−(m+1)}`, it equals
`m! ∫_{B(x)} (1+Σt)^{−(m+1)} dt`. Dividing by `Π_{k≥2} x_k = Leb(B(x))`
gives the formula.
- (1) The integrand lies in `[(1+m)^{−(m+1)}, 1]` because `0 ≤ t_k ≤ 1`.
- (2) The integrand is decreasing in each `t_k`. Enlarging `[0, x_k]` adds only
  larger `t_k`, so the average is nonincreasing in `x_k`. `1/x₁` is
  decreasing in `x₁`. ∎

For `d = 3` the formula gives `1/(x₁(1+x₂))`, which is ABMST Corollary 10.7
in BST's chart.

**Consequence.** The density is singular only where `x₁ → 0`, at the vertex
`ι = (1, 0, …, 0)`. Every cylinder bounded away from that vertex has exact
rational density brackets. This is the measure input to the bound below.

## 3. The known rigorous method and its cost at `d = 5` (evidence)

The method is the BST21-5.4 template:

`λ₂ ≤ (1/n) Σ_w µ(Δ_w) max_{v ∈ vert Δ_w} log‖N_{c(T^n v)} D⁽ⁿ⁾(v) N_{c(v)}⁻¹‖∞`.

It is valid because:
- `D⁽ⁿ⁾` is affine on each `n`-cylinder, since `A⁽ⁿ⁾` is constant there and `H`
  is affine. So each maximum is at a vertex.
- Conjugating by finitely many invertible `N_c`, constant on depth-`k`
  cylinders, preserves the Lyapunov spectrum. So BST21-3.4 applies to the
  conjugated cocycle.
- The sign of the bound does not depend on the normalisation of `µ`, once
  positive and negative terms are bracketed separately (Lemma D).

The measurements below are floating point, orbit simulations and exact
cylinder enumeration, for `d = 5`. They are evidence only.

| quantity | `n = 6` | `n = 7` | `n = 8` | `n = 10` | `n = 20` | `n = 25` | `n = 40` |
|---|---|---|---|---|---|---|---|
| `(1/n) E log‖D⁽ⁿ⁾‖∞`, orbit average | 0.077 | 0.065 | 0.056 | 0.042 | 0.006 | −0.003 | −0.017 |
| vertex-max bound, identity norm, exact enumeration | 0.105 | 0.087 | | | | | |
| vertex-max bound, optimised norms of depth `k ≤ 2` | 0.071 | 0.072 | | | | | |

- The orbit average tends to `λ₂ ≈ −0.0465` (BST21) like `c/n`. It turns
  negative only at `n ≈ 24`.
- Cylinder-dependent norms recover about 0.02–0.03 at small `n`. That is far
  short of the gap.
- The vertex maximum adds about 0.02–0.03 more at `n ≤ 7`.
- An earlier sampled optimisation reported negative values. Those were an
  overfitting artifact: rare ill-conditioned transitions were absent from
  the sample. By subadditivity no correct value can fall below `λ₂`.

**Cost estimate.** The bound has to be evaluated near `n ≈ 20` or deeper.
- The mass of `µ` sits on about `e^{hn}` cylinders, where
  `h = d·λ₁ ≈ 5 × 0.31 ≈ 1.55` nats per step. At `n = 20` that is
  `10¹³`–`10¹⁴` cylinders.
- Cylinders cannot be dropped cheaply. A dropped cylinder only has the crude
  bound `log‖D⁽¹⁾‖∞ ≤ log 2` per step, so dropping a mass `P` costs about
  `0.69 P`, against an average gain of about 0.03.
- An acceleration (for example the modified Jacobi–Perron map) does not change
  `e^{hn}`, since entropy per unit of Brun time is invariant (Abramov).
- The cost is above the BST21 Selmer campaign (`2⁵²` words, GPU). It is out of
  reach of this repository's resources, and `d ≥ 6` is harder: the margin
  `|λ₂|` shrinks and the entropy grows.

## 4. Routes that would change the picture

1. **Long-horizon adapted norms.** A Lyapunov norm can bring the transient to
   `n = 1` in principle, as Avila–Delecroix's cone norm does at `d = 3`. Any
   finite description of one, though, encodes the same `e^{hn}` information.
   It needs a structural idea, not a larger search.
2. **A structural Pisot argument.** Find a uniform contraction on an induced
   sub-system that has a known return-time distribution. Then Abramov's
   formula converts a uniform bound into `λ₂ < 0`. Theorem B (all composites
   in the mirror Barge class) is the kind of uniform structure such an
   argument would have to exploit.
3. **A GPU-scale certified campaign.** Use the template of §3 with Lemma D's
   rational brackets, exact vertex arithmetic in the Mojo kernel, and
   outward-rounded logarithms.
