import { Entity } from '@/core/entities/entity';
import type { UniqueEntityID } from '@/core/entities/value-objects/unique-entity-id';

export interface UserProps {
  email: string;
  password: string;
}

export class User extends Entity<UserProps> {
  get email(): string {
    return this.props.email;
  }

  get password(): string {
    return this.props.password;
  }

  static create(props: UserProps, id?: UniqueEntityID): User {
    const user = new User(props, id);
    return user;
  }
}
