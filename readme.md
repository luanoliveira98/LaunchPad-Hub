# 🚀 LaunchPad Hub

**LaunchPad Hub** is a modular automation engine designed to bootstrap high-quality projects with standardized configurations. It enforces **Clean Architecture**, **Enterprise Patterns**, and consistent tooling (ESLint, Prettier, Husky) across all generated applications.

## 🛠️ Core Features

- **Standardized Tooling**: All projects inherit a shared configuration for code quality.
- **Modular Presets**: Ready-to-use templates for Backend (NestJS, Express) and Frontend.
- **Clean Architecture by Default**: Generated templates follow Domain-Driven Design (DDD) principles.
- **Smart Scaffolding**: Automated scripts for creating both new templates and final projects.

---

## 🏗️ Project Structure

```text
.
├── scripts/                # Automation engine
│   ├── generate-project.sh # Clones a template into a new project
│   └── generate-template.sh# Orchestrates new template creation
├── templates/              # Base blueprints (Backend, Frontend, Mobile)
│   └── backend/
│       └── nestjs-enterprise/
└── tooling/                # Shared rules (ESLint, Prettier, Husky)
    └── shared-configs/
```

## 🚀 Getting Started

### 1. Generating a New Template

If you want to create a new blueprint for the Hub:

```Bash
bash scripts/generate-template.sh
```

### 2. Generating a Final Project

To start a new application based on an existing template:

```Bash
bash scripts/generate-project.sh
```

## 📦 Featured Template: NestJS Enterprise

Our flagship backend template follows the highest industry standards:

- **Layers:** Domain, Application, and Infrastructure (DDD).
- **ORM:** Pre-configured with Prisma (optional).
- **Testing:** Vitest with Factory and Repository patterns.
- **Validation:** Environment variables validation and Zod integration.

## 🛠️ Technologies Used

- **Shell Scripting (Bash):** For the automation engine.
- **TypeScript:** Primary language for templates.
- **NestJS:** Enterprise-grade backend framework.
- **Prisma:** Next-generation ORM.
- **Vitest:** Blazing fast unit and E2E testing.

## 📜 License

This project is for portfolio and professional development purposes. Feel free to use and adapt it.

Developed with ☕ and focus on Developer Experience.
