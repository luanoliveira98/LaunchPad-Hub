import type { UniqueEntityID } from '@/core/entities/value-objects/unique-entity-id';
import { User } from '@/domain/account/entities/user';
import { faker } from '@faker-js/faker';

export function makeUser(overrides: Partial<User> = {}, id?: UniqueEntityID) {
  const user = User.create(
    {
      email: faker.internet.email(),
      password: faker.internet.password(),
      ...overrides,
    },
    id,
  );

  return user;
}
