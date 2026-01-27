import { Entity } from './entity';
import { UniqueEntityID } from './value-objects/unique-entity-id';

class Text extends Entity<{ text: string }> {
  constructor(props: { text: string }, id?: UniqueEntityID) {
    super(props, id);
  }
}

describe('Entity', () => {
  it('should create an entity instance', () => {
    const entity = new Text({ text: 'example' });
    expect(entity).toBeDefined();
  });

  it('should return the unique identifier of the entity', () => {
    const entity = new Text({ text: 'example' });
    expect(entity.id).toBeInstanceOf(UniqueEntityID);
  });

  it('should consider two entities with the same ID as equal', () => {
    const id = new UniqueEntityID();
    const entity1 = new Text({ text: 'example1' }, id);
    const entity2 = new Text({ text: 'example2' }, id);

    expect(entity1.equals(entity2)).toBe(true);
  });

  it('should consider two entities with different IDs as not equal', () => {
    const entity1 = new Text({ text: 'example1' });
    const entity2 = new Text({ text: 'example2' });

    expect(entity1.equals(entity2)).toBe(false);
  });

  it('should consider an entity equal to itself', () => {
    const entity = new Text({ text: 'example' });

    expect(entity.equals(entity)).toBe(true);
  });
});
