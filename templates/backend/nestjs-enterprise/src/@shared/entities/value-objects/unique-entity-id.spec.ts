import { UniqueEntityID } from './unique-entity-id';

describe('UniqueEntityID', () => {
  it('should create a unique identifier', () => {
    const id = new UniqueEntityID();

    expect(typeof id.toValue()).toBe('string');
  });

  it('should create a unique identifier with a provided value', () => {
    const value = 'custom-id-123';
    const id = new UniqueEntityID(value);

    expect(id.toValue()).toBe(value);
  });

  it('should convert to string correctly', () => {
    const id = new UniqueEntityID();

    expect(id.toString()).toBe(id.toValue());
  });

  it('should convert to JSON correctly', () => {
    const id = new UniqueEntityID();

    expect(id.toJSON()).toBe(id.toValue());
  });

  it('should consider two identifiers with the same value as equal', () => {
    const value = 'same-id-456';
    const id1 = new UniqueEntityID(value);
    const id2 = new UniqueEntityID(value);

    expect(id1.equals(id2)).toBe(true);
  });

  it('should consider two identifiers with different values as not equal', () => {
    const id1 = new UniqueEntityID();
    const id2 = new UniqueEntityID();

    expect(id1.equals(id2)).toBe(false);
  });
});
