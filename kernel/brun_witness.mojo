"""Search for Theorem C witnesses of the unordered Brun algorithm in dimension d.

A witness is a periodic admissible word w whose composite sigma_w is
primitive, has an irreducible Pisot characteristic polynomial, and on which
the balanced pair algorithm terminates (docs/charter-theorem-c-higher-d.md).

Stage `pip` enumerates one word per class under rotation and letter
permutation, among the words of period n using every letter (Theorem B: a
primitive composite uses every letter). Letters are numbered in order of
first appearance, so the word starts with beta_{0,1} and each label
introduces at most one new letter. The word is kept when no rotation
renumbers to a smaller label sequence. It prints every word whose composite
is primitive, irreducible and Pisot, with its characteristic polynomial.
Every decision is exact.

Stage `bpa` runs the balanced pair algorithm on one word with the given
budgets and prints the verdict and the size of the explored graph. Stage
`bpa-rev` runs it on the reversal of sigma_w: its subshift is the mirror
image of X_{sigma_w}, so one has pure discrete spectrum iff the other does.

Usage:
  mojo run -I . brun_witness.mojo pip d n
  mojo run -I . brun_witness.mojo bpa|bpa-rev d max_states max_length w_1 ... w_n
"""

from std.sys import argv

from substitution_dynamics.automaton import nonproductive_states
from substitution_dynamics.balanced_pair_algorithm import build_bounded
from sadic.cocycle import prefix_matrix
from sadic.periodic import brun_unordered, primitivity_exponent
from substitution_dynamics.substitution import Substitution
from sadic.spectrum import charpoly, irreducibility_verdict, pisot_verdict


def joined(w: List[Int]) -> String:
    var s = String("")
    for i in range(len(w)):
        if i > 0:
            s += ","
        s += String(w[i])
    return s


def label(i: Int, j: Int, d: Int) -> Int:
    """The label of beta_{i,j} in brun_unordered(d)."""
    return i * (d - 1) + (j if j < i else j - 1)


def normal_form(ps: List[Int], qs: List[Int], s: Int, d: Int) -> List[Int]:
    """Labels of the rotation by s, letters renumbered by first appearance."""
    var n = len(ps)
    var name = List[Int]()
    for _ in range(d):
        name.append(-1)
    var next = 0
    var out = List[Int]()
    for t in range(n):
        var p = ps[(t + s) % n]
        var q = qs[(t + s) % n]
        if name[p] < 0:
            name[p] = next
            next += 1
        if name[q] < 0:
            name[q] = next
            next += 1
        out.append(label(name[p], name[q], d))
    return out^


def is_canonical(ps: List[Int], qs: List[Int], d: Int) -> Bool:
    """No rotation renumbers to a smaller word, and w is not a proper power."""
    var own = normal_form(ps, qs, 0, d)
    var n = len(ps)
    for s in range(1, n):
        var r = normal_form(ps, qs, s, d)
        var equal = True
        for t in range(n):
            if r[t] != own[t]:
                equal = False
                if r[t] < own[t]:
                    return False
                break
        if equal:
            var power = True
            for t in range(n):
                if ps[(t + s) % n] != ps[t] or qs[(t + s) % n] != qs[t]:
                    power = False
                    break
            if power:
                return False
    return True


def reversal(sigma: Substitution) -> Substitution:
    var images = List[List[Int]]()
    for a in range(sigma.size):
        var img = sigma.image(a)
        var r = List[Int]()
        for i in range(len(img) - 1, -1, -1):
            r.append(img[i])
        images.append(r^)
    return Substitution(images^, sigma.size)


def classify(d: Int, ps: List[Int], qs: List[Int]) raises:
    var shift = brun_unordered(d)
    var w = List[Int]()
    for t in range(len(ps)):
        w.append(label(ps[t], qs[t], d))
    var m = prefix_matrix(shift, w)
    if primitivity_exponent(m, d) < 0:
        return
    var f = charpoly(m, d)
    if irreducibility_verdict(f).verdict != 1:
        return
    if pisot_verdict(f) != 1:
        return
    print("pip " + joined(w) + " | " + joined(f))


def extend(d: Int, n: Int, mut ps: List[Int], mut qs: List[Int], used: Int, mut count: Int) raises:
    var k = len(ps)
    if d - used > n - k:
        return
    if k == n:
        # cyclic admissibility back to beta_{0,1}
        var p = ps[k - 1]
        var q = qs[k - 1]
        if not ((p == 0 and q == 1) or q == 0):
            return
        if used == d and is_canonical(ps, qs, d):
            count += 1
            classify(d, ps, qs)
        return
    var p = ps[k - 1]
    var q = qs[k - 1]
    # repeat the label
    ps.append(p)
    qs.append(q)
    extend(d, n, ps, qs, used, count)
    _ = ps.pop()
    _ = qs.pop()
    # move to beta_{q,r}: an existing letter, or the next new one
    var top = used + 1 if used < d else used
    for r in range(top):
        if r == q:
            continue
        ps.append(q)
        qs.append(r)
        extend(d, n, ps, qs, used + 1 if r == used else used, count)
        _ = ps.pop()
        _ = qs.pop()


def main() raises:
    var args = argv()
    var mode = args[1]
    var d = Int(args[2])
    if mode == "pip":
        var n = Int(args[3])
        var ps: List[Int] = [0]
        var qs: List[Int] = [1]
        var count = 0
        extend(d, n, ps, qs, 2, count)
        print("classes " + String(count) + " (d=" + String(d) + ", period " + String(n) + ")")
    elif mode == "bpa" or mode == "bpa-rev":
        var states = Int(args[3])
        var length = Int(args[4])
        var w = List[Int]()
        for i in range(5, len(args)):
            w.append(Int(args[i]))
        var sigma = brun_unordered(d).composite(w)
        if mode == "bpa-rev":
            sigma = reversal(sigma)
        var b = build_bounded(sigma, states, length)
        var verdict = String("capped")
        if b.complete():
            verdict = "terminates" if len(nonproductive_states(b.graph)) == 0 else "fails"
        print(mode + " " + joined(w) + " | " + verdict + " states " + String(b.graph.size()) + " longest " + String(b.longest_state))
    else:
        raise Error("mode must be pip, bpa or bpa-rev")
