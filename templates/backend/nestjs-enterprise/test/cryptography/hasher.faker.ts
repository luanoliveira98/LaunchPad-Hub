import type { HashComparer } from '@/application/cryptography/hash-comparer';
import type { HashGenerator } from '@/application/cryptography/hash-generator';

export class HasherFake implements HashComparer, HashGenerator {
  async hash(plain: string): Promise<string> {
    return plain.concat('-hashed');
  }

  async compare(plain: string, hash: string): Promise<boolean> {
    return hash === plain.concat('-hashed');
  }
}
