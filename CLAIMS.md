# Claim register

**Status:** the claim-state plane: one row per tracked claim. Each status here
must agree with `claim_governance.toml`, and a change goes to both in the same
commit. The status vocabulary is the PSC programme's.

| Claim | Status | Statement | Source |
|---|---|---|---|
| S-adic Pisot conjecture | Open theorem target | BST19 Conjecture 3.5: a primitive, algebraically irreducible, recurrent unimodular directive sequence with balanced language tiles and has pure discrete spectrum | `docs/literature-gate-2026-10-09.md` §1 |
| BST19 conditional tiling theorem | Imported theorem | BST19 Theorem 3.1 with its exact hypotheses; tiling iff geometric coincidence | `docs/literature-gate-2026-10-09.md` §2 |
| BST23 periodic-point reduction | Imported theorem | BST23 Theorems 3.1/3.5: Pisot condition plus one periodic point with pure discrete spectrum gives a.e. pure discrete spectrum | `docs/literature-gate-2026-10-09.md` §2 |
| Image balance lower bound | Repository-proved | The balance of `σ_w(a)` bounds the balance constant of `L_σ` below for every `σ` with prefix `w` | `docs/sadic-kernel-g2-slice.md` |
| Sturmian image balance | Finite-domain theorem | Two-letter Arnoux–Rauzy images `σ_w(a)` with `|w| ≤ 10` are 1-balanced | `docs/sadic-kernel-g2-slice.md` |
| Brun positive blocks | Finite-domain theorem | Minimal positive Brun blocks up to length 5: 0, 0, 0, 6, 30 by length | `docs/sadic-kernel-g2-slice.md` |
