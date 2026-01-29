# 🏛️ NestJS Enterprise Template

This is a high-level NestJS boilerplate designed for scalable, maintainable, and testable applications using **Clean Architecture** and **Domain-Driven Design (DDD)** principles.

## 🏗️ Architecture Overview

The project is structured into layers to ensure a strict separation of concerns:

- **`src/domain`**: The core of the application. Contains Business Entities, Value Objects, and Repository Interfaces (Contracts). It has zero dependencies on external frameworks.
- **`src/application`**: Orchestrates business logic using Use Cases. It depends only on the Domain layer and defines interfaces for technical services (Gateways).
- **`src/infra`**: Implementation details. Contains the NestJS modules, HTTP Controllers, Prisma Repositories, and Environment configurations.
- **`src/@shared`**: Common utilities, Base Classes (Entity, ValueObject), and Helpers (Either/Result patterns) used across all layers.

## 🛠️ Tech Stack

- **Framework**: [NestJS](https://nestjs.com/)
- **Language**: TypeScript
- **ORM**: [Prisma](https://www.prisma.io/)
- **Validation**: [Zod](https://zod.dev/)
- **Testing**: [Vitest](https://vitest.dev/) (Unit & E2E)
- **Code Quality**: ESLint, Prettier, and Commitlint

## 🚀 Getting Started

### 1. Environment Setup

Copy the example environment file and fill in your database credentials:

```bash
cp .env.example .env
```

### 2. Install Dependencies

```bash
pnpm install
```

### 3. Database Migration

```bash
pnpm prisma migrate deploy
```

### 4. Running the App

```bash
# development
pnpm start:dev

# production mode
pnpm build
pnpm start:prod
```

## 🧪 Testing Strategy

This template is configured with **Vitest** for maximum speed.

- **Unit Tests:** Focus on Domain Entities and Application Use Cases (using In-Memory Repositories).

```bash
pnpm test
```

- **E2E Tests:** Focus on Infrastructure and HTTP routes (using a real/test database).

```bash
pnpm test:e2e
```

📂 Folder Structure Detail

```Plaintext
src/
├── @shared/              # Shared logic & Base classes
├── domain/               # Enterprise Business Rules
│   └── [context]/
│       ├── entities/
│       └── repositories/ # Interfaces only
├── application/          # Application Business Rules
│   └── [context]/
│       └── use-cases/
└── infra/                # Frameworks & Drivers (NestJS/Prisma)
    ├── database/
    ├── http/
    └── env/
```

Developed as part of the **LaunchPad Hub** automation engine.
