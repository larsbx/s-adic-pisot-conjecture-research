"""Exact spectral certificates for integer matrices and monic integer polynomials.

Polynomials are `List[Int]`, lowest degree first; all arithmetic is checked
and an overflow raises (inconclusive, never a wrong verdict). Specification
and proofs: docs/sadic-kernel-g2-spectrum.md.

- `charpoly`: `det(zI - M)` by Faddeev-LeVerrier; every division is exact.
- `disc_zero_count`: zeros in the open unit disc by the Schur-Cohn reduction
  `Tp = p(0) p - a_n p*`, with `p*(z) = z^n p(1/z)` (Rouche on the circle,
  where `|p*| = |p|`). A degenerate step `|p(0)| = |a_n|` is removed, exactly,
  by multiplying by `2z - 1` (one more zero in the disc). Zeros on the circle
  and reciprocal pairs are common zeros of `p` and `p*`, survive every step,
  and make the count raise.
- `pisot_verdict`: one root outside the closed disc, the rest inside the open
  disc, for a monic irreducible polynomial; reciprocal polynomials by Lemma R.
- `irreducibility_verdict`: rational roots refute; degree <= 3 without one is
  irreducible; otherwise the least prime `p < 200` with `f mod p` irreducible
  (Rabin's test) certifies irreducibility over Q, and no such prime is
  inconclusive.

Reference oracle: `reference/sadic_reference/spectrum.py` (independent
algorithms: interpolation, a Routh array on the Cayley transform, and
enumeration of monic divisors mod p).
"""

from finite_exact.checked_int import checked_add, checked_mul, checked_sub
from sadic.cocycle import matmul

comptime ROOT_CANDIDATE_CAP = 1_000_000
comptime SCHUR_COHN_BUDGET = 64
comptime PRIME_LIMIT = 200


def charpoly(m: List[Int], d: Int) raises -> List[Int]:
    """`det(zI - M)`, lowest degree first, monic."""
    if len(m) != d * d:
        raise Error("charpoly needs a d x d matrix")
    var coeffs = List[Int]()
    for _ in range(d + 1):
        coeffs.append(0)
    coeffs[d] = 1
    var mk = List[Int]()
    for _ in range(d * d):
        mk.append(0)
    for k in range(1, d + 1):
        # M_k = A M_{k-1} + c_{d-k+1} I ; c_{d-k} = -tr(A M_k) / k
        var next = matmul(m, mk, d)
        for i in range(d):
            next[i * d + i] = checked_add(next[i * d + i], coeffs[d - k + 1])
        mk = next^
        var am = matmul(m, mk, d)
        var trace = 0
        for i in range(d):
            trace = checked_add(trace, am[i * d + i])
        if trace % k != 0:
            raise Error("Faddeev-LeVerrier division is not exact")
        coeffs[d - k] = -(trace // k)
    return coeffs^


def _trim(p: List[Int]) -> List[Int]:
    var out = p.copy()
    while len(out) > 1 and out[len(out) - 1] == 0:
        _ = out.pop()
    return out^


def _gcd(a: Int, b: Int) -> Int:
    var x = a if a >= 0 else -a
    var y = b if b >= 0 else -b
    while y != 0:
        var t = x % y
        x = y
        y = t
    return x


def _primitive(p: List[Int]) -> List[Int]:
    var g = 0
    for c in p:
        g = _gcd(g, c)
    if g <= 1:
        return p.copy()
    var out = List[Int]()
    for c in p:
        out.append(c // g)
    return out^


def _disc_count(p0: List[Int], budget: Int) raises -> Int:
    if budget <= 0:
        raise Error("Schur-Cohn budget exhausted: inconclusive")
    var p = _trim(p0)
    var extra = 0
    var n = len(p) - 1
    while n > 0 and p[0] == 0:
        # a zero at the origin lies in the disc
        extra += 1
        var tail = List[Int]()
        for i in range(1, len(p)):
            tail.append(p[i])
        p = tail^
        n -= 1
    if n == 0:
        if p[0] == 0:
            raise Error("zero polynomial: inconclusive")
        return extra
    var a0 = p[0]
    var an = p[n]
    var gamma = checked_sub(checked_mul(a0, a0), checked_mul(an, an))
    if gamma == 0:
        # (2z - 1) p has the extra zero 1/2 and |q(0)| != |q_lead|
        var q = List[Int]()
        q.append(-p[0])
        for i in range(1, n + 1):
            q.append(checked_sub(checked_mul(2, p[i - 1]), p[i]))
        q.append(checked_mul(2, p[n]))
        return extra + _disc_count(q, budget - 1) - 1
    var t = List[Int]()
    for i in range(n + 1):
        t.append(checked_sub(checked_mul(a0, p[i]), checked_mul(an, p[n - i])))
    t = _primitive(_trim(t))
    if len(t) == 1 and t[0] == 0:
        raise Error("Schur-Cohn transform vanishes: inconclusive")
    var z = _disc_count(t, budget - 1)
    # |a_n| > |a_0|: Tp has the zeros of p* in the disc, n - Z(p) of them
    return extra + (n - z if gamma < 0 else z)


def disc_zero_count(p: List[Int]) raises -> Int:
    """Zeros of p in the open unit disc; raises when inconclusive."""
    return _disc_count(p, SCHUR_COHN_BUDGET)


def is_reciprocal(p: List[Int]) -> Bool:
    var n = len(p) - 1
    var plus = True
    var minus = True
    for i in range(n + 1):
        if p[i] != p[n - i]:
            plus = False
        if p[i] != -p[n - i]:
            minus = False
    return plus or minus


def pisot_verdict(p: List[Int]) -> Int:
    """1 certified Pisot, 0 certified not, -1 inconclusive; p monic and
    irreducible over Q."""
    var d = len(p) - 1
    if is_reciprocal(p):
        if d >= 3:
            return 0
        if d == 2:
            var t = p[1] if p[1] >= 0 else -p[1]
            return 1 if p[0] == 1 and t > 2 else 0
    try:
        return 1 if disc_zero_count(p) == d - 1 else 0
    except:
        return -1


# --- irreducibility -------------------------------------------------------


@fieldwise_init
struct IrreducibilityVerdict(Copyable, Movable):
    """`verdict` 1 with `witness` the certifying prime (0: by excluding rational
    roots, degree <= 3); 0 with `witness` an integer root; -1 inconclusive."""

    var verdict: Int
    var witness: Int


def _eval(p: List[Int], x: Int) raises -> Int:
    var acc = 0
    for i in range(len(p) - 1, -1, -1):
        acc = checked_add(checked_mul(acc, x), p[i])
    return acc


def _mod(a: Int, p: Int) -> Int:
    var r = a % p
    return r + p if r < 0 else r


def _reduce(a: List[Int], f: List[Int], p: Int) -> List[Int]:
    """`a mod (f, p)` for monic f."""
    var r = List[Int]()
    for c in a:
        r.append(_mod(c, p))
    var df = len(f) - 1
    while len(r) > df:
        var c = r[len(r) - 1]
        var shift = len(r) - 1 - df
        for i in range(df + 1):
            r[shift + i] = _mod(r[shift + i] - c * f[i], p)
        _ = r.pop()
    while len(r) > 1 and r[len(r) - 1] == 0:
        _ = r.pop()
    return r^


def _mulmod(a: List[Int], b: List[Int], f: List[Int], p: Int) -> List[Int]:
    var out = List[Int]()
    for _ in range(len(a) + len(b) - 1):
        out.append(0)
    for i in range(len(a)):
        for j in range(len(b)):
            out[i + j] = (out[i + j] + a[i] * b[j]) % p
    return _reduce(out, f, p)


def _powmod(a: List[Int], e: Int, f: List[Int], p: Int) -> List[Int]:
    var result: List[Int] = [1]
    var base = a.copy()
    var k = e
    while k > 0:
        if k % 2 == 1:
            result = _mulmod(result, base, f, p)
        base = _mulmod(base, base, f, p)
        k //= 2
    return result^


def _frobenius_power(f: List[Int], p: Int, k: Int) -> List[Int]:
    """`x^(p^k) mod (f, p)`."""
    var g: List[Int] = [0, 1]
    g = _reduce(g, f, p)
    for _ in range(k):
        g = _powmod(g, p, f, p)
    return g^


def _is_zero(a: List[Int]) -> Bool:
    for c in a:
        if c != 0:
            return False
    return True


def _gcd_degree(a0: List[Int], b0: List[Int], p: Int) -> Int:
    """Degree of `gcd(a, b)` over F_p (-1 for the zero polynomial)."""
    var a = a0.copy()
    var b = b0.copy()
    while not _is_zero(b):
        # a mod b, b not necessarily monic
        var lead = b[len(b) - 1]
        var inv = 1
        var e = p - 2
        var base = lead
        while e > 0:
            if e % 2 == 1:
                inv = inv * base % p
            base = base * base % p
            e //= 2
        var mb = List[Int]()
        for c in b:
            mb.append(c * inv % p)
        var r = _reduce(a, mb, p)
        a = b^
        b = r^
    while len(a) > 1 and a[len(a) - 1] == 0:
        _ = a.pop()
    return -1 if _is_zero(a) else len(a) - 1


def _x_minus(g: List[Int], p: Int) -> List[Int]:
    var out = g.copy()
    while len(out) < 2:
        out.append(0)
    out[1] = _mod(out[1] - 1, p)
    while len(out) > 1 and out[len(out) - 1] == 0:
        _ = out.pop()
    return out^


def irreducible_mod(f: List[Int], p: Int) -> Bool:
    """Rabin's test for a monic f over F_p."""
    var fp = List[Int]()
    for c in f:
        fp.append(_mod(c, p))
    var d = len(f) - 1
    if not _is_zero(_x_minus(_frobenius_power(fp, p, d), p)):
        return False
    for q in range(2, d + 1):
        if d % q != 0:
            continue
        var prime = True
        for r in range(2, q):
            if q % r == 0:
                prime = False
        if prime and _gcd_degree(fp, _x_minus(_frobenius_power(fp, p, d // q), p), p) != 0:
            return False
    return True


def irreducibility_verdict(f: List[Int]) raises -> IrreducibilityVerdict:
    """f monic of degree >= 1."""
    var d = len(f) - 1
    var c0 = f[0]
    if d > 1:
        if c0 == 0:
            return IrreducibilityVerdict(0, 0)
        var bound = c0 if c0 > 0 else -c0
        if bound > ROOT_CANDIDATE_CAP:
            return IrreducibilityVerdict(-1, 0)
        for k in range(1, bound + 1):
            if bound % k != 0:
                continue
            for r in [-k, k]:
                if _eval(f, r) == 0:
                    return IrreducibilityVerdict(0, r)
    if d <= 3:
        return IrreducibilityVerdict(1, 0)
    for p in range(2, PRIME_LIMIT):
        var prime = True
        for r in range(2, p):
            if r * r > p:
                break
            if p % r == 0:
                prime = False
        if prime and irreducible_mod(f, p):
            return IrreducibilityVerdict(1, p)
    return IrreducibilityVerdict(-1, 0)
