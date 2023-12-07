// "Definitions" state which collects all the definitions
#import "std.typ"

#let defns = state("defns", std.defns_builtins)
#let defns_counter = counter("defns_counter")
// #let opt_strict = state("opt_strict", true)

// Insert an additional definition
#let defn(expr) = locate(
  loc => {
    // This gets the counter_val at the function call
    let counter_val = str(defns_counter.at(loc).first())
    // Insert expr into defns
    defns.update(x => { x.insert("dirac_defns_" + counter_val, expr.body); x })
    // Step our counter to prepare for the next "defn" call
    defns_counter.step()
    // label the expression.
    // NOTE: label appends to the previous expression
    // NOTE: Don't leave spaces in the markup block as it's gonna translate into user documents
    [#expr #label("dirac_defns_" + counter_val)]
  },
)

#let __check_type(content, truth) = {
  if type(truth) == function {
    // match directly
    if content.func() == truth { true } else { false }
  } else if type(truth) == str {
    // the constructor function is private, we have to match using string
    if repr(content.func()) == truth { true } else { false }
  } else {
    panic(
      "type_check must have truth as function or string. This is an implementation error.",
    )
  }
}

#let check(content, loc) = {
  // Check if the content is atomic (i.e. must be defined by user explicitly)
  let is_atomic = false
  for a in std.atomic_contents {
    if __check_type(content, a) { is_atomic = true; break }
  }

  if is_atomic {
    // If the content is atomic, we need to check if it's already defined - either by user or in std.
    if not (content in defns.final(loc).values()) {
      // But before panicking check if it is a scalar (i.e. number), we don't want to define numbers
      // Use `match` as it returns `none` on no-match
      if (content.func() == math.text) and (not (content.text.match(regex("^\d+$")) == none)) {
        // Scalar are always given as text
      } else {
        panic("undefined atomic content: " + repr(content))
      }
    }
  } else {
    // Check if the content has subfields that is accessible to us: so we could proceed into next level
    // First determine the content type and its accessible fields
    let acc_fields = ()
    let unknown_content = true

    for a in std.accessible_fields {
      let (typ, flds) = a
      if __check_type(content, typ) { acc_fields = flds; unknown_content = false;break }
    }

    // If the content is unknown, panic
    if unknown_content { panic("encountered unknown content " + repr(content.func())) }
    for (_, next) in content.fields().pairs().filter(x => { let (key, _) = x; key in acc_fields }) {
      if type(next) == array {
        for item in next {
          check(item, loc)
        }
      } else {
        check(next, loc)
      }
    }
  }
}

// Register the checker
#let register() = locate(loc => {
  let eqns = query(math.equation, loc)
  eqns
  for eqn in eqns {
    check(eqn, loc)
  }
})
