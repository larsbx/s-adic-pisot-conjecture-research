"""Exact reference for the finite positive-suffix bound used by T1-prime.

This computes a conditional box from a supplied balance constant. It does
not verify balance of an infinite language or select PRICE return depths.
"""

from fractions import Fraction

from sadic_reference import Matrix


def positive_suffix_ratio(matrix: Matrix) -> Fraction:
    """The sharp bound on max(w B) / min(w B) for nonzero w >= 0.

The oracle enumerates ordered column pairs using arbitrary-precision ratios.
The canonical Mojo implementation instead compares each row's extrema.
"""
    d = len(matrix)
    if d < 1 or any(len(row) != d for row in matrix):
        raise ValueError("positive suffix needs a nonempty square matrix")
    if any(x <= 0 for row in matrix for x in row):
        raise ValueError("positive suffix needs a strictly positive matrix")
    return max(Fraction(row[a], row[b])
               for row in matrix for a in range(d) for b in range(d))


def return_overlap_bound(matrix: Matrix, balance_constant: int) -> int:
    """C + ceil(R_B (1 + d C)), conditional on the supplied C-balance."""
    if balance_constant < 0:
        raise ValueError("balance constant must be nonnegative")
    value = balance_constant + positive_suffix_ratio(matrix) * (1 + len(matrix) * balance_constant)
    return -(-value.numerator // value.denominator)
