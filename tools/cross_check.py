#!/usr/bin/env python3
"""Compare the Mojo vector battery (kernel/vectors.mojo) with the Python oracle.

Usage: cross_check.py MOJO_OUTPUT

Recomputes every line of the battery with `reference/sadic_reference` and
fails closed on any difference, missing line or extra line.
"""

from __future__ import annotations

import sys
from itertools import product
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "reference"))

from sadic_reference.periodic import brun_unordered, periodic_verdict, periodic_words  # noqa: E402
from sadic_reference.spectrum import charpoly, irreducibility_verdict, pisot_verdict, primitivity_exponent  # noqa: E402
from sadic_reference import (  # noqa: E402
    arnoux_rauzy,
    brun3,
    cross_ratio_bound,
    first_positive_prefix,
    image_balance,
    is_positive,
    positive_blocks,
    prefix_matrix,
)

MAX_LEN = 5
SPECTRAL_LEN = 4
PERIODIC_LEN = 6
BPA_STATES = 20000
BPA_LENGTH = 2000


def battery() -> list[str]:
    out = []
    for shift in (arnoux_rauzy(2), arnoux_rauzy(3), brun3()):
        key = shift.name
        for n in range(MAX_LEN + 1):
            for w in product(range(shift.labels), repeat=n):
                digits = "".join(map(str, w))
                m = prefix_matrix(shift, w)
                out.append(f"{key}|matrix|{digits}|" + ",".join(str(x) for row in m for x in row))
                out.append(f"{key}|first-positive|{digits}|{first_positive_prefix(shift, w)}")
                if is_positive(m):
                    r = cross_ratio_bound(m)
                    out.append(f"{key}|cross-ratio|{digits}|{r.numerator}/{r.denominator}")
                for a in range(shift.size):
                    out.append(f"{key}|image-balance-{a}|{digits}|{image_balance(shift, w, a)}")
        out += [f"{key}|positive-block|{''.join(map(str, w))}|1" for w in positive_blocks(shift, MAX_LEN)]
    for shift in (arnoux_rauzy(3), brun3()):
        key = shift.name
        for n in range(1, SPECTRAL_LEN + 1):
            for w in product(range(shift.labels), repeat=n):
                digits = "".join(map(str, w))
                m = prefix_matrix(shift, w)
                f = charpoly(m)
                out.append(f"{key}|charpoly|{digits}|" + ",".join(map(str, f)))
                out.append(f"{key}|primitivity|{digits}|{primitivity_exponent(m)}")
                verdict, witness = irreducibility_verdict(f)
                out.append(f"{key}|irreducible|{digits}|{verdict},{witness}")
                if verdict == 1:
                    out.append(f"{key}|pisot|{digits}|{pisot_verdict(f)}")
    shift = brun_unordered(4)
    for n in range(1, PERIODIC_LEN + 1):
        for w in periodic_words(shift, n):
            verdict = periodic_verdict(shift, w, BPA_STATES, BPA_LENGTH)
            out.append(f"{shift.name}|periodic|" + ",".join(map(str, w)) + f"|{verdict}")
    return out


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print(__doc__)
        return 2
    mojo = [line for line in Path(argv[1]).read_text(encoding="utf-8").splitlines() if "|" in line]
    oracle = battery()
    if mojo == oracle:
        print(f"OK: {len(oracle)} facts agree between the Mojo kernel and the Python oracle")
        return 0
    only_mojo = sorted(set(mojo) - set(oracle))
    only_oracle = sorted(set(oracle) - set(mojo))
    print(f"cross-language disagreement: {len(only_mojo)} Mojo-only, {len(only_oracle)} oracle-only lines")
    for line in only_mojo[:10]:
        print("  mojo:  ", line)
    for line in only_oracle[:10]:
        print("  oracle:", line)
    if not only_mojo and not only_oracle:
        print("  same facts in a different order")
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
