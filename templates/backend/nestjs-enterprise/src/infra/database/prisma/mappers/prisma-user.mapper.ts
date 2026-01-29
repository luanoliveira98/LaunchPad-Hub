import { UniqueEntityID } from '@/core/entities/value-objects/unique-entity-id';
import { User } from '@/domain/account/entities/user';
import type { Prisma, User as PrismaUser } from 'generated/prisma/client';

export class PrismaUserMapper {
  static toDomain(raw: PrismaUser): User {
    return User.create(
      {
        email: raw.email,
        password: raw.password,
      },
      new UniqueEntityID(raw.id),
    );
  }

  static toPrisma(user: User): Prisma.UserUncheckedCreateInput {
    return {
      id: user.id.toValue(),
      email: user.email,
      password: user.password,
    };
  }
}
