import { RegisterUserUseCase } from '@/application/account/use-cases/register-user';
import { UserAlreadyExistsError } from '@/domain/account/errors/user-already-exists.error';
import {
  BadRequestException,
  Body,
  ConflictException,
  Controller,
  HttpCode,
  Post,
} from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { createZodDto } from 'nestjs-zod';
import z from 'zod';

const bodySchema = z.object({
  email: z.string(),
  password: z.string(),
});

class BodySchemaDto extends createZodDto(bodySchema) {}

@ApiTags('Accounts')
@Controller('/accounts')
export class CreateAccountController {
  constructor(private readonly registerUserUseCase: RegisterUserUseCase) {}

  @Post()
  @ApiOperation({ summary: 'Register a new user' })
  @ApiResponse({ status: 201, description: 'User registered successfully' })
  @HttpCode(201)
  async handle(@Body() body: BodySchemaDto) {
    const { email, password } = body;

    const result = await this.registerUserUseCase.execute({ email, password });

    if (result.isLeft()) {
      const error = result.value;

      switch (error.constructor) {
        case UserAlreadyExistsError:
          throw new ConflictException(error.message);
        default:
          throw new BadRequestException(error.message);
      }
    }
  }
}
