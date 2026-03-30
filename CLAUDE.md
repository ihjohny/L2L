# Claude Code Instructions

## Commit Policy - STRICT RULE

**NEVER commit changes unless the user explicitly requests a commit.**

### What counts as an explicit commit request:
- "commit the changes"
- "make a commit"
- "commit with message: ..."
- "git commit"
- Any direct instruction containing the word "commit"

### What does NOT count as a commit request:
- Implementation instructions (e.g., "add feature X", "fix bug Y", "refactor Z")
- Task descriptions (e.g., "do this", "update that")
- Requests to show changes, diff, or status
- Any instruction that does not explicitly mention "commit"

### Required behavior:
1. After completing any task, STOP and wait for explicit commit instruction
2. Do NOT auto-commit after completing features or fixes
3. Do NOT assume completion implies commit permission
4. Always ask "Would you like me to commit these changes?" if unsure
