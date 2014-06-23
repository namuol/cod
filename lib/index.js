var extract, parse;

parse = require('../lib/parser').parse;

extract = require('./extract');

module.exports = function(text, _arg) {
  var docBegin, docEnd, _ref;
  _ref = _arg != null ? _arg : {}, docBegin = _ref.docBegin, docEnd = _ref.docEnd;
  if (docBegin == null) {
    docBegin = '/**';
  }
  if (docEnd == null) {
    docEnd = '*/';
  }
  return parse(extract(text, docBegin, docEnd));
};
