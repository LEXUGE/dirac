#import "lib.typ": *

#register()

We define #defn($bold(upright(E))$) as the electric field.

Here is an expression involving $bold(upright(E))$,
$ #link(label("dirac_defns_0"))[$bold(upright(E))$] := frac(#defn($q$), 4 pi epsilon_0) $

Now define #defn($mu_0$) as the permeability of the free space

Inline definition
$ dif #defn($x$)^3 = 3x^2 dif x$

// FIXME: Inline defn seems not to expand label
// error: label `<dirac_defns_1>` does not exist in the document
//    ┌─ test.typ:16:1
//    │
// 16 │ #link(label("dirac_defns_1"))[$q$]
//    │  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//
Link back to implicit definition
#link(label("dirac_defns_1"))[$q$]
