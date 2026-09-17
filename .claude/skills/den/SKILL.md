# Den

[Den](https://github.com/denful/den) is an aspect-oriented Nix framework used
by this repository to define hosts, users, and home-manager configurations.
Read this file before touching anything under `den.*`.

## Pinned revision

```
flake.lock -> nodes.den.locked.rev = d50f0fce6fc1a8ba00fd0d310746d0e8ecc2f70d
```

Den evolves fast and breaks APIs across revisions (its own docs mark several
old APIs deprecated). **Always check `flake.lock` for the exact rev before
trusting any API detail**, including everything in this file. To verify an
API against the pinned rev, fetch source/docs directly instead of guessing
from generic Nix/Den knowledge, e.g.:

```bash
REV=$(grep -A5 '"den"' flake.lock | grep '"rev"' | cut -d'"' -f4)
curl -s "https://raw.githubusercontent.com/denful/den/$REV/docs/src/content/docs/reference/aspects.mdx"
curl -s "https://api.github.com/repos/denful/den/git/trees/$REV?recursive=1"   # full file listing
```

The docs site source lives at `docs/src/content/docs/**/*.mdx`; library/module
source lives under `nix/lib/**` and `modules/**` in the Den repo.

## Mental model

Den separates config into a few concerns:

- **Entities** — `host`, `user`, `home` (declared via `den.hosts` /
  `den.homes`). Entities carry metadata (freeform attrs) that aspects read.
- **Aspects** (`den.aspects.<name>`) — composable attrsets bundling config
  per **class** (`nixos`, `homeManager`, `darwin`, or custom), plus an
  `includes` list (DAG of other aspects/batteries to pull in) and a
  `provides` sub-namespace (named sub-aspects, including cross-entity
  delivery like `provides.to-users`).
- **Classes** — which module system a chunk of config targets: `nixos`,
  `homeManager`, `darwin`, or a custom class built with
  `den.batteries.forward`.
- **Context** — the pipeline argument shape (`{ host }`, `{ host, user }`,
  `{ home }`) flowing through resolution. An aspect written as a function of
  these args is **parametric**: it only fires in matching contexts, no
  wrapper or `mkIf` needed. A plain attrset is **static** and always applies.
- **`den.schema.<kind>`** — base/meta config merged into every entity of a
  kind (`host`, `user`, `home`), plus `includes`/`excludes` lists that
  activate aspects/batteries for every entity of that kind. This is *not*
  an aspect — it's meta-configuration + activation wiring.
- **Batteries** (`den.batteries.*`, aliased `den.provides`/`den._`) —
  Den's built-in reusable aspects (user creation, hostname, shells, home
  environments, the generic `forward` primitive for building custom
  classes, etc.).
- **Resolution pipeline** — for each `den.hosts.<system>.<name>`, Den
  resolves the host's aspect for the `nixos`/`darwin` class, then the
  built-in `host-to-users` policy fans out to each declared user (per-user
  `{ host, user }` context), and the home-manager battery forwards each
  `homeManager`-classed user's content into
  `home-manager.users.<name>` on the host.

## How this repository wires Den in

`flake.nix` uses [`vic/flake-file`](https://github.com/vic/flake-file) +
[`vic/import-tree`](https://github.com/vic/import-tree) (the "dendritic"
pattern): every `.nix` file under `modules/` is auto-imported as a
flake-parts module, and `flake.nix` itself is generated from
`flake-file.inputs` declarations scattered across those files.

`modules/flake/dendritic.nix` pulls in Den's own flake-parts module:

```nix
{ inputs, ... }:
{
  flake-file.inputs = { den.url = "github:denful/den"; ... };
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];
}
```

`inputs.den.flakeModules.dendritic` imports Den's `flakeModule`, which
recursively imports every `.nix` file under Den's own `modules/` — this is
what registers all `den.*` options (`den.hosts`, `den.aspects`, `den.schema`,
`den.batteries`, the resolution pipeline, …) into the flake-parts module
system. After this, any file in this repo's `modules/` tree can just write
`den.aspects.foo = ...` and it merges into the global aspect graph — no
explicit wiring needed per file.

## Repository conventions

### Host/user metadata schema — `modules/metadata.nix`

Declares the freeform option schema for hosts and users via
`den.schema.host.options` / `den.schema.user.options` (e.g. `bootloader`,
`cpu`, `gpu`, `profile` for hosts; `gitName`, `defaultBrowser`, … for users).
This is metadata, not behavior — aspects read `host.profile`,
`host.cpu`, etc. to decide what to configure.

### Host declarations — `modules/host-declarations.nix`

```nix
den.hosts.x86_64-linux.reacher = {
  bootloader = "grub"; cpu = "intel"; gpu = "nvidia"; profile = "desktop";
  users.jannik = { defaultBrowser = "zen-beta"; gitName = "..."; gitMail = "..."; };
};
```

Each key under `den.hosts.<system>` becomes a `nixosConfigurations.<name>`
output. `users.<name>` values are checked against the `user` schema options
from `metadata.nix` and become entities in their own right, with their own
aspect resolved (by default `den.aspects.<userName>`, e.g. `jannik.nix`).

### Global defaults & activation — `modules/defaults.nix`

Sets `den.default.nixos` / `den.default.homeManager` (config injected into
*every* NixOS host / every homeManager-classed user — e.g. mutable users off,
sops password secrets, `allowUnfree`), and `den.schema.*`:

```nix
den.schema.host.includes = [
  den.aspects.bootloader den.aspects.nixos den.aspects.security
  den.aspects.sopsNix den.aspects.xdg den.batteries.hostname
  # ...
];
den.schema.user.classes = lib.mkDefault [ "homeManager" ];
den.schema.user.includes = with den.batteries; [ define-user ];
```

This is the single place that decides which shared aspects/batteries apply
to *every* host and *every* user — per-host/per-user aspects (below) add on
top of this.

### One aspect per file, named after the concern

Every file under `modules/aspects/` declares exactly one
`den.aspects.<name> = { ... }` (camelCase name, usually matching the
filename). Three shapes recur:

```nix
# Static — no dependency on host/user data
den.aspects.jellyfin.nixos = { services.jellyfin.enable = true; ... };

# Parametric at aspect level — needs host/user metadata
den.aspects.bootloader = { host, ... }: {
  nixos.boot.loader.grub.enable = lib.mkIf (host.bootloader == "grub") true;
};

# Class-level (flat-form) context injection — context arg alongside module args
den.aspects.nixos = { host, ... }: { nixos = { ... }: { ... }; };
```

`modules/aspects/AUTOMATIC/*.nix` holds host-wide aspects wired in via
`defaults.nix`'s `den.schema.host.includes`. Files directly under
`modules/aspects/` are opt-in feature aspects pulled in via some other
aspect's `includes`.

### User/host "meta-aspects" compose via `includes`

`modules/aspects/jannik.nix` and `admin-jannik.nix` are user aspects that are
just an `includes` list of feature aspects plus batteries:

```nix
{ den, ... }:
{
  den.aspects.jannik.includes = [
    den.aspects.git den.aspects.niri den.aspects.zsh # ...
    den.batteries.primary-user
    (den.batteries.user-shell "zsh")
  ];
}
```

Host meta-aspects (`sirene.nix`, `reacher.nix`, `hauler.nix`, `lumiere.nix`)
follow the same shape: an `includes` list of feature aspects, plus an owned
`nixos` class body (often `lib.mkMerge [...]`) for disk layout / hardware
specifics via `self.lib.mkStandardDisk` (see `modules/flake/lib/btrfs.nix`).

### Host → user delivery: `provides.to-users.<class>`

To push host-derived config into every user on that host (not just the
host's own `nixos` class), aspects use `provides.to-users`:

```nix
# modules/aspects/AUTOMATIC/git.nix
den.aspects.git.provides.to-users.homeManager = {
  programs.git.settings.user = {
    name = lib.mkIf (user.gitName != null) user.gitName;
    email = lib.mkIf (user.gitMail != null) user.gitMail;
  };
};
```

This is Den's built-in cross-entity routing (no battery needed) — see
`provides.<name>` (specific host/user), `provides.to-hosts` (user → all its
hosts), `provides.to-users` (host → all its users).

### `flake.lib.*` helpers, not `den.lib.*`

Shared Nix helper functions in this repo live under `config.flake.lib.<name>`
(declared as a `lazyAttrsOf raw` option in `modules/flake/lib/default.nix`
since flake-parts doesn't merge `flake.lib` by default), not under Den's own
`den.lib`. Aspects call them via `self.lib.<name>`:

```nix
# modules/flake/lib/wireguard-network.nix
config.flake.lib.mkWireguardPeer = { name }: { ... };

# modules/aspects/wireguard-peer.nix
den.aspects.wireguardPeer.nixos = { config, host, lib, ... }:
  lib.mkMerge [ (self.lib.mkWireguardPeer { name = host.name; }) { ... } ];
```

### Custom class for building a standalone nvf/neovim package

`modules/packages/neovim/nvf-den-integration.nix` builds an nvf
(neovim-flake) configuration *outside* the normal host/user pipeline by
defining an ad-hoc `nvf` class and resolving it directly:

```nix
den.lib.nvf.module = vimAspect: args: let
  vimClass = { aspect-chain }: den.batteries.forward {
    each = lib.singleton true;
    fromClass = _: "vim";      # aspects write { vim = ...; }
    intoClass = _: "nvf";      # forwarded into the "nvf" class
    intoPath = _: [ "vim" ];
    fromAspect = _: lib.head aspect-chain;
    adaptArgs = lib.id;
  };
  aspect = { includes = [ vimClass (vimAspect args) ]; };
in den.lib.aspects.resolve "nvf" aspect;   # collects the "nvf" class into a module
```

Notes:

- `den.batteries.forward { each; fromClass; intoClass; intoPath; fromAspect; adaptArgs; }`
  is Den's generic primitive for building custom classes (it's how Den's own
  `user`/`homeManager`/`hjem` integrations work internally). No
  `den.classes.<name>` registration is required for a one-off class name.
- `den.lib.aspects.resolve "<class>" aspect` is explicitly documented as
  **not a stable public API** — "call it directly only if you are building
  custom pipeline stages". This repo's usage is exactly that case (nvf isn't
  a host/user/home entity, so it never goes through the normal pipeline).
  Prefer the normal `den.schema.*`/`includes` machinery for anything that
  *is* a host/user/home concern.
- `den.aspects.nvfConfiguration` (in `modules/packages/neovim/{keymaps,languages,editor}.nix`)
  is a plain aspect with a `vim` class key, consumed via `mkNeovim`:
  `config.flake.lib.mkNeovim = pkgs: args: den.lib.nvf.package pkgs den.aspects.nvfConfiguration args;`

### ⚠️ Deprecated API in use: `den.ctx.hm-host`

`modules/flake/home-manager.nix` configures the home-manager NixOS module
options via the **deprecated** `den.ctx` shim:

```nix
den.ctx.hm-host.nixos.home-manager = { useGlobalPkgs = true; useUserPackages = true; };
```

At the pinned revision, `den.ctx` is a compatibility shim
(`modules/compat/ctx-shim.nix`) that forwards `den.ctx.<name>` to
`den.schema.<name>.includes` with an evaluation-time `lib.warn`, scheduled
for removal. The modern equivalent (per Den's own migration guide) is:

```nix
den.schema.hm-host.includes = [
  { nixos.home-manager = { useGlobalPkgs = true; useUserPackages = true; }; }
];
```

(`hm-host` is the entity kind the `home-manager` battery reads via
`config.den.schema.hm-host.includes` in `modules/aspects/batteries/home-manager.nix`
— confirmed by inspecting that file at the pinned rev.) Don't copy the
`den.ctx.*` pattern into new code; if asked to clean this up, migrate to
`den.schema.hm-host.includes` and confirm `nixos-rebuild build --flake . 2>&1 | grep -i deprecated`
is silent.

## Gotchas to check before debugging "aspect isn't applying"

- **Silent-inert parametric aspects.** A parametric aspect (`{ user, ... }: ...`)
  included at a scope where `user` is neither in context nor a schema
  descendant produces **no error and no warning** — it just does nothing.
  Check that the arg's entity kind is reachable from where the aspect is
  included (see `explanation/parametric.mdx`).
- **Flat-form class modules need `...`.** `nixos = { host, config, ... }: { ... }`
  must keep the ellipsis (module-system args like `pkgs`/`lib`/`options` are
  injected too) — omitting it is an eval error. The aspect-level *outer*
  wrapper (`{ host, ... }: { nixos = ...; }`) should *not* have `...`.
- **Host-scope aspects can't leak `homeManager` content to users** in this
  Den version — a host-scope `{ user, ... }` aspect fans out per-user but
  emits class-locally on the host, where `homeManager` is inert. Use
  `provides.to-users` (see above) instead.
- **Dedup is scope-keyed.** The same aspect included from multiple places
  within one scope only resolves once (by identity key), so sharing an
  aspect via both `den.default` and an explicit `includes` is safe and not a
  double-apply.
