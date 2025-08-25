---
description: Review a pull request based on issue number
---

## Context

- View information of the PR: !`gh pr view "$ARGUMENTS"`
- View diff of the PR: !`gh pr diff "$ARGUMENTS"`

## Your Task

Provide a detailed pull request review on Github issue: $ARGUMENTS. Based on the above, follow these steps:

- Understand the intent of the PR using the PR description
- If PR description is not detailed enough to understand the intent of the PR, make sure to note it in your review
- Make sure the PR title foolows Conventional Commits. Here are the last 10 commits to the repo as examples: !`git log --oneline -10`
- Search the codebase if required
- Write a concise review of the PR, keepingin mind to encourage strong code quality and best practices
- Use `gh pr comment $ARGUMENTS --body {{review}}` to post the reviewto the PR

Remember to use the Github CLI (`gh`) with the Bash tool for all GitHub-related tasks.
