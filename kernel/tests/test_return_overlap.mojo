"""Finite regressions for T1-prime's positive-suffix and overlap ingredients.

The general statement is proved in docs/t1-uniform-overlap-finiteness.md.
These tests do not certify an infinite language's balance or recurrence.
"""

from std.testing import assert_equal, assert_raises, assert_true
from mojo_smoke.claims import require_contract
from sadic.cocycle import matmul, prefix_matrix
from sadic.directive import arnoux_rauzy, brun3, words_of_length
from sadic.overlap import positive_suffix_ratio, return_overlap_bound


def test_literals() raises:
    var two: List[Int] = [2, 1, 1, 1]
    var fractional: List[Int] = [2, 3, 4, 5]
    var ratio = positive_suffix_ratio(two, 2)
    assert_equal(ratio.num, 2)
    assert_equal(ratio.den, 1)
    ratio = positive_suffix_ratio(fractional, 2)
    assert_equal(ratio.num, 3)
    assert_equal(ratio.den, 2)
    assert_equal(return_overlap_bound(fractional, 2, 0), 2)
    assert_equal(return_overlap_bound(fractional, 2, 1), 6)
    assert_equal(return_overlap_bound(fractional, 2, 2), 10)
    var one: List[Int] = [7]
    assert_equal(return_overlap_bound(one, 1, 0), 1)
    assert_equal(return_overlap_bound(one, 1, 3), 7)
    var ar_word: List[Int] = [0, 1, 2]
    var brun_word: List[Int] = [2, 2, 2, 2]
    assert_equal(positive_suffix_ratio(prefix_matrix(arnoux_rauzy(3), ar_word), 3).num, 2)
    assert_equal(positive_suffix_ratio(prefix_matrix(brun3(), brun_word), 3).num, 3)


def test_refusals() raises:
    var empty = List[Int]()
    var short: List[Int] = [1, 2]
    var zero: List[Int] = [1, 0, 1, 1]
    var negative: List[Int] = [-1]
    for matrix in [empty.copy(), short.copy(), zero.copy()]:
        with assert_raises():
            _ = positive_suffix_ratio(matrix, 2)
    with assert_raises():
        _ = positive_suffix_ratio(empty, 0)
    with assert_raises():
        _ = positive_suffix_ratio(negative, 1)
    var ones: List[Int] = [1, 1, 1, 1]
    with assert_raises():
        _ = return_overlap_bound(ones, 2, -1)
    with assert_raises():
        _ = return_overlap_bound(ones, 2, Int.MAX)
    var singleton: List[Int] = [1]
    with assert_raises():
        _ = return_overlap_bound(singleton, 1, Int.MAX // 2 + 1)
    with assert_raises():
        _ = positive_suffix_ratio(ones, Int.MAX)
    # Ratio comparisons and scaling must also refuse overflowing intermediates.
    var huge: List[Int] = [Int.MAX, 1, Int.MAX - 1, Int.MAX - 2]
    with assert_raises():
        _ = positive_suffix_ratio(huge, 2)
    var large_ratio: List[Int] = [Int.MAX, 1, 1, 1]
    with assert_raises():
        _ = return_overlap_bound(large_ratio, 2, 1)


def test_suffix_order_and_all_left_rows() raises:
    var block: List[Int] = [2, 1, 1, 1]
    var shear: List[Int] = [1, 1000, 0, 1]
    var suffix = matmul(shear, block, 2)
    var prefix = matmul(block, shear, 2)
    var a = suffix[0] + suffix[2]
    var b = suffix[1] + suffix[3]
    assert_true(max(a, b) <= 2 * min(a, b))
    a = prefix[0] + prefix[2]
    b = prefix[1] + prefix[3]
    assert_true(max(a, b) > 2 * min(a, b))
    for entries in words_of_length(3, 4):
        var matrix = List[Int]()
        for x in entries:
            matrix.append(x + 1)
        var r = positive_suffix_ratio(matrix, 2)
        for weights in words_of_length(5, 2):
            if weights[0] == 0 and weights[1] == 0:
                continue
            a = weights[0] * matrix[0] + weights[1] * matrix[2]
            b = weights[0] * matrix[1] + weights[1] * matrix[3]
            assert_true(max(a, b) * r.den <= min(a, b) * r.num)


def count(word: List[Int], start: Int, end: Int, letter: Int) -> Int:
    var total = 0
    for i in range(start, end):
        if word[i] == letter:
            total += 1
    return total


def joint_balance(x: List[Int], y: List[Int]) -> Int:
    var best = 0
    for length in range(1, max(len(x), len(y)) + 1):
        for a in range(2):
            var hi = 0
            var lo = length
            for word in [x.copy(), y.copy()]:
                for start in range(len(word) - length + 1):
                    var value = count(word, start, start + length, a)
                    hi = max(hi, value)
                    lo = min(lo, value)
            best = max(best, hi - lo)
    return best


def test_literal_overlaps() raises:
    var block: List[Int] = [2, 1, 1, 1]
    var words = List[List[Int]]()
    for n in range(1, 4):
        for w in words_of_length(2, n):
            words.append(w.copy())
    var weights: List[List[Int]] = [[1, 0], [0, 1], [1, 1], [1000, 1]]
    for x in words:
        for y in words:
            var bound = return_overlap_bound(block, 2, joint_balance(x, y))
            var u = x.copy()
            var v = y.copy()
            for a in y:
                u.append(a)
            for a in x:
                v.append(a)
            for w in weights:
                var lengths = [2 * w[0] + w[1], w[0] + w[1]]
                var top: List[Int] = [0]
                var bottom: List[Int] = [0]
                for i in range(len(u)):
                    top.append(top[i] + lengths[u[i]])
                    bottom.append(bottom[i] + lengths[v[i]])
                for p in range(len(u)):
                    for q in range(len(v)):
                        if max(top[p], bottom[q]) >= min(top[p + 1], bottom[q + 1]):
                            continue
                        for a in range(2):
                            var delta = count(v, 0, q, a) - count(u, 0, p, a)
                            assert_true(abs(delta) <= bound)


def main() raises:
    test_literals()
    test_refusals()
    test_suffix_order_and_all_left_rows()
    test_literal_overlaps()
    require_contract("PositiveSuffixLengthRatio")
    require_contract("ConditionalReturnOverlapBox")
    print("return-time overlap ingredients: all assertions passed")
