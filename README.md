# Settling the Optimal Exponent Relating Sumsets and Difference Sets

A Lean 4 / [mathlib](https://github.com/leanprover-community/mathlib4) formalization.

> The set construction formalized here was **discovered by Hyra**, a research agent
> developed by Tencent Hunyuan — see [Provenance & attribution](#provenance--attribution).

For a finite set of integers `A` with `|A| ≥ 2`, define the **sum/difference growth
exponent**

```
C(A) = log(|A + A| / |A|) / log(|A − A| / |A|)
```

where `A + A` and `A − A` are the pointwise sumset and difference set. This repository
proves:

1. **Universal strict upper bound.** `C(A) < 2` for every finite `A ⊆ ℤ` with `|A| ≥ 2`.
2. **The supremum is exactly `2`.** `sSup { C(A) : A ⊆ ℤ finite, |A| ≥ 2 } = 2`.
3. **The supremum is not attained.** No admissible `A` has `C(A) = 2`.
4. **A quantitative witness.** There is an explicit finite `A` with
   `2 − 10⁻⁹⁹⁹ < C(A) < 2`.

The upper bound is the analytic half (via the additive Plünnecke–Ruzsa / Ruzsa
triangle inequality); the matching lower bound is an explicit base-39 "column"
construction whose growth exponents converge to `2`.

## Headline theorems

All live in namespace `SumDiffExponent` (the construction lemmas are in `Column39`).

| Theorem | File | Statement |
|---|---|---|
| `growthExponent_lt_two` | `SumDiffExponent.lean` | `2 ≤ A.card → growthExponent A < 2` |
| `tendsto_growthExponent_approximatingSet` | `SumDiffExponentMain.lean` | the explicit sets' exponents `→ 2` |
| `isLUB_admissibleExponents` | `SumDiffExponentMain.lean` | `IsLUB admissibleExponents 2` |
| `sSup_admissibleExponents` | `SumDiffExponentMain.lean` | `sSup admissibleExponents = 2` |
| `supremum_not_attained` | `SumDiffExponentMain.lean` | `2 ≤ B.card → growthExponent B ≠ 2` |
| `quantitative_example` | `SumDiffExponentQuantitative.lean` | `2 − 10⁻⁹⁹⁹ < C < 2` for an explicit set |

where `growthExponent A = Real.log (sigma A) / Real.log (delta A)`,
`sigma A = |A + A| / |A|`, `delta A = |A − A| / |A|` (as real numbers).

## Repository layout

| Module | Role |
|---|---|
| `SumDiffExponent.lean` | Problem definitions; the universal strict upper bound; base-12 automata certificates (a faithful record of the manuscript, not used by the final construction). |
| `SumDiffExponentColumn.lean` | Kernel-friendly base-39 block `V`; finite certificates `V + V = range 39` and `|V − V| = 37`. |
| `SumDiffExponentConstruction.lean` | The explicit row/column sets `A l` and their sum/difference cardinality bounds. |
| `SumDiffExponentLimit.lean` | The asymptotic lower bound `exponentLower l → 2`. |
| `SumDiffExponentMain.lean` | Convergence to `2`, the least-upper-bound / supremum theorems, non-attainment. |
| `SumDiffExponentQuantitative.lean` | The explicit `10⁻⁹⁹⁹` witness. |
| `scripts/CheckAxioms.lean` | Prints the axiom footprint of the headline theorems (see below). |

## Requirements

* [`elan`](https://github.com/leanprover/elan) (the Lean toolchain manager). The exact
  Lean version — **`leanprover/lean4:v4.32.1`** — is pinned in `lean-toolchain` and is
  installed automatically by `elan` on first use.
* Internet access to download the mathlib olean cache (a few GB) rather than
  compiling mathlib from source.
* ~8 GB of free disk for the build directory `.lake/`.

Dependencies are pinned to exact commits in `lake-manifest.json` (mathlib `v4.32.1`,
commit `520045a…`), so the build is reproducible.

## Build and reproduce

Install `elan` if you don't have it:

```bash
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y
source "$HOME/.elan/env"
```

Then, from the repository root:

```bash
lake exe cache get   # download the pinned mathlib oleans (fetches deps on first run)
lake build           # compile all six modules — this is the verification
```

A successful run ends with `Build completed successfully`. Lean emits a warning for
any `sorry`; a clean build with no warnings means none is present.

### Checking the axiom footprint

```bash
lake env lean scripts/CheckAxioms.lean
```

## Verification status

* `lake build` completes successfully (2212 jobs); **no `sorry`** and **no `warning`**.
* Axiom footprint (`#print axioms`, reproduced by `scripts/CheckAxioms.lean`):
  * `growthExponent_lt_two` and `supremum_not_attained` depend only on the three
    standard mathlib axioms `propext`, `Classical.choice`, `Quot.sound` — the analytic
    upper-bound half is fully kernel-checked.
  * `sSup_admissibleExponents`, `isLUB_admissibleExponents`,
    `tendsto_growthExponent_approximatingSet`, and `quantitative_example` additionally
    depend on **three `native_decide` certificates**:
    `V_card_certificate`, `V_sum_certificate`, `VDiff_card_certificate`
    (the facts `|V| = 12`, `V + V = {0,…,38}`, `|V − V| = 37` for the 12-element
    base-39 block `V`).

### Trust base note

`native_decide` discharges a goal by compiling it to native code and running it,
which adds the Lean compiler and native execution to the trusted computing base (this
is why those theorems carry an extra generated axiom rather than being closed purely by
the kernel). Here it is used only for the three elementary finite computations listed
above; each is a small, independently checkable fact about a 12-element set. The
base-12 automaton certificates in `SumDiffExponent.lean` also use `native_decide` but
do **not** feed the final theorems (they are not in the axiom footprint above).

## Provenance & attribution

The mathematical construction formalized here was **discovered by [Hyra](https://hy.tencent.com/research/hyra)**, an
AI research agent. This repository takes that construction further. It gives a machine-checked
Lean 4 / mathlib proof of the **sharp** statement — the growth exponent is `< 2`
for *every* admissible set, its supremum over all such sets is exactly `2`, and
`2` is never attained — using a kernel-friendly base-39 variant of the same
idea (the base-12 automata above are retained in `SumDiffExponent.lean` as a
faithful record of Hyra's construction, but are not load-bearing for the final
theorems). The formalization, project scaffolding, and this write-up are not
part of Hyra.

## License

Licensed under the [Apache License, Version 2.0](LICENSE) — the license used by
mathlib and most of the Lean ecosystem. Attribution is recorded in
[`NOTICE`](NOTICE).