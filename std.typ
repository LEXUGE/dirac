// "Standard library" for dirac. This defines all common definitions

#let builtins_defns = (
  // math.text(...) notation works, good!
  math.text(math.plus),
  math.text(math.minus),
  math.text(math.times),
  math.text(math.sum),
  math.text(math.eq),
  math.text(math.colon.eq),
  math.text(math.integral),
  math.text(math.pi),
  math.text(math.epsilon),
  math.text(math.mu),
  math.text($upright(d)$.body),
  math.text(math.comma),
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
