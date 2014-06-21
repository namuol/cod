var extract, parse;

parse = require('../lib/parser').parse;

extract = require('./extract');

module.exports = function(text, _arg) {
  var close, open;
  open = _arg.open, close = _arg.close;
  if (open == null) {
    open = '###';
  }
  if (close == null) {
    close = '###';
  }
  return parse(extract(text, open, close));
};
