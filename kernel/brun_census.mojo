"""Census of the primitive periodic points of the unordered Brun algorithm.

For every Lyndon word w of length 1..L with w^infinity admissible under BST23
(6.10), run the verdict pipeline of kernel/sadic/periodic.mojo on the
composite sigma_w: primitive -> irreducible -> Pisot -> balanced pair
algorithm. Prints one summary line per length and every word whose verdict is
neither a certified exclusion nor `bpa:terminates`.

Usage: mojo run -I . brun_census.mojo [d] [L] [max_states] [max_length]
(defaults 4 7 200000 20000). Specification: docs/sadic-g3-brun4-census.md
(d = 4) and docs/sadic-g6-brun-higher-census.md (d >= 5).
"""

from std.sys import argv

from sadic.periodic import brun_unordered, is_open_verdict, periodic_verdict, periodic_words, verdict_index, verdict_names

def joined(w: List[Int]) -> String:
    var s = String("")
    for i in range(len(w)):
        if i > 0:
            s += ","
        s += String(w[i])
    return s


def main() raises:
    var args = argv()
    var d = Int(args[1]) if len(args) > 1 else 4
    var max_len = Int(args[2]) if len(args) > 2 else 7
    var max_states = Int(args[3]) if len(args) > 3 else 200000
    var max_length = Int(args[4]) if len(args) > 4 else 20000
    var shift = brun_unordered(d)
    print("Brun d=" + String(d) + " periodic census, periods 1.." + String(max_len) + ", BPA budgets " + String(max_states) + " states, length " + String(max_length))
    var names = verdict_names()
    var stages = len(names)
    var total = List[Int]()
    for _ in range(stages):
        total.append(0)
    for n in range(1, max_len + 1):
        var counts = List[Int]()
        for _ in range(stages):
            counts.append(0)
        var words = periodic_words(shift, n)
        for w in words:
            var v = periodic_verdict(shift, w, max_states, max_length)
            var i = verdict_index(v)
            counts[i] += 1
            total[i] += 1
            if is_open_verdict(v):
                print("  open: period " + String(n) + " word " + joined(w) + " -> " + v)
        var line = "period " + String(n) + ": words " + String(len(words))
        for i in range(stages):
            line += "  " + names[i] + " " + String(counts[i])
        print(line)
    var line = "total:"
    for i in range(stages):
        line += "  " + names[i] + " " + String(total[i])
    print(line)
