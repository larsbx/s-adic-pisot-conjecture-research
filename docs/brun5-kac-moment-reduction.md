# Brun5: Kac reduction of the omitted return moment

Status: conditional measure-theoretic reduction and exact certificate design.
Candidate I5 remains open. No rational norm forms, certified return-cell
masses, or negative signed budget are supplied by this note. Lemma R5 and
Theorems C/C′ retain their existing statuses.

## 1. Identity, including noninvertible maps

Let T preserve a finite positive measure ν on X, let Y be measurable with
ν(Y)>0, and let τ be its first positive return time. Write
H = union_{n>=0} T^{-n}Y. Then

    integral_Y τ dν = ν(H) <= ν(X).

This statement does not require invertibility or ergodicity. Here is a
proof avoiding an unverified natural-extension import. Put B_0=X and
B_n=intersection_{j=0}^{n-1} T^{-j}(X\Y) for n>=1. Invariance gives
ν(Y intersect {τ>n})=ν(B_n)-ν(B_{n+1}) for n>=0: for n>=1 subtract
B_{n+1} from T^{-1}B_n. The layer-cake sum telescopes to
ν(X)-ν(intersection_n B_n)=ν(H). In particular τ is finite a.e. on Y
and integrable. If T is ergodic, H has full measure modulo ν, so equality
with ν(X) follows. Equality is not needed for the upper bound below.

For disjoint measurable cells P_i contained in Y, with τ=r_i on P_i,
E=Y\union_i P_i, and l_i<=ν(P_i), this proves

    integral_E τ dν <= C_hi - sum_i r_i l_i,

where C_hi is any certified upper bound for ν(X). An invariant measure
of the induced map alone is insufficient: it must be the restriction of
the ambient invariant measure, with the same scale as C_hi and l_i.
Reject inputs with sum_i r_i l_i>C_hi; do not clamp a negative residual
to zero. For fixed C_hi and only these lower bounds, this is the sharp
algebraic residual bound. Additional certified upper tail bounds can be
intersected by taking their minimum.

For μ=ν/ν(X), the ambient bound is 1. For μ_Y=μ|Y/μ(Y), the total return
moment is 1/μ(Y) in the full-saturation case, not 1. Thus an unknown common
normalization cancels from a signed test only if its ambient mass is
included consistently; substituting 1 into unnormalized I5 is invalid.

## 2. Ordered density and the labelled lift

Use the ordered maximum-coordinate chart
O={1>=x1>=x2>=x3>=x4>=0} of Lemma D and ν_o=ρ dx. With t=x1,
the three-dimensional slice has volume t^3/6. Lemma D gives

    1/768 <= C_o=ν_o(O) <= 1/3,

because 6/(256 t)<=ρ<=6/t and integral_0^1 t^2 dt=1/3.
The singular vertex is integrable. More usefully, its entire cap x1<ε
has mass at most ε^3/3 for rational 0<ε<=1. No infinite supremum is used.

Retain coordinate labels: off the tie hyperplanes an unordered point is
represented uniquely by (x,π), π in S_5, where its maximum is 1. Sorting
one Brun subtraction gives the ordered Brun map and a permutation update
π -> π p(x), with p determined by the ordered point. Consequently the
product measure

    ν_u = ν_o times uniform counting measure on S_5

is invariant: each fibre update is a bijection and preserves the uniform
law, and the base preserves ν_o. Its ambient mass is C_o, not 120 C_o.
This construction uses only the permutation-equivariance of subtracting
the second-largest coordinate from the largest and rescaling. Tie faces
are null for the absolutely continuous density. If instead counting each
chamber with weight 1, multiply ALL masses and C_hi by 120; C_hi is then
40. Mixing the two conventions is an invalid certificate.

For the BST23 simplex chart y, on chamber π set

    y = π(1,x1,x2,x3,x4)/(1+x1+x2+x3+x4).

Its absolute coordinate Jacobian, using four independent simplex
coordinates, is (1+sum x)^(-5). Thus integrate in the ordered x chart
with weight 1/120, or use density ρ(x)(1+sum x)^5/120 in the simplex
chart. Do not multiply by the forward Jacobian twice. Sorting forgets
labels: the first return to the projected ordered set need not equal the
first return to the labelled cylinder Y=[v]. Retain π in all return tests.
Likewise, the ordered transverse chart and the unordered cocycle require
explicit permutation/chart conjugacies before applying I5's norm bounds;
this measure construction alone supplies no operator-norm certificate.

BST23 §6.5 (arXiv:2005.13038v3, p.40, equations (6.9)–(6.10)) states,
before restricting to d=4, that unordered Brun has an ergodic invariant
probability equivalent to Lebesgue measure. Its identification with the
normalized lifted density must be made explicit when importing the a.e.
conclusion. Ordered ergodicity by itself does not prove ergodicity of a
finite permutation extension. The upper moment bound above needs only
invariance; global negative integrated budgets still need ergodicity or
componentwise negative budgets to imply a.e. negative averages.

## 3. Exact mass certificate and sign test

For each labelled cell, retain the r+7-symbol itinerary, fixed input/output
norm states, and exclusion of earlier occurrences of v. Split by initial
ordering chambers. Supply disjoint rational polytopes contained in each
piece, exact four-volumes V_ij, and rational coordinate upper bounds b_ij.
Then, in the uniform-fibre scale,

    l_i = sum_j ρ(b_ij) V_ij / 120

is a rigorous lower mass bound. Bounds at zero trailing coordinates use
the continuous integral expression of Lemma D, not its apparent 0/0
alternating formula. Upper masses require a covering subdivision and
ρ(a_ij), with a1>0, plus any singular cap charged by ε^3/3 (with fibre
weights). Subcells alone certify lower masses, not upper masses.

The rational density brackets exist as a proved formula; the repository
contains no instantiated I5 cell-volume/density-mass certificates. The
period-30 periodic orbit of R5 is a point of zero absolutely continuous
mass and cannot supply positive l_i. Symbolic word counts are not masses.

With C_hi=1/3, W_lo=sum_i r_i l_i, use

    U1=1/3-W_lo,
    S_K=sum_{b_i<0} b_i l_i + sum_{b_i>=0} b_i h_i
        + 2a U0 + L(1/3-W_lo).

For L>0, this bound is negative precisely when

    W_lo > 1/3 + (sum signed cell terms + 2a U0)/L.

This is the required effectiveness test; no budgets currently exist to
evaluate it. With no certified covered masses W_lo=0, the available
bound is U1<=1/3 and the fallback budget alone is nonnegative. This is
not a refutation of the route. It identifies the missing quantitative
input: weighted covered mass and certified contracting norm budgets.

A sharper ambient C_hi can be obtained by subdividing O\{x1<ε},
using rational density maxima and exact volumes, and charging ε^3/3
for the cap. These enclosures converge as mesh and ε decrease. Take
the minimum with 1/3. This avoids computing a transcendental normalizing
constant. The strongest residual given any such enclosure is
C_hi-W_lo; there is no numerical improvement from absent cell data.

A future exact verifier must reject overlapping cells, unproved first
returns, wrong labels or charts, invalid rational PSD/log certificates,
negative masses, l_i>h_i, inconsistent ambient scale, and W_lo>C_hi.
Regression obligations include a nonergodic invariant component (total
moment below ambient mass), a noninvertible map, 120-fold scale invariance,
induced-probability normalization, a singular-cap integral, and a valid
cell family whose signed test stays nonnegative. An arithmetic check
alone cannot certify geometric containment, invariance, or ergodicity.
New executable mathematics must follow AGENTS.md: independent Python and
canonical Mojo tests first, vectors, governance, and execution receipts.

## 4. Literature gate and boundaries

Primary source checked: Michael Hochman, *Notes on ergodic theory*,
July 5, 2017, §3.3 Theorem 3.3.1, p.18,
https://math.huji.ac.il/~mhochman/courses/ergodic-theory-2017/notes.pdf.
Its stated identity assumes an invertible ergodic probability system.
The finite-measure noninvertible inequality used here is proved in §1,
not attributed to that narrower statement. BST23 §6.5 was read directly
at https://arxiv.org/pdf/2005.13038. Lemma D and its ABMST density import
are reused from the repository's existing gate §10; no new verification
of ABMST's source is claimed here.

Kac removes the need for an independent tail-decay estimate once the
ambient invariant measure is fixed. It does not construct return cells,
adapted norms, negative budgets, or the cocycle/chart identification.
No claim status changes and no promotion of Theorems C/C′ are justified.
