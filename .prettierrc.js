module.exports = {
  semi: false,
  singleQuote: true,
  tabWidth: 2,
  bracketSpacing: true,
  trailingComma: 'es5',
  printWidth: 120,
  arrowParens: 'avoid',
  quoteProps: 'as-needed',
  endOfLine: 'lf',
  jsxSingleQuote: true,
  proseWrap: 'preserve',
  overrides: [
    {
      files: '*.md',
      options: {
        proseWrap: 'always',
        printWidth: 80,
      },
    },
  ],
}
