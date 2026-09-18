---
name: nix-review
description: Review Nix code for idiomatic style, unnecessary verbosity, maintainability issues, and simplification opportunities while respecting this repository's den/flake-parts architecture.
---

# Nix Review

Review Nix code for unnecessary complexity, verbosity, duplication, and
non-idiomatic structure.

The goal is not to rewrite working code for the sake of style. Prefer simpler
code only when it is at least as readable and preserves the existing
architecture.

## Repository architecture

This repository is based on `den` and `flake-parts`.

Always use the `den` skill as the authoritative reference for repository
structure and den-specific patterns.

Do not recommend replacing den, flake-parts, aspects, or the repository's
existing architecture with generic Nix flake patterns.

## What to review

### Attribute set structure

Look for unnecessary intermediate attribute sets.

Prefer:

```nix
den.aspects.alacritty.homeManager = {
  programs.alacritty.enable = true;
};
```

over:

```nix
den.aspects.alacritty = {
  homeManager = {
    programs.alacritty.enable = true;
  };
};
```

when `homeManager` is the only attribute below that aspect.

However, do not flatten when grouping improves readability.

Prefer:

```nix
den.aspects.obsidian = {
  provides.to-hosts = {
    # ...
  };

  homeManager = {
    # ...
  };
};
```

over:

```nix
den.aspects.obsidian.provides.to-hosts = {
  # ...
};

den.aspects.obsidian.homeManager = {
  # ...
};
```

when several related attributes share the same parent.

Use judgment rather than blindly flattening attribute sets.

### Redundant bindings

Look for:

- unnecessary `let ... in`
- bindings used only once when inlining improves readability
- trivial aliases
- unnecessary function arguments
- bindings that can use `inherit`
- repeated values that should reasonably be factored out

Example:

```nix
let
  package = pkgs.alacritty;
in {
  home.packages = [ package ];
}
```

Prefer:

```nix
home.packages = [ pkgs.alacritty ];
```

But keep bindings when they improve readability or avoid meaningful
duplication.

### `inherit`

Prefer `inherit` when it clearly removes repetition.

Example:

```nix
{
  foo = foo;
  bar = bar;
}
```

Prefer:

```nix
{
  inherit foo bar;
}
```

Do not introduce `inherit` when it makes the origin of values harder to
understand.

### Module arguments

Look for:

- unused module arguments
- overly broad argument sets
- `{ config, pkgs, lib, ... }` when some arguments are unused
- arguments passed through several layers without need

Prefer the smallest useful argument set.

### Nix module helpers

Review usage of:

- `lib.mkIf`
- `lib.mkDefault`
- `lib.mkForce`
- `lib.optional`
- `lib.optionals`
- `lib.optionalAttrs`
- `lib.mkMerge`

Look for redundant or unnecessarily complicated usage.

Do not recommend `mkForce` unless overriding module priority is genuinely
required.

### Lists and attribute sets

Look for:

- unnecessary list concatenation
- redundant `++ []`
- unnecessary `lib.optionals`
- unnecessary `lib.optionalAttrs`
- duplicated entries
- verbose constructions that have a simpler equivalent

### `with`

Prefer avoiding broad `with` expressions when they make identifier origins
unclear.

For example, be cautious with:

```nix
with pkgs; [
  git
  ripgrep
  fd
]
```

Do not flag existing `with pkgs;` automatically. Only suggest changing it when
explicit qualification would materially improve clarity.

### Packages and modules

Check whether configuration manually installs or configures something already
provided by an existing NixOS or Home Manager module.

Prefer existing modules when they provide a clean declarative interface.

Do not replace a simple package installation with a module unless the module
actually provides useful configuration.

### Duplication

Look for repeated:

- package lists
- option groups
- paths
- strings
- host-specific settings
- aspect configuration

Recommend factoring things out only when it reduces meaningful duplication.

Do not create abstractions for two trivial lines merely to avoid repetition.

### Hard-coded values

Look for hard-coded:

- usernames
- home directories
- architecture strings
- hostnames
- store paths
- generated paths

Only flag these when a repository-provided value or module argument would be
more appropriate.

### Secrets

Flag secrets, credentials, tokens, or passwords embedded directly in Nix code.

Prefer the repository's existing secret-management approach.

## Tool-assisted checks

When available, use:

```bash
statix check .
deadnix .
nix flake check
```

Use their output as additional evidence.

Do not blindly repeat lint output. Evaluate whether each finding matters in the
context of this repository.

Formatting issues handled automatically by `nixfmt` are not review findings
unless formatting exposes a structural readability problem.

## Review categories

Classify findings as one of:

- `correctness` — may cause incorrect behavior
- `maintainability` — makes future changes unnecessarily difficult
- `idiomatic` — has a clearer or simpler Nix equivalent
- `duplication` — repeated configuration should likely be consolidated
- `preference` — subjective style suggestion only

Do not present preferences as problems.

## Review severity

Use only these levels:

- `important` — correctness issue or substantial maintainability problem
- `suggestion` — worthwhile simplification or idiomatic improvement
- `minor` — small cleanup with limited impact

Avoid flooding the review with minor issues.

Prioritize meaningful improvements.

## Output format

For every finding provide:

1. the location or relevant code
2. the category and severity
3. why the current version is unnecessarily complex or problematic
4. a suggested replacement
5. whether the change is semantic or purely structural

Example:

### suggestion · idiomatic

Current:

```nix
den.aspects.alacritty = {
  homeManager = {
    programs.alacritty.enable = true;
  };
};
```

Suggested:

```nix
den.aspects.alacritty.homeManager = {
  programs.alacritty.enable = true;
};
```

Reason:

`homeManager` is the only child of this aspect, so the intermediate attribute
set adds indentation without adding useful grouping.

This is a structural change only; semantics remain unchanged.

## Important review principles

- Preserve semantics.
- Respect the existing repository architecture.
- Prefer readability over cleverness.
- Prefer local simplifications over large refactors.
- Do not create abstractions without a clear benefit.
- Do not flatten attribute sets mechanically.
- Do not rewrite code merely because another valid style exists.
- Clearly distinguish objective issues from personal preference.
- Do not modify files unless explicitly asked.
