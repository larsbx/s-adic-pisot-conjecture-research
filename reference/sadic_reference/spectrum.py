"""Exact spectral certificates for integer matrices (oracle for kernel/sadic/spectrum.mojo).

Written independently of the Mojo kernel: the characteristic polynomial comes
from interpolating `det(tI - M)` instead of Faddeev-LeVerrier, the unit-disc
count from a Routh array on the Cayley transform instead of the Schur-Cohn
recursion, and the mod-p irreducibility test from enumerating monic divisors
instead of Rabin's test. Polynomials are coefficient tuples, lowest degree first.
"""

from __future__ import annotations

from fractions import Fraction
from itertools import product

Poly = tuple[int, ...]
ROOT_CANDIDATE_CAP = 1_000_000
PRIMES = tuple(p for p in range(2, 200) if all(p % q for q in range(2, p) if q * q <= p))


def _det(rows: list[list[Fraction]]) -> Fraction:
    a = [r[:] for r in rows]
    n, det = len(a), Fraction(1)
    for c in range(n):
        pivot = next((r for r in range(c, n) if a[r][c] != 0), None)
        if pivot is None:
            return Fraction(0)
        if pivot != c:
            a[c], a[pivot] = a[pivot], a[c]
            det = -det
        det *= a[c][c]
        for r in range(c + 1, n):
            f = a[r][c] / a[c][c]
            a[r] = [x - f * y for x, y in zip(a[r], a[c])]
    return det


def charpoly(m: tuple[tuple[int, ...], ...]) -> Poly:
    """`det(tI - M)` by Lagrange interpolation at t = 0..d."""
    d = len(m)
    xs = list(range(d + 1))
    ys = [_det([[Fraction(int(i == j) * t - m[i][j]) for j in range(d)] for i in range(d)]) for t in xs]
    coeffs = [Fraction(0)] * (d + 1)
    for i, xi in enumerate(xs):
        basis = [Fraction(1)]
        denom = Fraction(1)
        for j, xj in enumerate(xs):
            if j != i:
                basis = [(basis[k - 1] if k > 0 else 0) - xj * (basis[k] if k < len(basis) else 0)
                         for k in range(len(basis) + 1)]
                denom *= xi - xj
        for k in range(d + 1):
            coeffs[k] += ys[i] * basis[k] / denom
    assert all(c.denominator == 1 for c in coeffs)
    return tuple(int(c) for c in coeffs)


class Inconclusive(ArithmeticError):
    """The exact test met a degenerate case and decides nothing."""


def _routh_left(q: list[Fraction]) -> int:
    """Zeros of q with negative real part, by the Routh array; raises on any
    zero in the first column (the array then decides nothing)."""
    n = len(q) - 1
    if q[n] == 0:
        raise Inconclusive("degree drop")
    rows = [q[n::-2], q[n - 1::-2] if n >= 1 else []]
    width = len(rows[0])
    rows = [r + [Fraction(0)] * (width - len(r)) for r in rows]
    for _ in range(n - 1):
        a, b = rows[-2], rows[-1]
        if b[0] == 0:
            raise Inconclusive("zero in the first Routh column")
        rows.append([(b[0] * a[i + 1] - a[0] * b[i + 1]) / b[0] for i in range(width - 1)] + [Fraction(0)])
    first = [r[0] for r in rows[: n + 1]]
    if any(x == 0 for x in first):
        raise Inconclusive("zero in the first Routh column")
    return n - sum(1 for x, y in zip(first, first[1:]) if (x > 0) != (y > 0))


def _poly_mul(a: list, b: list) -> list:
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


def _poly_pow(a: list, k: int) -> list:
    out = [1]
    for _ in range(k):
        out = _poly_mul(out, a)
    return out


def _compose_moebius(p: Poly, num: list, den: list) -> list:
    """`den^n * p(num / den)` for linear `num`, `den`."""
    n = len(p) - 1
    out = [0] * (n + 1)
    for k, a in enumerate(p):
        term = _poly_mul(_poly_pow(num, k), _poly_pow(den, n - k))
        for i, x in enumerate(term):
            out[i] += a * x
    return out


LEFT_FACTORS = (1, 2, 3, 5, 7)


def disc_zero_count(p: Poly) -> int:
    """Zeros of p in the open unit disc, none on the circle. The Cayley
    transform `q(w) = (1 - w)^n p((1 + w) / (1 - w))` sends the disc to the left
    half-plane, counted by the Routh array. A zero in its first column is
    removed, exactly, by multiplying q by `w + k` (one more left zero) for the
    first k in LEFT_FACTORS whose array is nonsingular. A zero on the circle or
    a reciprocal pair `(alpha, 1/conj(alpha))` (a pair `w, -conj(w)`) defeats
    every multiplier, and the count is then inconclusive."""
    q = [Fraction(x) for x in _compose_moebius(p, [1, 1], [1, -1])]
    try:
        return _routh_left(q)
    except Inconclusive:
        pass
    for k in LEFT_FACTORS:
        try:
            return _routh_left(_poly_mul(q, [Fraction(k), Fraction(1)])) - 1
        except Inconclusive:
            continue
    raise Inconclusive(f"no nonsingular Routh array for {p}")


def is_reciprocal(p: Poly) -> bool:
    """`p* = +-p`, with `p*(z) = z^n p(1/z)`."""
    r = p[::-1]
    return r == p or r == tuple(-x for x in p)


def pisot_verdict(p: Poly) -> int:
    """For a monic polynomial irreducible over Q: 1 when exactly one root lies
    outside the closed unit disc and the others inside the open disc
    (certified), 0 when certified otherwise, -1 inconclusive.

    Reciprocal polynomials are decided by Lemma R
    (docs/sadic-kernel-g2-spectrum.md): never Pisot in degree >= 3, and
    `z^2 - t z + 1` is Pisot iff `|t| > 2`."""
    d = len(p) - 1
    if is_reciprocal(p):
        if d >= 3:
            return 0
        if d == 2:
            return int(p[0] == 1 and abs(p[1]) > 2)
    try:
        return int(disc_zero_count(p) == d - 1)
    except Inconclusive:
        return -1


def _divides_mod(f: list[int], g: list[int], p: int) -> bool:
    r = [x % p for x in f]
    while len(r) >= len(g):
        c = r[-1]
        for i in range(len(g)):
            r[len(r) - len(g) + i] = (r[len(r) - len(g) + i] - c * g[i]) % p
        r.pop()
    return all(x == 0 for x in r)


def irreducible_mod(f: Poly, p: int) -> bool:
    d = len(f) - 1
    for k in range(1, d // 2 + 1):
        for low in product(range(p), repeat=k):
            if _divides_mod(list(f), list(low) + [1], p):
                return False
    return True


def irreducibility_verdict(f: Poly) -> tuple[int, int]:
    """(1, p) irreducible over Q, certified by f mod p (p = 0: by excluding
    rational roots, decisive for degree <= 3); (0, r) reducible with integer
    root r, the first in the order -1, 1, -2, 2, ...; (-1, 0) inconclusive,
    also when |f(0)| exceeds ROOT_CANDIDATE_CAP. f must be monic."""
    d = len(f) - 1
    c0 = f[0]
    if d > 1:
        if c0 == 0:
            return (0, 0)
        if abs(c0) > ROOT_CANDIDATE_CAP:
            return (-1, 0)
        for k in range(1, abs(c0) + 1):
            if c0 % k == 0:
                for r in (-k, k):
                    if sum(a * r ** i for i, a in enumerate(f)) == 0:
                        return (0, r)
    if d <= 3:
        return (1, 0)
    for p in PRIMES:
        if irreducible_mod(f, p):
            return (1, p)
    return (-1, 0)


def primitivity_exponent(m) -> int:
    """Least k <= (d-1)^2 + 1 with M^k > 0 (Wielandt's bound), else -1: M is
    then not primitive."""
    from sadic_reference import is_positive, matmul
    d = len(m)
    power = m
    for k in range(1, (d - 1) ** 2 + 2):
        if is_positive(power):
            return k
        power = matmul(power, m)
    return -1
