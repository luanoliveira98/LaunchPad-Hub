import { InMemoryUsersRepository } from 'test/repositories/in-memory-users.repository';
import { RegisterUserUseCase } from './register-user';
import { HasherFake } from 'test/cryptography/hasher.faker';
import { makeUser } from 'test/factories/make-user.factory';

describe('Register User', () => {
  let sut: RegisterUserUseCase;
  let inMemoryUsersRepository: InMemoryUsersRepository;
  let hasherFake: HasherFake;

  beforeEach(() => {
    inMemoryUsersRepository = new InMemoryUsersRepository();
    hasherFake = new HasherFake();

    sut = new RegisterUserUseCase(inMemoryUsersRepository, hasherFake);
  });

  it('should not be able to register a user with an existing email', async () => {
    const user = makeUser();
    await inMemoryUsersRepository.create(user);

    const response = await sut.execute({
      email: user.email,
      password: 'any_password',
    });

    expect(response.isLeft()).toBe(true);
    expect(response.value).toBeInstanceOf(Error);
  });

  it('should be able to register a user', async () => {
    const response = await sut.execute({
      email: 'any_email@example.com',
      password: 'any_password',
    });

    const hashedPassword = await hasherFake.hash('any_password');

    expect(response.isRight()).toBe(true);
    expect(response.value).toEqual({
      user: inMemoryUsersRepository.items[0],
    });
    expect(inMemoryUsersRepository.items[0].password).toEqual(hashedPassword);
  });
});
