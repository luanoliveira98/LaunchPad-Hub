import swc from 'unplugin-swc';
import { configDefaults, defineConfig } from 'vitest/config';
import tsConfigPaths from 'vite-tsconfig-paths';

const exclude = [
  ...configDefaults.exclude,
  'test/**',
  '**/entities/**',
  '**/*.mapper.ts',
  '**/*.builder.ts',
];

export default defineConfig({
  test: {
    globals: true,
    root: './',
    exclude,
    coverage: {
      provider: 'v8',
      exclude,
      reporter: ['text', 'json', 'html'],
      thresholds: {
        statements: 90,
        branches: 90,
        functions: 90,
        lines: 90,
      },
    },
  },
  plugins: [
    tsConfigPaths({
      loose: true,
      root: '.',
    }),
    swc.vite({
      module: { type: 'es6' },
    }),
  ],
});
