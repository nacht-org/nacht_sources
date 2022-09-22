const dublinCore = [
  "title",
  "language",
  "subject",
  "creator",
  "contributor",
  "publisher",
  "rights",
  "coverage",
  "date",
  "description",
];

const badTags = [
  "noscript",
  "script",
  "style",
  "iframe",
  "ins",
  "header",
  "footer",
  "button",
  "input",
  "amp-auto-ads",
  "pirate",
  "figcaption",
  "address",
  "tfoot",
  "object",
  "video",
  "audio",
  "source",
  "nav",
  "output",
  "select",
  "textarea",
  "form",
  "map",
];

const blacklistPatterns = <String>[];

const notextTags = [
  "img",
];

const preserveAttrs = [
  "href",
  "src",
  "alt",
];

const separator = "\u2561";
