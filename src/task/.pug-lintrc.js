// reworked from @lcooper/pug-lint-config
module.exports = {
  // General formatting
  validateIndentation: 2,
  validateLineBreaks: 'LF',
  validateAttributeQuoteMarks: "'",
  disallowTrailingSpaces: true,
  maximumLineLength: null,
  maximumNumberOfLines: null,
  disallowMultipleLineBreaks: true,
  requireLineFeedAtFileEnd: true,
  // Attribute values
  disallowAttributeConcatenation: true,
  disallowAttributeInterpolation: null,
  disallowAttributeTemplateString: null,
  // Attribute rules
  disallowDuplicateAttributes: true,
  validateAttributeSeparator: ' ',
  // Id literals
  disallowIdLiterals: true,
  disallowIdAttributeWithStaticValue: null,
  disallowIdLiteralsBeforeAttributes: null,
  requireIdLiteralsBeforeAttributes: null,
  disallowClassLiteralsBeforeIdLiterals: null,
  requireClassLiteralsBeforeIdLiterals: null,
  // Class literals
  disallowClassLiterals: null,
  disallowClassAttributeWithStaticValue: true,
  disallowClassLiteralsBeforeAttributes: null,
  requireClassLiteralsBeforeAttributes: null,
  // Space after code operator
  disallowSpaceAfterCodeOperator: null,
  requireSpaceAfterCodeOperator: true,
  // Space inside attribute brackets
  disallowSpacesInsideAttributeBrackets: true,
  requireSpacesInsideAttributeBrackets: null,
  // Specific attribute rules
  disallowSpecificAttributes: [{ a: 'name', }],
  requireSpecificAttributes: [{ input: 'type', }],
  disallowSpecificTags: null,
  // String rules
  disallowStringConcatenation: true,
  disallowTemplateString: null,
  // Interpolation rules
  disallowStringInterpolation: null,
  disallowTagInterpolation: null,
  // Enforce lowercase
  requireLowerCaseAttributes: true,
  requireLowerCaseTags: true,
  // Validate
  validateDivTags: true,
  validateExtensions: true,
  validateSelfClosingTags: true,
  validateTemplateString: true,
  // Misc
  requireStrictEqualityOperators: true,
  disallowBlockExpansion: null,
  disallowHtmlText: null,
  disallowLegacyMixinCall: true,
};
