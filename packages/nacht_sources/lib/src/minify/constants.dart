/// The tags allowed in the cleaned html
const kAllowedTags = {
  'div',

  // Heading tags.
  "h1",
  "h2",
  "h3",
  "h4",
  "h5",
  "h6",

  "p",

  // Styling tags.
  "b",
  "strong",
  "i",
  "em",

  "hr",
  "br",

  // Table tags.
  'table',
  'tr',
  'th',
  'tb',

  // Images
  'img',
};

/// The allowed attributes on per tag basis
const kAllowedAttributes = <String, Set<String>>{
  'img': {'src', 'alt'},
  'a': {'href'},
};

/// The tags allowed to start a new section
const kBaseTags = {
  'p',
};
