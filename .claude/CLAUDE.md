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
- SOLID Principles
  - Single Responsibility Principle (SRP)
    - A class or module should have only one reason to change
    - Each component should focus on doing one thing well
    - Separate concerns to improve maintainability and testability
  - Open/Closed Principle (OCP)
    - Software entities should be open for extension but closed for modification
    - Design modules so new functionality can be added without changing existing
      code
    - Use abstraction and polymorphism to achieve extensibility
  - Liskov Substitution Principle (LSP)
    - Subtypes must be substitutable for their base types
    - Derived classes should extend without replacing the functionality of base
      classes
    - Ensure that inheritance hierarchies are properly designed
  - Interface Segregation Principle (ISP)
    - Clients should not be forced to depend on interfaces they don't use
    - Create specific, focused interfaces rather than large, general-purpose
      ones
    - Split large interfaces into smaller, more cohesive ones
  - Dependency Inversion Principle (DIP)
    - High-level modules should not depend on low-level modules; both should
      depend on abstractions
    - Abstractions should not depend on details; details should depend on
      abstractions
    - Use dependency injection to achieve loose coupling

## MCP Servers

- Use Context7 MCP
- Use Sequential Thinking MCP Server
- Use Serena MCP Server

## Git and Pull Request Workflow

- Please use .github/PULL_REQUEST_TEMPLATE.md if it exists
- Please follow the existing codes
- Please use the gh command if you need to access GitHub

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
