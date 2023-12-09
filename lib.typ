#import "@preview/t4t:0.3.2": is
#import "std.typ"

// "Definitions" state which collects all the user definitions
#let user_defns = state("dirac_user_defns", ())

// Check if content is defined, either as atomic or as math.attach
#let __check_defined(content, loc) = {
  let user_defns_values = user_defns.final(loc).map(x => x.content)
  return (content in user_defns_values) or (content in std.builtins_defns)
}

#let __check_is_atomic(content) = {
  for a in std.atomic_contents {
    if is.elem(a, content) { return true }
  }
  false
}

// Insert an definition. `expr` should be an equation
#let defn(expr, custom_label: none, visible: true) = locate(
  loc => {
    // Unwrap our expr (mainly needed to deal with e.g. dirac)
    if is.elem(math.equation, expr) {
      defn(expr.body, custom_label: custom_label, visible: visible)
    } else {
      // User should only be allowed to define atomics or attach
      if not (__check_is_atomic(expr) or is.elem(math.attach, expr)) {
        panic("User definition is not atomic: " + repr(expr))
      }
      user_defns.update(
        x => { x.push((content: expr, custom_label: custom_label, location: loc)); x },
      )
      if visible {
        [#expr]
      }
    }
  },
)

// Generate link
#let genlink(content, custom_label: none) = locate(
  loc => {
    // Step into body if content is an equation.
    // We accept equation because otherwise writing e.g. `bold(upright(E))` is impossible outside math environment
    if is.elem(math.equation, content) {
      genlink(content.body, custom_label: custom_label)
    } else {
      if __check_is_atomic(content) or is.elem(math.attach, content) {
        // Match both custom_label and content, therefore there must only be one match at most
        let defn_filtered = user_defns.final(loc).filter(x => (x.content == content) and (x.custom_label == custom_label))
        if defn_filtered.len() == 1 {
          return [#link(defn_filtered.first().location)[#content]]
        } else {
          panic(
            "Multiple or no match. Link cannot be generated for label: " + repr(custom_label) + " and content: " + repr(content),
          )
        }
      } else {
        panic("Link can only be generated for atomic or attach")
      }
    }
  },
)

// Recursive equation check
#let check(content, loc) = {
  // Check if the content is atomic (i.e. must be defined by user explicitly)
  if __check_is_atomic(content) {
    // If the content is atomic, we need to check if it's already defined - either by user or in std.
    if not __check_defined(content, loc) {
      // But before panicking check if it is a scalar (i.e. number), we don't want to define numbers
      // Use `match` as it returns `none` on no-match
      // Scalar are always given as text
      if not (
        (content.func() == math.text) and (not (content.text.match(regex("^\d+$")) == none))
      ) {
        panic("undefined atomic content: " + repr(content))
      }
    }
  } else {
    // Before all, if content is an attach, check we could match the entire attach.
    if is.elem(math.attach, content) and __check_defined(content, loc) { return }

    // Check if the content has subfields that is accessible to us: so we could proceed into next level
    // First determine the content type and its accessible fields
    let acc_fields = ()
    let unknown_content = true

    for a in std.accessible_fields {
      let (typ, flds) = a
      if is.elem(typ, content) { acc_fields = flds; unknown_content = false; break }
    }

    // If the content is unknown, panic
    if unknown_content { panic("encountered unknown content " + repr(content.func())) }
    for (_, next) in content.fields().pairs().filter(x => { let (key, _) = x; key in acc_fields }) {
      if type(next) == array {
        // This indicates we are dealing with a sequence's children
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
  // check eqns
  for eqn in query(math.equation, loc) {
    check(eqn, loc)
  }
})
