"""Print the cross-language battery that tools/cross_check.py recomputes with
the Python oracle. One line per fact, `shift|kind|word|value`, words as
digit strings; any disagreement fails closed."""

from sadic.balance import image_balance
from sadic.cocycle import cross_ratio_bound, first_positive_prefix, is_positive, positive_blocks, prefix_matrix
from sadic.directive import DirectiveShift, arnoux_rauzy, brun3, words_of_length

comptime MAX_LEN = 5


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


def main() raises:
    emit(arnoux_rauzy(2))
    emit(arnoux_rauzy(3))
    emit(brun3())
