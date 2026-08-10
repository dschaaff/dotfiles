---
name: brainstorm
description: Use BEFORE any implementation when the user wants to build or add something - "let's build X", "I want to add Y", "I have an idea", "I'm thinking about", "help me design" - even when the request sounds simple enough to just do. A relentless one-question-at-a-time interview that ends in shared understanding and points to /to-spec. For stress-testing ideas that do NOT end in building software, use the grilling skill instead.
---

# Brainstorm

Turn an idea into shared understanding through a relentless collaborative interview. This
skill produces a design summary in chat — never files, never code.

<HARD-GATE>
No implementation, scaffolding, or code — and no writing files — until the user confirms
shared understanding. This holds for every project regardless of perceived simplicity.
"Simple" projects are where unexamined assumptions waste the most work.
</HARD-GATE>

## Process

### 1. Explore context first

Before asking anything, look at the project: files, docs, recent commits, existing specs and
conventions. If a **fact** can be found in the environment, look it up — never ask the user
for it. The **decisions** are theirs: put each one to them and wait for the answer.

### 2. Check scope early

If the request spans multiple independent subsystems, say so immediately and help decompose
into sub-projects before refining details. Don't spend questions polishing a project that
needs to be split first. Each sub-project then gets its own brainstorm → spec cycle.

### 3. Interview — one question at a time

Walk down each branch of the decision tree, resolving dependencies between decisions in
order — settle the decisions later questions depend on first.

- **One question per message.** Multiple questions at once are bewildering. A topic that
  needs more exploration becomes multiple questions.
- **Recommend an answer for every question**, with your reasoning, leading with the
  recommendation. Multiple choice where possible; open-ended is fine too.
- Focus on purpose, constraints, and success criteria — not implementation trivia you can
  decide yourself later.

### 4. Propose approaches when the solution space is open

When there are genuinely different ways to build it, present 2–3 approaches with trade-offs,
leading with your recommendation and why. Apply YAGNI ruthlessly to every approach — strip
features nobody asked for.

### 5. Present the design and confirm

When you believe you understand what's being built, present a design summary in chat, scaled
to the project (a few sentences for simple things; sections for architecture, components,
data flow, error handling, and testing for nuanced ones). Ask whether it matches their
intent. Revise until they confirm.

## Terminal state

The user has approved the design summary. Point them to `/to-spec` to turn the conversation
into a spec file. Do not write the spec, a plan, or any code yourself — this skill ends at
shared understanding.
