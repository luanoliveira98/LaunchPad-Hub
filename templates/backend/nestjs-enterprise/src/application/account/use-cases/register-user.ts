import type { HashGenerator } from '@/application/cryptography/hash-generator';
import { left, type Either, right } from '@/core/helpers/either.helper';
import { User } from '@/domain/account/entities/user';
import { UserAlreadyExistsError } from '@/domain/account/errors/user-already-exists.error';
import type { UsersRepository } from '@/domain/account/repositories/users.repository';

interface RegisterUserUseCaseRequest {
  email: string;
  password: string;
}

type RegisterUserUseCaseResponse = Either<
  UserAlreadyExistsError,
  { user: User }
>;

export class RegisterUserUseCase {
  constructor(
    private readonly usersRepository: UsersRepository,
    private readonly hashGenerator: HashGenerator,
  ) {}

  async execute({
    email,
    password,
  }: RegisterUserUseCaseRequest): Promise<RegisterUserUseCaseResponse> {
    const userAlreadyExists = await this.usersRepository.findByEmail(email);

    if (userAlreadyExists) {
      return left(new UserAlreadyExistsError(email));
    }

    const hashedPassword = await this.hashGenerator.hash(password);

    const user = User.create({
      email,
      password: hashedPassword,
    });

    await this.usersRepository.create(user);

    return right({ user });
  }
}
