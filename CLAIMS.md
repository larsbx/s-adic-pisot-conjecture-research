# Claim register

**Status:** the claim-state plane: one row per tracked claim. Each status here
must agree with `claim_governance.toml`, and a change goes to both in the same
commit. The status vocabulary is the PSC programme's.

| Claim | Status | Statement | Source |
|---|---|---|---|
| S-adic Pisot conjecture | Open theorem target | BST19 Conjecture 3.5: a primitive, algebraically irreducible, recurrent unimodular directive sequence with balanced language tiles and has pure discrete spectrum | `docs/literature-gate-2026-10-09.md` §1 |
| BST19 conditional tiling theorem | Imported theorem | BST19 Theorem 3.1, applicable only under all its hypotheses: unimodular, primitive, algebraically irreducible, with C-balance along recurring prefixes. Then tiling holds iff geometric coincidence holds. The exact formulation is the gated one | `docs/literature-gate-2026-10-09.md` §2 |
| BST23 periodic-point reduction | Imported theorem | BST23 Theorems 3.1/3.5, applicable only under **all** their hypotheses: a positive continued fraction algorithm with `ν∘T ≪ ν`, the Pisot condition, a faithful substitutive realization, and a periodic Pisot point with positive range whose substitution has pure discrete spectrum. Conclusion: a.e. bounded natural codings, hence pure discrete spectrum. The exact formulation is the gated one | `docs/literature-gate-2026-10-09.md` §2 |
| Image balance lower bound | Repository-proved | The balance of `σ_w(a)` bounds the balance constant of `L_σ` below for every `σ` with prefix `w` | `docs/sadic-kernel-g2-slice.md` |
| Sturmian image balance | Finite-domain theorem | Two-letter Arnoux–Rauzy images `σ_w(a)` with `|w| ≤ 10` are 1-balanced | `docs/sadic-kernel-g2-slice.md` |
| Brun positive blocks | Finite-domain theorem | Minimal positive Brun blocks up to length 5: 0, 0, 0, 6, 30 by length | `docs/sadic-kernel-g2-slice.md` |
| BST23 balanced-pair criterion | Imported theorem | BST23 Proposition 6.1: a unimodular Pisot irreducible substitution has pure discrete spectrum iff the balanced pair algorithm from the swap seeds terminates | `docs/literature-gate-2026-10-09.md` §5 |
| Iota embedding PSC corpus | Finite-domain theorem | Through the embedding ι the S-adic kernel certifies the PSC standing corpus instance by instance: the 4,554 primitive irreducible Pisot substitutions on three letters with images of length 1 to 3, equal line by line to PSC's pinned list `tests/data/psc-pip-corpus.txt` | `docs/sadic-kernel-g2-spectrum.md` §5 |
| Brun four periodic point BPA | Finite-domain theorem | BST23's periodic point `τ = β₁₂∘β₂₃∘β₃₄∘β₄₁` is primitive, irreducible and Pisot, and the balanced pair algorithm terminates on it | `docs/sadic-g3-brun4-census.md` §1 |
| Brun four periodic census | Finite-domain theorem | Every primitive periodic point of the unordered Brun shift with `d = 4` and period ≤ 8 is classified with no open verdict. The 6,386 composites that are primitive, irreducible and Pisot all pass the balanced pair algorithm, so each has pure discrete spectrum by the BST23 balanced-pair criterion | `docs/sadic-g3-brun4-census.md` §2 |
| Swap walk balance bound | Repository-proved | Lemma S: if `L^{(k)}` is C-balanced, every swap walk at depth `k` stays within C; human review pending | `docs/t1-uniform-overlap-finiteness.md` |
| Uniform overlap bound | Repository-proved | Theorem T1: uniform C-balance and a bounded length ratio R bound every depth-indexed overlap type by `C + R(1 + dC)`; human review pending | `docs/t1-uniform-overlap-finiteness.md` |
| Positive suffix length ratio | Repository-proved | Lemma P: a fixed positive suffix B bounds the coordinates of any nonzero nonnegative row wB by the sharp ratio R_B; human review pending | `docs/t1-uniform-overlap-finiteness.md` |
| Overlap finiteness along return times | Repository-proved | T1′: BST19 Theorem 3.1's hypotheses give selected PRICE return depths whose swap-pair type triples share the bound C + R_B(1 + dC), without a global length-ratio assumption; human review pending | `docs/t1-uniform-overlap-finiteness.md` |
| All-depth overlap finiteness | Open theorem target | Extend T1′ from selected return depths to every depth, or give a finite presentation of the return transitions, under BST19 Theorem 3.1 alone | `docs/t1-uniform-overlap-finiteness.md` |
