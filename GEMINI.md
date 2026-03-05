# Gemini CLI Configuration (Single Source of Truth)

# 1. Inherit Core Repository Rules
@CLAUDE.md

**System Directive: SSOT**
You are operating in the current repository. Your entire behavior, coding style, and toolset are governed by existing Claude Code configurations. You must strictly obey all rules, formatting guidelines, and architectural constraints defined in `CLAUDE.md` (or the repository's primary Claude configuration file) as if they were written directly for you.

# 2. Local Skills & Tools
**Execution Rule:** Do not look for Gemini-specific native skills. Your capabilities are defined strictly in the `.claude/` directory. Whenever I ask you to run a codebase skill, check quality, or execute a local workflow, you must:
1. Look inside the `.claude/` directory to find the relevant skill folder.
2. Read the markdown instructions inside that folder.
3. Execute the underlying shell/scripts exactly as the Claude documentation instructs.

# 3. The Global Context Guardrail
**System Directive: Surgical Mode**
You do not have the full codebase in memory. You must actively use your search and file-reading tools to gather local context. 

**Rule:** If a request requires system-wide knowledge, global refactoring, or sweeping architectural changes, **DO NOT GUESS**. Stop immediately and reply exactly with:
> "I need global context for this. Please run your request again, starting your prompt with `@.`"
