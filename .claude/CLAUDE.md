# Coding Guidelines

## Basic Principles

- Always run linting, tests, and builds after making changes
- Don't add new comments (keep existing comments as-is)
- Follow testing philosophies and design principles from t_wada, Kent C Dodds,
  and Martin Fowler
- YAGNI (You Aren't Gonna Need It)
  - Only add code that's needed right now
  - Adding code "just in case" introduces unnecessary complexity that can get in
    the way
  - Prioritize simplicity over generalization and implement only what's
    currently needed
- KISS (Keep It Simple, Stupid)
  - Code should be as simple as possible
  - Overly complex code is more prone to bugs and harder to maintain
  - Always ask yourself: "What's the simplest way to make this work?"
- DRY (Don't Repeat Yourself)
  - Avoid duplicating code
  - Repeated code increases volume, takes more time to modify, and makes the
    codebase harder to understand
  - Extract common logic into functions to maintain clean, organized code

## MCP Servers

- Use Context7 MCP
- Use Sequential Thinking MCP Server
- Use Serena MCP Server

## SuperClaude Framework Components

### Core Framework

@BUSINESS_PANEL_EXAMPLES.md @BUSINESS_SYMBOLS.md @FLAGS.md @PRINCIPLES.md
@RESEARCH_CONFIG.md @RULES.md

### Behavioral Modes

@MODE_Brainstorming.md @MODE_Business_Panel.md @MODE_DeepResearch.md
@MODE_Introspection.md @MODE_Orchestration.md @MODE_Task_Management.md
@MODE_Token_Efficiency.md

### MCP Documentation

@MCP_Context7.md @MCP_Magic.md @MCP_Morphllm.md @MCP_Playwright.md
@MCP_Sequential.md @MCP_Serena.md @MCP_Tavily.md

## Git and Pull Request Workflow

- Please use .github/PULL_REQUEST_TEMPLATE.md if it exists
- Please follow the existing codes

## React Guidelines

- Use React Server Components whenever possible
  - Handle data fetching on the server side
- Keep Client Components as leaf components when possible
  - Implement interactions like onClick using Server Actions
- Follow the Container/Presentational pattern whenever feasible

## General Notes

- Document any architectural discoveries or configuration insights in this
  CLAUDE.md file
- Add universally important findings that apply across projects to this file
