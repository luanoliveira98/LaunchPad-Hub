const fs = require('fs');
const path = require('path');

const getTemplateNames = (dir) => {
  const templates = [];
  const categories = fs.readdirSync(dir);

  categories.forEach((category) => {
    const categoryPath = path.join(dir, category);
    if (fs.statSync(categoryPath).isDirectory()) {
      const subTemplates = fs.readdirSync(categoryPath);
      subTemplates.forEach((template) => {
        if (fs.statSync(path.join(categoryPath, template)).isDirectory()) {
          templates.push(template);
        }
      });
    }
  });

  return templates;
};

const allowedScopes = ['launchpad-hub', ...getTemplateNames(path.resolve(__dirname, 'templates'))];

module.exports = {
  extends: ['@commitlint/config-conventional'],
  parserPreset: {
    parserOpts: {
      headerPattern: /^(\w+)\[(.+)\]: (.+)$/,
      headerCorrespondence: ['type', 'scope', 'subject'],
    },
  },
  rules: {
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'perf', 'test', 'build', 'ci', 'chore', 'revert'],
    ],
    'scope-empty': [2, 'never'],
    'scope-enum': [2, 'always', allowedScopes],
    'subject-empty': [2, 'never'],
    'header-max-length': [2, 'always', 120],
  },
};