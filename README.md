# s-adic-pisot-conjecture-research

Research programme on the S-adic Pisot conjecture. It builds on the exact
infrastructure of
[`pisot-substitution-conjecture-research`](https://github.com/larsbx/pisot-substitution-conjecture-research)
and [`finite-math-kernels`](https://github.com/larsbx/finite-math-kernels).

**Status:** the S-adic Pisot conjecture is **open**. The repository's own results so far are a lemma and two finite-domain calibrations, listed in `CLAIMS.md`.

Start with [`docs/METHODOLOGY.md`](docs/METHODOLOGY.md). It gives the general
method for attacking a generalization from an existing programme (phases G0–G7
and their invariant rules), and §5 instantiates it for this repository.

Then read:

- [`docs/literature-gate-2026-10-09.md`](docs/literature-gate-2026-10-09.md):
  exact hypotheses of the imported results, and the per-algorithm,
  per-dimension status matrix;
- [`CLAIMS.md`](CLAIMS.md): the claim register;
- [`docs/sadic-kernel-g2-slice.md`](docs/sadic-kernel-g2-slice.md): the exact
  Mojo kernel `kernel/sadic/` (directive shifts, checked incidence cocycle,
  positive blocks, Hilbert cross-ratio bound, balance lower bounds) and its
  Python oracle.

Layout and authority: [`ARCHITECTURE.md`](ARCHITECTURE.md). Working rules and
the pre-push checks: [`AGENTS.md`](AGENTS.md).
