---
name: intent-comments
description: Add or improve concise code comments that explain non-obvious intent, rationale, constraints, ownership, or tradeoffs. Use when asked to comment, document, annotate, or make configuration/code easier to understand. Prefer explaining why something exists over restating what the code already says.
---

# Intent Comments

Add comments that help a future maintainer understand decisions that are not obvious from the code itself.

The goal is not to maximize the number of comments. The goal is to preserve useful context.

## Core rule

Prefer comments that explain **why** over comments that explain **what**.

Good comments answer questions such as:

- Why is this configured here instead of somewhere else?
- Why is this value or package necessary?
- Why was this approach chosen over the obvious alternative?
- What scope or ownership decision is being expressed?
- What non-obvious interaction, constraint, or workaround exists?
- What would break or change if this code were removed?

Do not comment code whose meaning is already clear from names and structure.

## Before adding a comment

Read enough surrounding code to understand the intent.

Never invent a reason that is not supported by the codebase or existing context. If the reason cannot be determined reliably, either:

- leave the code uncommented, or
- state only the factual non-obvious effect.

## What to comment

Prioritize comments for:

- architectural or ownership decisions;
- configuration placed at an unusual scope;
- non-obvious dependencies between settings;
- compatibility requirements;
- deliberate deviations from defaults;
- workarounds;
- security-related decisions;
- settings whose purpose is not clear from their option name;
- shared configuration that avoids duplication;
- values whose exact choice has an important reason.

## What not to comment

Avoid comments that merely translate identifiers into English.

Bad:

    konsole # KDE terminal
    pointSize = 10; # Set the font size to 10
    floating = true; # Make the panel floating

These comments add no information beyond the code itself.

Also avoid:

- comments on every line;
- long prose where a short sentence is sufficient;
- repeating documentation that can be inferred from an obvious option name;
- speculative explanations;
- comments describing implementation details likely to become stale.

## Placement

Prefer one concise comment above the relevant block when several lines share the same rationale.

Prefer:

    # Install fonts system-wide so every user can share the same font packages.
    provides.to-hosts.nixos = { pkgs, ... }: {
      fonts = {
        fontconfig.enable = true;
        packages = with pkgs; [
          inter
          nerd-fonts.jetbrains-mono
          nerd-fonts.symbols-only
        ];
      };
    };

over:

    fonts = {
      fontconfig.enable = true; # Enable Fontconfig
      packages = with pkgs; [   # Install fonts
        inter                    # Inter font
        nerd-fonts.jetbrains-mono # JetBrains Mono
        nerd-fonts.symbols-only  # Nerd Font symbols
      ];
    };

Use inline comments only when they remain short and clearly belong to one specific value.

## Declarative configuration

For Nix and other declarative configuration, focus especially on **scope and intent**.

For example:

    # Install fonts system-wide instead of per user to avoid duplicate installations.
    provides.to-hosts.nixos = { pkgs, ... }: {
      fonts = {
        fontconfig.enable = true;
        packages = with pkgs; [
          inter
          nerd-fonts.jetbrains-mono
          nerd-fonts.symbols-only
        ];
      };
    };

The individual font settings usually do not need comments:

    programs.plasma.fonts = {
      general = {
        family = "Inter";
        pointSize = 10;
      };

      windowTitle = {
        family = "Inter";
        pointSize = 10;
        weight = 600;
      };

      fixedWidth = {
        family = "JetBrainsMono Nerd Font";
        pointSize = 10;
      };
    };

However, a non-obvious choice may deserve one:

    fixedWidth = {
      # Keep a patched monospace font for terminal-style UI and Nerd Font glyphs.
      family = "JetBrainsMono Nerd Font";
      pointSize = 10;
    };

## Existing comments

When editing already-commented code:

- keep useful comments;
- improve comments that describe only mechanics when the intent can be stated instead;
- remove redundant comments;
- remove or correct comments that no longer match the code.

Comments are part of the maintained code and must stay factually accurate.

## Editing behavior

When invoked on code:

1. Inspect the relevant file and surrounding configuration.
2. Identify only the places where additional context has lasting value.
3. Add or improve comments without changing behavior.
4. Keep comments concise and consistent with the language and style already used in the repository.
5. Do not refactor unrelated code unless explicitly requested.
6. Run the repository formatter when appropriate after editing.

A good result may contain only a few new comments. Sparse, useful comments are preferable to thoroughly annotated code.
