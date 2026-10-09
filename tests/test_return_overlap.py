"""Exact finite checks of the ingredients of the return-time overlap bound.

These do not certify balance of an infinite language or PRICE recurrence.
"""

from fractions import Fraction
from itertools import product

import pytest

from sadic_reference import arnoux_rauzy, brun3, image, matmul, prefix_matrix
from sadic_reference.overlap import positive_suffix_ratio, return_overlap_bound


def _lengths(weights, matrix):
    return tuple(sum(w * x for w, x in zip(weights, col)) for col in zip(*matrix))


def _joint_balance(x, y, d):
    best = 0
    for length in range(1, max(len(x), len(y)) + 1):
        for a in range(d):
            counts = [word[start:start + length].count(a)
                      for word in (x, y) for start in range(len(word) - length + 1)]
            best = max(best, max(counts) - min(counts))
    return best


def _overlap_vectors(x, y, lengths):
    """Independent literal interval oracle, using every pair of tile positions."""
    u, v = x + y, y + x
    top = [0]
    bottom = [0]
    for a in u:
        top.append(top[-1] + lengths[a])
    for a in v:
        bottom.append(bottom[-1] + lengths[a])
    for p in range(len(u)):
        for q in range(len(v)):
            if max(top[p], bottom[q]) < min(top[p + 1], bottom[q + 1]):
                yield tuple(v[:q].count(a) - u[:p].count(a) for a in range(len(lengths)))


def test_suffix_ratio_and_conditional_bound_literals():
    assert positive_suffix_ratio(((2, 1), (1, 1))) == Fraction(2)
    assert positive_suffix_ratio(((2, 3), (4, 5))) == Fraction(3, 2)
    assert return_overlap_bound(((2, 3), (4, 5)), 0) == 2
    assert return_overlap_bound(((2, 3), (4, 5)), 1) == 6
    assert return_overlap_bound(((2, 3), (4, 5)), 2) == 10
    assert return_overlap_bound(((7,),), 0) == 1
    assert return_overlap_bound(((7,),), 3) == 7
    # Python is arbitrary precision; the Mojo twin refuses this overflow.
    assert return_overlap_bound(((1, 1), (1, 1)), 2**63 - 1) == 3 * (2**63 - 1) + 1


def test_suffix_controls_every_nonnegative_left_row_and_is_sharp():
    for entries in product(range(1, 4), repeat=4):
        matrix = (entries[:2], entries[2:])
        ratio = positive_suffix_ratio(matrix)
        extrema = []
        for weights in product(range(5), repeat=2):
            if not any(weights):
                continue
            lengths = _lengths(weights, matrix)
            assert Fraction(max(lengths), min(lengths)) <= ratio
            if weights in ((1, 0), (0, 1)):
                extrema.append(Fraction(max(lengths), min(lengths)))
        assert max(extrema) == ratio


def test_positive_block_must_be_a_suffix_not_a_prefix():
    block = ((2, 1), (1, 1))
    shear = ((1, 1000), (0, 1))
    ratio = positive_suffix_ratio(block)
    after_suffix = _lengths((1, 1), matmul(shear, block))
    after_prefix = _lengths((1, 1), matmul(block, shear))
    assert Fraction(max(after_suffix), min(after_suffix)) <= ratio
    assert Fraction(max(after_prefix), min(after_prefix)) > ratio


@pytest.mark.parametrize("matrix", [(), ((),), ((1, 2),), ((1, 0), (1, 1)), ((-1,),)])
def test_rejects_nonpositive_or_nonsquare_matrices(matrix):
    with pytest.raises(ValueError):
        positive_suffix_ratio(matrix)
    with pytest.raises(ValueError):
        return_overlap_bound(matrix, 1)


def test_rejects_negative_balance():
    with pytest.raises(ValueError):
        return_overlap_bound(((1,),), -1)


def test_literal_overlaps_fit_the_conditional_box():
    # Exhaust unequal image lengths, both overlap orientations, and tight rows.
    block = ((2, 1), (1, 1))
    words = [word for n in range(1, 4) for word in product(range(2), repeat=n)]
    for x, y in product(words, repeat=2):
        c = _joint_balance(x, y, 2)
        bound = return_overlap_bound(block, c)
        for weights in ((1, 0), (0, 1), (1, 1), (1000, 1)):
            for vec in _overlap_vectors(x, y, _lengths(weights, block)):
                assert max(map(abs, vec)) <= bound


def test_arnoux_rauzy_and_brun_images_with_skew_left_lengths():
    for shift, positive_word in ((arnoux_rauzy(3), (0, 1, 2)), (brun3(), (2, 2, 2, 2))):
        block = prefix_matrix(shift, positive_word)
        for n in range(1, 4):
            for word in product(range(shift.labels), repeat=n):
                for a in range(3):
                    for b in range(a + 1, 3):
                        x, y = image(shift, word, a), image(shift, word, b)
                        bound = return_overlap_bound(block, _joint_balance(x, y, 3))
                        for weights in ((1, 1, 1), (1000, 1, 1), (1, 1000, 1)):
                            for vec in _overlap_vectors(x, y, _lengths(weights, block)):
                                assert max(map(abs, vec)) <= bound
