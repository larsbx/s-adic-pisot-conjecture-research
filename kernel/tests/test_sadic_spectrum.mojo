"""Regressions for kernel/sadic/{spectrum,periodic}.mojo
(docs/sadic-kernel-g2-spectrum.md). Literals are pinned independently by
tests/test_sadic_spectrum.py against the Python oracle."""

from std.testing import assert_equal, assert_false, assert_raises, assert_true

from mojo_smoke.claims import require_claim
from substitution_dynamics.substitution import Substitution
from sadic.cocycle import prefix_matrix
from sadic.directive import DirectiveShift, words_of_length
from sadic.periodic import (
    BPA_CAPPED, BPA_FAILS, BPA_TERMINATES, brun_unordered, bpa_verdict, is_lyndon,
    periodic_admissible, periodic_verdict, periodic_words, primitivity_exponent,
)
from sadic.spectrum import charpoly, disc_zero_count, irreducibility_verdict, pisot_verdict


def same(a: List[Int], b: List[Int]) -> Bool:
    if len(a) != len(b):
        return False
    for i in range(len(a)):
        if a[i] != b[i]:
            return False
    return True


def tau() -> List[Int]:
    return [0, 4, 8, 9]


def test_charpoly() raises:
    var fib: List[Int] = [1, 1, 1, 0]
    var trib: List[Int] = [1, 1, 1, 1, 0, 0, 0, 1, 0]
    var e1: List[Int] = [-1, -1, 1]
    var e2: List[Int] = [-1, -1, -1, 1]
    var e3: List[Int] = [1, -4, 6, -5, 1]
    assert_true(same(charpoly(fib, 2), e1))
    assert_true(same(charpoly(trib, 3), e2))
    assert_true(same(charpoly(prefix_matrix(brun_unordered(4), tau()), 4), e3))
    var extreme: List[Int] = [Int.MIN]
    with assert_raises():
        _ = charpoly(extreme, 1)  # -Int.MIN is not representable: refuse


def test_disc_zero_count() raises:
    var cases: List[List[Int]] = [[-1, -1, 1], [-1, -1, 0, 1], [-1, -1, -1, 1], [-1, -1, -1, -1, 1], [-2, 0, 0, 1], [-2, -2, -1, 1]]
    var counts: List[Int] = [1, 2, 2, 3, 0, 2]
    for i in range(len(cases)):
        assert_equal(disc_zero_count(cases[i]), counts[i])
    var singular: List[List[Int]] = [[1, -1, -1, -1, 1], [1, 0, 1], [1, -3, 1]]
    for p in singular:
        with assert_raises():
            _ = disc_zero_count(p)


def test_pisot_verdict() raises:
    var polys: List[List[Int]] = [[-1, -1, -1, 1], [1, -4, 6, -5, 1], [1, -3, 1], [1, -1, 1], [1, -1, -1, -1, 1], [-2, 0, 0, 1]]
    var verdicts: List[Int] = [1, 1, 1, 0, 0, 0]
    for i in range(len(polys)):
        assert_equal(pisot_verdict(polys[i]), verdicts[i])


def test_irreducibility_verdict() raises:
    var polys: List[List[Int]] = [[-1, -1, -1, 1], [-1, -1, -1, -1, 1], [1, -4, 6, -5, 1], [-1, 0, 1], [0, 1, 1], [1, 0, 0, 0, 1]]
    var verdicts: List[Int] = [1, 1, 1, 0, 0, -1]
    var witnesses: List[Int] = [0, 2, 2, -1, 0, 0]
    for i in range(len(polys)):
        var v = irreducibility_verdict(polys[i])
        assert_equal(v.verdict, verdicts[i])
        assert_equal(v.witness, witnesses[i])


def test_primitivity_exponent() raises:
    var wielandt: List[Int] = [0, 1, 0, 0, 0, 1, 1, 1, 0]
    var swap: List[Int] = [0, 1, 1, 0]
    assert_equal(primitivity_exponent(wielandt, 3), 5)
    assert_equal(primitivity_exponent(swap, 2), -1)
    assert_equal(primitivity_exponent(prefix_matrix(brun_unordered(4), tau()), 4), 2)
    # only the zero pattern is powered: huge entries cannot overflow
    var huge: List[Int] = [Int.MAX, 0, 0, Int.MAX]
    assert_equal(primitivity_exponent(huge, 2), -1)


def test_brun_unordered() raises:
    var b = brun_unordered(4)
    assert_equal(b.labels(), 12)
    var t = b.composite(tau())
    var expected: List[List[Int]] = [[0, 1, 2, 3, 0], [0, 1], [0, 1, 2], [0, 1, 2, 3]]
    for a in range(4):
        assert_true(same(t.images[a], expected[a]))
    assert_true(periodic_admissible(b, tau()))
    var forbidden: List[Int] = [0, 8]
    assert_false(periodic_admissible(b, forbidden))
    var counts: List[Int] = [12, 6, 20, 60, 204]
    for n in range(1, 6):
        assert_equal(len(periodic_words(b, n)), counts[n - 1])
    var lyndon: List[Int] = [0, 1]
    var rotated: List[Int] = [1, 0]
    var power: List[Int] = [0, 0]
    assert_true(is_lyndon(lyndon))
    assert_false(is_lyndon(rotated))
    assert_false(is_lyndon(power))


def test_bpa_verdict() raises:
    var fib: List[List[Int]] = [[0, 1], [0]]
    var tm: List[List[Int]] = [[0, 1], [1, 0]]
    assert_equal(bpa_verdict(Substitution.checked(fib), 20000, 400), BPA_TERMINATES)
    assert_equal(bpa_verdict(Substitution.checked(tm), 20000, 400), BPA_FAILS)
    assert_equal(bpa_verdict(Substitution.checked(fib), 1, 400), BPA_CAPPED)
    # BST23 section 6.5: the Brun d = 4 periodic point tau
    assert_equal(periodic_verdict(brun_unordered(4), tau(), 20000, 2000), "bpa:terminates")
    require_claim("BrunFourPeriodicPointBPA")


def digits(w: List[Int]) -> String:
    var out = String("")
    for x in w:
        out += String(x)
    return out


def psc_corpus_lines() raises -> List[String]:
    """Data lines of tests/data/psc-pip-corpus.txt (PSC's pinned corpus; the
    pytest twin also checks their digest)."""
    var out = List[String]()
    with open("../tests/data/psc-pip-corpus.txt", "r") as f:
        for line in f.read().split("\n"):
            if line.byte_length() > 0 and not line.startswith("#"):
                out.append(String(line))
    return out^


def test_iota_embedding_reproduces_the_psc_corpus() raises:
    # Per instance, in PSC's enumeration order: each substitution is embedded
    # as the periodic directive sequence of a one-label full shift and certified
    # through the S-adic verdicts; the result is PSC's pinned corpus line by line.
    var words = List[List[Int]]()
    for n in range(1, 4):
        for w in words_of_length(3, n):
            words.append(w.copy())
    var expected = psc_corpus_lines()
    var certified = List[String]()
    var one: List[Int] = [0]
    for a in words:
        for b in words:
            for c in words:
                var images: List[List[Int]] = [a.copy(), b.copy(), c.copy()]
                var subs = List[Substitution]()
                subs.append(Substitution.checked(images))
                var shift = DirectiveShift.full("iota", subs)
                var m = prefix_matrix(shift, one)
                if primitivity_exponent(m, 3) < 0:
                    continue
                var f = charpoly(m, 3)
                if irreducibility_verdict(f).verdict == 1 and pisot_verdict(f) == 1:
                    certified.append(digits(a) + "|" + digits(b) + "|" + digits(c))
    assert_equal(len(expected), 4554)
    assert_equal(len(certified), len(expected))
    for i in range(len(expected)):
        assert_equal(certified[i], expected[i])
    require_claim("IotaEmbeddingPSCCorpus")


def main() raises:
    test_charpoly()
    test_disc_zero_count()
    test_pisot_verdict()
    test_irreducibility_verdict()
    test_primitivity_exponent()
    test_brun_unordered()
    test_bpa_verdict()
    test_iota_embedding_reproduces_the_psc_corpus()
    print("sadic spectrum and periodic layer: all assertions passed")
