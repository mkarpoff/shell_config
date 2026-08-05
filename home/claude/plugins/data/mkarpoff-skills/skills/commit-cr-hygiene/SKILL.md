---
name: commit-cr-hygiene
description: Commit and CRUX code review hygiene for Brazil workspaces. Use when committing changes, creating or updating CRUX code reviews, managing stacked CRs, or rebasing dependent CRs after a base change.
version: 1.0.0
---

# Commit & Code-Review (CRUX) Hygiene

## Overview
Rules and procedures for clean commits and CRUX code reviews in Brazil workspaces, including the critical procedure for safely updating a CR at the bottom of a stack.

## Usage
Use this skill when:
- Committing changes to a Brazil package
- Creating or updating a CRUX code review
- Managing multiple dependent (stacked) CRs
- Rebasing a CR stack after a base CR is amended
- Deciding whether changes should be independent or stacked CRs

## Core Concepts

### Commit Rules

1. **Build before every commit.** `brazil-build` (release) must pass first — no exceptions. Run the gating build in the **foreground**: a backgrounded build's hook sees the "running in background" launch line, not `BUILD SUCCEEDED`, so any pass-marker never records.
2. **Conventional Commits**, single-sentence subject: `feat|fix|docs|style|refactor|perf|test|chore|ci|build: <subject>`. Imperative mood, capitalized, ≤50 chars, no trailing period. Body explains what/why (wrap at 72); add a `sim:` trailer with the task URL.
3. **One commit per feature / per CR.** Don't pile on follow-up commits. **Amend** fixes into the single feature commit and cut a new revision.
4. **Per-package commits.** Each Brazil package is its own git repo, so changes spanning packages = one commit **per package**.
5. **Sync first.** Pull `origin/mainline` (per repo) before committing/CR'ing, and verify your local branch contains all remote commits — CRUX auto-merge can push without explicit action, so `git fetch` before assuming a commit is local-only.
6. **Never** `git push` (unless explicitly authorized), force-push, rewrite pushed history, `git reset --hard`, or `git clean`. Fix-forward only.
7. **Get review before committing** feature code — unless the author has said they're working autonomously/away, in which case keep everything DRAFT.
8. **Never commit** local coordination files (e.g. `.superpowers/`) into a CR.

### CR Description Template

When writing a CR description, first check if the package has a CR template (e.g. `.crux/template.md` or similar). If one exists, use it. If not, use this default template:

```
### Summary
<Description of changes + any resources that should be linked>

#### Testing
<How the change was tested. Include links to test artifacts if available>

#### Issues
* https://i.amazon.com/<IssueId>
```

The `#### Issues` section with linked issue URL(s) must **always** appear at the bottom, regardless of which template is used.

### Issue Linking

When creating a CR, prefer passing `--issue <IssueID>` (e.g. `cr --issue SIM-12345 -d mainline`). This automatically:
- Adds the SIM URL as a trailer in the git commit message
- Appends the issue to the CR description (if `--description` was not provided)

If the issue needs to be added **after** the CR already exists, two things must happen:

1. **Amend the commit** to include the SIM and CR trailers:
   ```
   feat: commit message text...

   SIM: https://i.amazon.com/<IssueID>
   cr: https://code.amazon.com/reviews/<CRID>
   ```

2. **Append an Issues section** to the bottom of the CR description:
   ```
   CR Description body
   ...
   ...
   ...
   #### Issues
   * https://i.amazon.com/<IssueID>
   ```

Then push a new revision so both the commit and CR description reflect the linked issue.

### CR (CRUX) Rules

1. **Always pass the destination branch:** `cr ... -d mainline`. Omitting it:
   - Faults the **Dry-Run Build** ("Package X is missing a destination branch") and cascades the merge-gating analyzers to Blocked.
   - Makes **AutoSDE emit a false-positive** "commit message is `api-invoke`, not Conventional-Commits" finding — it can't resolve the merge base so it misreads the commit range. Don't "fix" the message; it disappears once `-d mainline` is set.
2. **Description body must link a document** (SIM/Taskei task URL, design doc, or wiki). The **CR Detective** partner fails the CR if the description has no doc link — a `sim:` trailer in the *commit* is not sufficient (CR Detective checks the description body). Using `--issue <IssueID>` at CR creation satisfies this automatically. If adding the issue after the fact, see the **Issue Linking** section above. If there is genuinely no doc, don't block publishing over it — proceed and explicitly flag it so a link can be added later. **When writing a CR description yourself, use the CR Description Template below.**
3. **Keep CRs in DRAFT** until explicitly told otherwise. Never `--publish`.
4. **Run AutoSDE locally before pushing** a revision (including inherited/custom rules), then keep polling AutoSDE **on the CR** until **zero comments**; fix and re-cut. All CRs must reach zero AutoSDE comments before they're "done".
5. **Title format:** `[PackageName] <subject>`, or `[PackageName + N more] <summary>` (≤80 chars) when multiple packages change.
6. **Addressing feedback = amend, not add.** Amend the fix into the existing single commit, then push a new revision — don't stack fixup commits.

## Independent vs. Stacked Changes

Before doing anything with multiple changes, answer one question: **are they independent, or does one depend on another?** That decides everything.

### Independent changes
- One commit + one **DRAFT** CR per feature — never one giant CR.
- Each gets its own conventional-commit message, its own doc link, its own local AutoSDE pass, all with `-d mainline`.
- Multi-package? A separate commit in each package's repo, CRs scoped per package.

### Stacked (dependent) changes
- **Only stack on a *true* code dependency.** If the changes don't actually depend on each other, cut independent parallel CRs to mainline instead — a stack you didn't need is pure overhead.
- **Keep stacks shallow (≤2–3) and land the base fast.** Every stacked CR below yours is churn you inherit each time the base moves. The cheapest way to shrink that cost is to merge the bottom CR quickly so the stack collapses.
- Stack the CRs in dependency order on feature branches.
- **Declare the dependency with `--stack`.** Pass the CR IDs this one depends on when cutting the upper CR:
  ```bash
  # cut the base first, then the CR that depends on it
  cr --new-review -d mainline --parent HEAD^                        # → CR-111
  cr --new-review -d mainline --parent HEAD^ --stack CR-111         # → CR-222, depends on CR-111
  ```
  `--stack` takes a comma-separated list (`--stack CR-111,CR-222`) for a deeper stack. It registers the lower CR as a `REVIEW`-type dependency on the upper one, which is visible in the CR's reviewers/dependencies and to tooling — unlike a prose note, which only works if a human reads it. Verify it landed with `CodeReviewReadActions get-cr-info`: the base CR should appear in `reviewers` with `"type":"REVIEW"`.
- **Still add the "Blocks AutoVerify — stacked, merge in order" note** to each description, naming the CR that must merge first. `--stack` records the relationship; the note is what tells a *human* reviewer why the order matters. A stacked CR's build passes locally (the workspace contains *all* the changes) but the pipeline version-set build fails after merge if the lower CR hasn't landed yet.

> **Note:** The manual rebase-up-the-stack procedure below is the correct *fallback*, not a goal to design around. It is inherently repetitive (rebuild + re-cut + re-run AutoSDE at every level, every time the base changes). Prefer shallow stacks and a fast-landing base so you rarely have to run it deep.

## The Hard Case: Updating a CR at the Bottom of a Stack

Say **PackageA** has three stacked CRs, each a single amended commit, each built on the one below it:

```
CR1  →  hash1        (base: origin/mainline)
CR2  →  hash2        (base: hash1)
CR3  →  hash3        (base: hash2)
```

Now **CR1 needs a change** (review feedback, a bug, whatever).

### Why you can't just fix CR1 and stop
CR1's commit is the *parent* of CR2's commit, which is the parent of CR3's. When you amend CR1, its hash changes — CR2 and CR3 are now built on a base that no longer exists. **You must propagate the change up the stack.**

### The procedure

1. **Amend CR1** on its branch (don't add a new commit — keep it one commit):
   ```bash
   # on the CR1 branch
   <make the fix>
   brazil-build   # foreground, must pass
   git commit --amend      # keeps CR1's single commit, produces hash1'
   ```

2. **Rebase CR2 onto the new CR1**, using `--onto` with the **old** CR1 tip (`hash1`) explicitly:
   ```bash
   # on the CR2 branch
   git rebase --onto <CR1-branch> hash1 <CR2-branch>
   brazil-build   # foreground, must pass
   ```

3. **Rebase CR3 onto the new CR2**, same `--onto` form naming the **old** CR2 tip (`hash2`):
   ```bash
   # on the CR3 branch
   git rebase --onto <CR2-branch> hash2 <CR3-branch>
   brazil-build
   ```

4. **Re-cut a revision on each CR, bottom to top**, always with `-d mainline`, re-passing `--stack` so the dependency is not dropped on the new revision:
   ```bash
   cr -r CR-1 --parent "HEAD^" -d mainline
   cr -r CR-2 --parent "HEAD^" -d mainline --stack CR-1
   cr -r CR-3 --parent "HEAD^" -d mainline --stack CR-2
   ```

5. **Re-run AutoSDE on all three** (a base change can surface new findings) and poll each to zero comments.

**Rule of thumb:** Touch a CR → fix every CR above it.

## Why DRAFT Matters

Keeping every CR in **DRAFT** through the iteration loop is deliberate:

- **No reviewer spam.** Rebasing a 3-deep stack means pushing a new revision to all three CRs — potentially multiple times. In DRAFT, those revisions don't fire notifications or invite premature review.
- **Blocks AutoVerify from merging mid-rebase.** A stacked CR whose lower dependency hasn't merged must not auto-merge. DRAFT keeps it out of the merge path while you iterate.
- **Lets you converge before anyone looks.** Publish only once the full stack is rebased, green, and at zero AutoSDE comments — so a human reviews a coherent stack, not a stream of intermediate revisions.

Amending (never adding fixup commits) is what keeps each CR at **one clean commit**; DRAFT is what keeps the iteration quiet and un-mergeable until you're ready.
