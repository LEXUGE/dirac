#import "@lexuge/dirac:0.1.0": *
#import "@preview/physica:0.8.0": *

#register()

#defn($bold(nabla)$, visible: false)
#defn($diff$, visible: false)

Define #defn($vb(E)$), #defn($vb(B)$) as the electromagnetic field, and with $#defn($epsilon_0$), #defn($mu_0$)$ as
constants, we have

$ curl #genlink($vb(E)$) = -pdv(#genlink($vb(B)$), #defn($t$)) $

Note in the above equation, $vb(E), vb(B)$ are linked to their definition in
text. `dirac` also checked in background that all symbols and operations are
defined.

The following equation, for example, would error: ```typst
$ E = m c^2 $
``` as variables (`dirac` is so strict that I cannot even write `E` and `m`, `c`
in math mode without defining it here) are not defined.

Note we have to "define" in `dirac` $bold(nabla)$, $diff$ invisibly. You could
control visibility to suppress displaying what you define in order to better
cope with external libraries (e.g. `physica` here).

Here is how our user definitions are registered in "Dirac":
#user_defns.display()
