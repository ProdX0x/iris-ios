# Human validation

What a machine cannot settle, and how to record what a human says.

## Two domains, not two grades

Automated evidence is not inferior, and human evidence is not superior. They answer different questions. Asking
a person to confirm something a test already proves wastes the one resource that does not scale.

| A machine settles | A human settles |
|---|---|
| a symbol, string, or file is present or absent | whether a transition is *noticeable* |
| a value, a hash, a count | whether wording is understood without explanation |
| non-regression on what was already covered | whether an interaction feels right |
| that a layout fits a width | whether it is *comfortable* |
| that no animation is declared | what a screen reader actually says |
| that a build succeeded and installed | whether the thing is any good |

## Before asking

List what the machine already established, so the person is not asked to re-verify it. Then list only what
requires them. A checklist that mixes both wastes their attention on the wrong half.

Leave every item **unchecked**. A pre-filled checklist is a fabricated result.

## Recording a verdict

**At the grain it was given.** If a person says "the whole thing passed", record that the whole thing passed,
and note that item-level results were not reported. Expanding a global verdict into eighteen individual ticks
invents evidence.

If they mention a specific problem, record that specifically.

## The third state

A point may be **out of criterion** — neither passed nor failed — when it is deliberately outside what this
release requires. That is legitimate, and better than the alternatives of lying or blocking. It needs:

- the reason, in one line;
- what it does **not** license. Declaring an accessibility technology out of criterion for one release is not a
  statement that the product is accessible, nor permission to degrade what exists.

Without those two, "out of criterion" becomes a way to make inconvenient criteria disappear.

## Never

- record a human PASS without a human;
- treat an install, a build, or a screenshot as a visual validation;
- infer a per-item result from a global one;
- ask a human to confirm something a test proves;
- present a machine result as a human one, or the reverse.

## Pending is a result

If no human verdict exists, the status is `PENDING` — not `PASS`, not `assumed fine`. A release report with
`HUMAN VALIDATION: PENDING` is honest and actionable. One with an invented `PASS` is neither.
