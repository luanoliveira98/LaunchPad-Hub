import type { UseCaseError } from '@/core/errors/use-case.error';

export class UserAlreadyExistsError extends Error implements UseCaseError {
  constructor(indetifier: string) {
    super(`User with email "${indetifier}" already exists.`);
  }
}
