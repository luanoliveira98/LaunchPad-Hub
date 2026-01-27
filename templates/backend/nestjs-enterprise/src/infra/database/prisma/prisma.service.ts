import { envSchema } from '@/infra/env/env';
import {
  Injectable,
  type OnModuleDestroy,
  type OnModuleInit,
} from '@nestjs/common';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from 'generated/prisma/client';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  constructor() {
    const env = envSchema.parse(process.env);
    const connectionString = process.env.DATABASE_URL!;
    const schema =
      new URL(connectionString).searchParams.get('schema') || 'public';

    const adapter = new PrismaPg(
      {
        connectionString,
      },
      { schema },
    );

    super({
      adapter,
      log: ['warn', 'error'],
    });
  }

  async onModuleInit() {
    await this.$connect();
  }

  onModuleDestroy() {
    return this.$disconnect();
  }
}
