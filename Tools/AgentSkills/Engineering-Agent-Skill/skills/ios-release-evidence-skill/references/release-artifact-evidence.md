# What a built artifact proves

> **TIME-SENSITIVE.** Compiler behaviour and tooling change. Re-verify the limits below on your toolchain.

## Symbols versus strings

**Symbols.** A symbol table query gives a usable presence/absence answer. Zero occurrences of a function name is
real evidence that the function is not in the binary.

**Short strings.** Absence is **not** provable this way. Compiled languages inline short literals; Swift stores
small strings directly inside the string structure rather than in a separate section. A short string that a
strings dump cannot find may be perfectly present.

So:

- a symbol at zero occurrences → evidence of absence, bounded to that binary;
- a short string not found → **no conclusion**; say the instrument cannot decide it.

Know this before promising anyone that a piece of text does not ship.

## Compiled versus reachable

A type can be compiled into the artifact while every call site is excluded by conditional compilation. Its
symbols ship; it can never execute.

Report that as **present but unreachable**, with how you know the call sites are excluded. It is not "absent",
and pretending otherwise fails the moment someone runs the symbol query themselves.

The structural fix — wrapping the type's own file in the same condition as its callers — turns a property that
depends on every caller into one that holds by construction. Worth proposing; not worth claiming as done.

## Bundle contents

Check what is at the bundle root, not only what the project lists. A generated project is regenerated, and a
resource can silently stop being copied. Anything a reviewer or a platform requires **inside** the bundle must
be verified inside the bundle.

Also inspect linked libraries. It is the cheapest way to confirm that no third-party dependency crept in, and it
answers the question directly rather than by inspecting dependency manifests.

## Debug instrumentation

To claim developer instrumentation does not ship:

1. name each instrument;
2. query the Release artifact for each symbol;
3. report the count per instrument, not a summary;
4. for anything that comes back non-zero, determine compiled-versus-reachable rather than rewording it;
5. state the boundary: this artifact, this commit.

## Configuration matters

Evidence from a Debug artifact says nothing about Release. Build the real thing. This sounds obvious and is the
most frequently skipped step, because the Debug artifact is already there.
