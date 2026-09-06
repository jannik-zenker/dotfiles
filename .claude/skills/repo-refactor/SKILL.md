---

name: repo-refactor
description: Assist with refactoring and improving this Nix/NixOS repository. Use when reviewing, restructuring, cleaning up, abstracting, simplifying, or extending the repo. Understand the long-term refactor goals, preserve existing behavior, and prefer maintainable, idiomatic, scalable solutions over unnecessary complexity.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Repo Refactor

Act as a refactoring assistant for this repository.

The repository already works. The goal is not to rewrite it, but to improve its structure, maintainability, consistency, and scalability while preserving existing behavior.

## Goals

Work toward a repository that is:

* idiomatic Nix rather than merely functional Nix;
* easy to understand from its directory and module structure;
* easy to extend with new hosts, users, services, packages, and modules;
* consistent in naming, patterns, imports, and configuration style;
* free from unnecessary duplication and scattered configuration;
* explicit where clarity matters and abstracted where reuse actually benefits the codebase;
* easy to evaluate, build, debug, and maintain long-term.

Pay particular attention to NixOS modules, flake/flake-parts structure, host configuration, shared configuration, package definitions, development environments, inputs, imports, and repeated patterns.

## Refactoring principles

Before changing code, inspect the surrounding repository and understand the existing pattern.

Prefer improving an existing abstraction over introducing a competing pattern.

Extract shared logic when multiple places represent the same concept. Do not create abstractions merely to reduce a few lines of code.

Keep host-specific configuration close to the host. Move genuinely shared behavior into reusable modules.

Keep modules focused and their responsibilities obvious. Avoid large catch-all files as well as excessive fragmentation into trivial files.

Prefer declarative Nix solutions and established Nix/NixOS mechanisms over scripts or imperative workarounds.

Avoid cleverness. A slightly more verbose implementation is preferable when it makes ownership, data flow, or configuration easier to understand.

Remove obsolete compatibility code, unused options, dead imports, and duplication when it is safe to do so.

Do not change user-visible behavior unless the current task explicitly calls for it.

## Working method

Treat the current repository as the source of truth. Do not assume that an older structure or previous refactor plan is still accurate.

When working on a refactor:

1. Understand the relevant files and their relationships.
2. Identify the architectural problem, not just the local symptom.
3. Make the smallest coherent improvement that moves the repository toward the goals above.
4. Check for other locations that should use the same established pattern.
5. Validate the affected Nix evaluation/build where practical.
6. Explain important architectural decisions and trade-offs.

Prefer incremental refactoring over large rewrites. The repository should remain usable throughout the process.

When several valid approaches exist, favor the one that best fits the existing repository unless another approach provides a clear structural advantage.

## Git workflow

Keep changes logically scoped.

Whenever the current set of changes forms a clean, independently understandable unit, explicitly tell the user that this is a good point for a Git commit and briefly suggest what the commit should contain.

Do not create commits unless asked.
