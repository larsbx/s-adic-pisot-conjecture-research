"""Checked finite ingredients of the return-time overlap bound (T1-prime).

The supplied matrix must be the positive suffix at the selected depth and
the supplied C must be justified separately. These routines certify neither
an infinite language's balance nor PRICE recurrence. Overflow raises and
makes a computation inconclusive. Reference: sadic_reference/overlap.py.
"""

from finite_exact.checked_int import checked_add, checked_mul
from sadic.cocycle import Ratio


def positive_suffix_ratio(matrix: List[Int], d: Int) raises -> Ratio:
    """R_B = max_i max_a B_ia / min_b B_ib, in lowest terms.

If w >= 0 is nonzero, then (w B)_a <= R_B (w B)_b for all a, b.
Strict positivity is required; a positive prefix has no such guarantee.
"""
    if d <= 0:
        raise Error("positive suffix needs positive dimension")
    if len(matrix) != checked_mul(d, d):
        raise Error("positive suffix needs a d x d matrix")
    var best = Ratio(1, 1)
    for i in range(d):
        var hi = 0
        var lo = Int.MAX
        for a in range(d):
            var value = matrix[i * d + a]
            if value <= 0:
                raise Error("positive suffix needs a strictly positive matrix")
            hi = max(hi, value)
            lo = min(lo, value)
        if checked_mul(hi, best.den) > checked_mul(best.num, lo):
            best = Ratio(hi, lo)
    var x = best.num
    var y = best.den
    while y != 0:
        var remainder = x % y
        x = y
        y = remainder
    return Ratio(best.num // x, best.den // x)


def return_overlap_bound(matrix: List[Int], d: Int, balance_constant: Int) raises -> Int:
    """C + ceil(R_B (1 + d C)), conditional on C-balance at the depth."""
    if balance_constant < 0:
        raise Error("balance constant must be nonnegative")
    var ratio = positive_suffix_ratio(matrix, d)
    var scale = checked_add(1, checked_mul(d, balance_constant))
    var numerator = checked_mul(ratio.num, scale)
    var rounded = numerator // ratio.den
    if numerator % ratio.den != 0:
        rounded = checked_add(rounded, 1)
    return checked_add(balance_constant, rounded)
