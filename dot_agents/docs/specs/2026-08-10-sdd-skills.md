# SDD skill set

## Problem

The superpowers plugin drives brainstorm → plan → subagent implementation, but with Opus 5
parts of it work poorly: the free-floating verification skill triggers constant self-review,
the plan files duplicate the spec down to exact code, and the SDD controller carries heavy
machinery (ledgers, report files, helper scripts, 5-round fix loops) that adds bookkeeping
without adding quality. The plugin will be uninstalled, so its useful workflow must be
replaced by self-contained personal skills.

## Solution

Five standalone skills in `~/.dotfiles/dot_agents/skills/`, chained by "next step" pointers:

1. `brainstorm` — relentless one-question-at-a-time dialogue that ends in shared understanding
2. `to-spec` — synthesizes the conversation into a spec file with vertical slices
3. `implement-spec` — controller loop dispatching one implementer subagent per slice
4. `tdd` — red-green discipline loaded by implementer subagents
5. `verify` — two-axis review rubric loaded by reviewer subagents

The spec file is the single artifact: requirements, slices, and progress markers in one
committed document. No ledgers, no report files, no helper scripts.

## Design decisions

- **Skill location:** `~/.dotfiles/dot_agents/skills/<name>/SKILL.md` (chezmoi-managed).
  Existing `grilling`/`grill-me` skills stay untouched.
- **Separation of dialogue and artifact:** `brainstorm` writes nothing; `to-spec` synthesizes
  from any conversation ("no interview, just synthesis"), whether or not it was a formal
  brainstorm.
- **Spec files:** `docs/specs/YYYY-MM-DD-<topic>.md` in the target repo. Template sections:
  Problem, Solution, Design decisions, Testing, Slices, Out of scope. Living document during
  implementation; historical record after merge. Slice progress is a status marker on the
  slice heading (e.g. `— DONE`).
- **Model policy** (always pass `model` explicitly when dispatching):
  - Implementer: scaled to slice complexity — sonnet for well-specified 1–2 file slices,
    opus for multi-file integration, design judgment, or subtle logic.
  - Per-slice reviewer: opus by default; sonnet only for genuinely mechanical diffs.
  - Final whole-branch reviewer: opus, always.
- **Per-slice loop:** dispatch implementer → review → max 2 fix rounds → controller
  adjudicates leftovers (fix trivial findings directly, park in spec with a note, or ask the
  user). Slices run sequentially; parallelism is a manual per-case decision, never skill
  machinery.
- **Reporting:** the implementer's final message is the report — status, commits, test
  command + results, concerns. Status contract: `DONE` (with test evidence, optionally with
  concerns) or `BLOCKED` (states exactly what it needs). Durable facts for later slices
  (changed interfaces, parked findings) go into the spec file, written by the controller.
- **Branching:** feature branch required (skill checks at setup); worktrees optional and
  user-decided, never mandated.
- **TDD shape:** red-green only — refactoring is deferred to review; in-flight cleanups of
  just-written code are fine. Iron law retained: production code written before its failing
  test is deleted and redone. Rationalization table trimmed to ~4 rows.
- **Verification scope:** review happens at exactly two moments — per-slice review and final
  whole-branch review — always against the spec, by a subagent with a capped report. No
  ambient completion-gating in the main session.
- **Invocation:** all five skills are model-invocable via description triggers and usable as
  slash commands. `brainstorm` fires on "let's build X"; `tdd` on any implementation work;
  `verify` on review requests. No meta-skill or hook layer.
- **Self-contained:** no references to superpowers skills, scripts, or workspace conventions.
  `implement-spec` ends with a built-in finish step (full test suite, then ask: PR, merge,
  or leave branch) instead of handing off to another skill.

## Testing

These deliverables are markdown skill files — no automated test seam exists. Verification is
structural review of each SKILL.md against its slice requirements:

- Frontmatter parses and contains `name` + `description` (and `disable-model-invocation`
  only where specified).
- `rg -i "superpowers"` over the five skill directories returns nothing.
- Cross-references between skills use the correct final skill names.
- Each done-when check in the Slices section is satisfied by reading the file.

## Slices

Ordered so the subagent-loaded skills (`tdd`, `verify`) exist before `implement-spec`, which
dispatches them. Chat-flow pointers (brainstorm → to-spec → implement-spec) are plain text
and tolerate forward references.

### Slice 1: `tdd` skill — DONE

**Goal:** the TDD discipline implementer subagents load.

Requirements:

- Frontmatter description triggers on implementing any feature or bugfix, before writing
  implementation code.
- Core loop: write one minimal failing test → run it and watch it fail for the right reason
  (feature missing, not a typo — mandatory, never skipped) → write the simplest code to pass
  → run it and watch it pass with everything else green → repeat. No refactor step:
  quality cleanup belongs to review; renaming or tidying code written in the current slice
  is allowed in passing.
- Iron law: production code written before its failing test gets deleted and reimplemented
  test-first. No keeping it as "reference".
- Test quality rules: test behavior at the seams the spec's Testing section defines; assert
  on real behavior, never on mock behavior; mock only slow/non-deterministic/external
  boundaries; expected values need an independent source of truth (no tautological tests);
  one behavior per test with a name that describes it.
- Compact rationalization table, max 4 rows (e.g. "too simple to test", "I'll test after",
  "already manually tested", "keep it as reference").
- Bug fixes start with a failing test reproducing the bug.

Done when: SKILL.md exists, contains the loop, the iron law, seam/behavior rules, and a
table of at most 4 rationalizations; total file under ~120 lines.

### Slice 2: `verify` skill — DONE

**Goal:** the two-axis review rubric reviewer subagents load.

Requirements:

- Frontmatter description triggers on reviewing a diff, branch, or slice against a spec or
  standards.
- Inputs: a diff (or ref range) and a spec path when one exists. Reviewer runs `git diff`
  itself when given refs.
- Two axes, reported under separate headings, never merged or re-ranked across axes:
  - **Spec compliance:** missing or partial requirements, scope creep (unrequested
    behavior), implementations that contradict the spec. Every finding cites the spec line.
  - **Code quality:** judgment-call issues (naming, duplication, unnecessary complexity,
    error-handling gaps). Every finding cites the diff hunk. Explicitly labeled heuristics,
    never hard violations; documented repo standards win over generic heuristics.
- Skip list stated explicitly: anything linters/type-checkers/tests already enforce;
  re-running tests the implementer already ran; style preferences; code outside the diff.
- Report capped at ~400 words, findings ranked by severity within each axis, ends with a
  one-line verdict per axis.
- Scope statement: verification happens at review moments against the spec — this skill is
  not a completion gate and must not trigger ambient self-review.

Done when: SKILL.md exists with both axes, the skip list, the cap, and the scope statement;
no superpowers references.

### Slice 3: `brainstorm` skill — DONE

**Goal:** the grilling-style dialogue that turns an idea into shared understanding.

Requirements:

- Frontmatter description triggers on "let's build X", fleshing out an idea, stress-testing
  a plan or design decision.
- Flow: explore project context first (files, docs, recent commits); look up facts in the
  environment instead of asking; then interview one question at a time — never multiple
  questions per message — with a recommended answer per question, resolving decision
  dependencies in order (walk each branch of the decision tree).
- Scope check early: if the request spans multiple independent subsystems, decompose before
  refining details.
- Propose 2–3 approaches with trade-offs when the solution space is genuinely open, leading
  with the recommendation; YAGNI applied to every approach.
- Hard gate: no implementation, scaffolding, or code until the user confirms shared
  understanding.
- Terminal state: a short design summary in chat, user approval, and a pointer to run
  `/to-spec`. Writes no files.

Done when: SKILL.md exists with the one-question rule, facts-vs-decisions rule, hard gate,
and to-spec pointer; writes no artifacts.

### Slice 4: `to-spec` skill — DONE

**Goal:** synthesize the conversation into a committed spec file.

Requirements:

- Frontmatter: description says it converts the current conversation into a spec file;
  `disable-model-invocation: true` is NOT set — it may fire when the user asks to "write
  this up as a spec", and is also the target of brainstorm's pointer.
- No interview: synthesis only. Gaps in the conversation become explicit questions back to
  the user before writing, not invented requirements.
- Explores the repo enough to ground the spec (existing structure, prior specs in
  `docs/specs/`, test conventions).
- Output: `docs/specs/YYYY-MM-DD-<topic>.md` with sections Problem, Solution, Design
  decisions, Testing, Slices, Out of scope.
  - Design decisions: architecture, interfaces, schemas, chosen approach and why; code
    snippets only when they capture a decision better than prose; avoid file paths that go
    stale.
  - Testing: the seams — where tests live, what behavior they verify, prior art in the repo.
  - Slices: numbered vertical slices completable independently in order; each has a goal
    (one sentence), requirements (exact values and behaviors), and done-when (an observable
    check). Each slice must be self-contained enough that an implementer given only the
    spec and its slice number can execute it.
- Self-review pass before handing over: placeholders, contradictions, ambiguity, slice
  independence. Fix inline.
- Ends by committing the spec and asking the user to review it; points to `/implement-spec`
  as the next step.

Done when: SKILL.md exists with the template, slice requirements, self-review checklist, and
the commit + review gate.

### Slice 5: `implement-spec` skill — DONE

**Goal:** the controller loop that executes a spec slice-by-slice via subagents.

Requirements:

- Frontmatter description triggers on executing/implementing a spec from `docs/specs/`.
- Setup: verify a feature branch (never implement on main/master; create one if needed —
  worktree only if the user asks); read the spec once; create a todo per slice; resume by
  scanning slice headings for `— DONE` markers and starting at the first slice without one.
- Continuous execution: no check-ins between slices; stop only for BLOCKED, genuine
  ambiguity, or completion.
- Per slice, sequentially:
  1. Dispatch a fresh implementer subagent. Prompt contains: spec path + slice number
     ("read the spec; your slice's requirements are verbatim and binding"), interfaces or
     decisions from earlier slices the spec doesn't capture, the instruction to follow the
     `tdd` skill, and the report contract. Model scaled to complexity per the model policy;
     `model` always explicit.
  2. Handle the report: `DONE` requires named test command and results. `BLOCKED` → supply
     missing context and re-dispatch, escalate model if it's a reasoning gap, split the
     slice if too large, or ask the user if the spec itself is wrong.
  3. Dispatch a reviewer subagent (opus default) with the spec path, slice number, and the
     slice's ref range; reviewer applies the `verify` skill.
  4. Findings: max 2 fix rounds re-dispatching the implementer with findings verbatim. After
     round 2 the controller adjudicates each leftover: fix trivial ones directly, park real-
     but-deferrable ones as a note in the spec, ask the user about load-bearing ones.
  5. Mark the slice heading `— DONE` in the spec; note durable interface changes or parked
     findings in the spec; mark the todo complete.
- After all slices: one whole-branch review (opus, `verify` skill, whole spec, full branch
  diff). Findings → at most one fix dispatch with the complete list → controller
  adjudicates residuals.
- Finish: run the full test suite fresh; report results; ask the user — PR, merge, or leave
  the branch.
- Model policy section reproduced in the skill (implementer scaling, opus reviewers,
  explicit `model` always).

Done when: SKILL.md exists covering setup, the 5-step slice loop, the 2-round cap with
adjudication paths, final review, and finish step; references `tdd` and `verify` by name;
no ledgers, report files, or helper scripts.

### Slice 6: CLAUDE.md cleanup — DONE

**Goal:** remove superpowers-specific guidance now superseded by the skills.

Requirements:

- Delete the "Superpowers deltas" section from `~/.dotfiles/dot_claude/CLAUDE.md` (the
  chezmoi source for `~/.claude/CLAUDE.md`) — model selection now lives in
  `implement-spec`.
- Leave every other section untouched.

Done when: the section is gone from the chezmoi source file and nothing else changed.

## Out of scope

- Uninstalling the superpowers plugin (user does this after the skills are set up).
- Cherry-picking other superpowers skills (systematic-debugging, worktrees, etc.).
- Changes to the existing `grilling`/`grill-me` skills.
- Hooks, meta-skills, or session-start routing layers.
- Helper scripts of any kind.
