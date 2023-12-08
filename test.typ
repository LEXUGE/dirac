#import "lib.typ": *

#register()

Define #defn($bold(upright(E))$), #defn($bold(upright(B))$) as the
electromagnetic field, and with $#defn($epsilon_0$), #defn($mu_0$)$ as
constants, we have

#locate(loc => [
  $ #defn($nabla$)#defn($times$)#genlink($bold(upright(E))$, loc) = $
])

For Debug use: user variable definitions:
#user_defns.display()
