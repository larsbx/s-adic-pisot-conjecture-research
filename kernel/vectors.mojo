"""Print the cross-language battery that tools/cross_check.py recomputes with
the Python oracle. One line per fact, `shift|kind|word|value`, words as
digit strings; any disagreement fails closed."""

from sadic.balance import image_balance
from sadic.cocycle import cross_ratio_bound, first_positive_prefix, is_positive, positive_blocks, prefix_matrix
from sadic.directive import DirectiveShift, arnoux_rauzy, brun3, words_of_length
from sadic.periodic import brun_unordered, periodic_verdict, periodic_words, primitivity_exponent
from sadic.spectrum import charpoly, irreducibility_verdict, pisot_verdict

comptime MAX_LEN = 5
comptime SPECTRAL_LEN = 4
comptime PERIODIC_LEN = 6
comptime BPA_STATES = 20000
comptime BPA_LENGTH = 2000


def digits(w: List[Int]) -> String:
    var s = String("")
    for x in w:
        s += String(x)
    return s


def joined(m: List[Int]) -> String:
    var s = String("")
    for i in range(len(m)):
        if i > 0:
            s += ","
        s += String(m[i])
    return s


def emit(shift: DirectiveShift) raises:
    var d = shift.size()
    for n in range(MAX_LEN + 1):
        for w in words_of_length(shift.labels(), n):
            var m = prefix_matrix(shift, w)
            var key = shift.name + "|"
            print(key + "matrix|" + digits(w) + "|" + joined(m))
            print(key + "first-positive|" + digits(w) + "|" + String(first_positive_prefix(shift, w)))
            if is_positive(m):
                var r = cross_ratio_bound(m, d)
                print(key + "cross-ratio|" + digits(w) + "|" + String(r.num) + "/" + String(r.den))
            for a in range(d):
                print(key + "image-balance-" + String(a) + "|" + digits(w) + "|" + String(image_balance(shift, w, a)))
    for w in positive_blocks(shift, MAX_LEN):
        print(shift.name + "|positive-block|" + digits(w) + "|1")


def emit_spectral(shift: DirectiveShift) raises:
    var d = shift.size()
    for n in range(1, SPECTRAL_LEN + 1):
        for w in words_of_length(shift.labels(), n):
            var m = prefix_matrix(shift, w)
            var key = shift.name + "|"
            var f = charpoly(m, d)
            print(key + "charpoly|" + digits(w) + "|" + joined(f))
            print(key + "primitivity|" + digits(w) + "|" + String(primitivity_exponent(m, d)))
            var irr = irreducibility_verdict(f)
            print(key + "irreducible|" + digits(w) + "|" + String(irr.verdict) + "," + String(irr.witness))
            if irr.verdict == 1:
                print(key + "pisot|" + digits(w) + "|" + String(pisot_verdict(f)))


def emit_periodic(shift: DirectiveShift) raises:
    for n in range(1, PERIODIC_LEN + 1):
        for w in periodic_words(shift, n):
            print(shift.name + "|periodic|" + joined(w) + "|" + periodic_verdict(shift, w, BPA_STATES, BPA_LENGTH))


def main() raises:
    emit(arnoux_rauzy(2))
    emit(arnoux_rauzy(3))
    emit(brun3())
    emit_spectral(arnoux_rauzy(3))
    emit_spectral(brun3())
    emit_periodic(brun_unordered(4))
