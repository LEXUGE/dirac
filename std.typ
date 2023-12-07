// "Standard library" for dirac. This defines all common definitions

#let defns_builtins = (
  // math.text(...) notation works, good!
  "dirac_builtins_plus": math.text(math.plus),
  "dirac_builtins_minus": math.text(math.minus),
  "dirac_builtins_sum": math.text(math.sum),
  "dirac_builtins_eq": math.text(math.eq),
  "dirac_builtins_colon_eq": math.text(math.colon.eq),
  "dirac_builtins_integral": math.text(math.integral),
  "dirac_builtins_pi": math.text(math.pi),
  "dirac_builtins_epsilon": math.text(math.epsilon),
  "dirac_builtins_mu": math.text(math.mu),
  "dirac_builtins_upright_d": $upright(d)$.body,
)

// Setting accessible_fields to empty effectively ignores that content and cut-off the branch
#let accessible_fields = (
  ("sequence", ("children")),
  // space are ignorable, they are not atomic
  ("space", ()),
  (h, ()),
  // Somehow locate(...).func() != locate
  ("locate", ()),
  (link, ()),
  (ref, ()),
  (math.equation, ("body")),
  (math.frac, ("num", "denom")),
  (math.attach, ("base", "t", "b", "tl", "bl", "tr", "br")),
  (math.mat, ("rows")),
)

#let atomic_contents = (math.accent, math.text, "math-style", math.op)
