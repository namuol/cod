var cod, defaults, extract, parse, processStream, processString;

parse = require('./parser').parse;

extract = require('./extract');

defaults = {
  docBegin: '/**',
  docEnd: '*/',
  pretty: true
};

processString = function(text, _arg) {
  var docBegin, docEnd, _ref;
  _ref = _arg != null ? _arg : defaults, docBegin = _ref.docBegin, docEnd = _ref.docEnd;
  if (docBegin == null) {
    docBegin = defaults.docBegin;
  }
  if (docEnd == null) {
    docEnd = defaults.docEnd;
  }
  return parse(extract(text, docBegin, docEnd));
};

processStream = function(_arg) {
  var BufferStreams, docBegin, docEnd, pretty, _ref;
  _ref = _arg != null ? _arg : defaults, docBegin = _ref.docBegin, docEnd = _ref.docEnd, pretty = _ref.pretty;
  BufferStreams = require('bufferstreams');
  if (docBegin == null) {
    docBegin = defaults.docBegin;
  }
  if (docEnd == null) {
    docEnd = defaults.docEnd;
  }
  if (pretty == null) {
    pretty = true;
  }
  return new BufferStreams(function(err, buf, cb) {
    var e, result, spl, str;
    if (err) {
      throw err;
    }
    str = extract(buf.toString('utf8'), docBegin, docEnd);
    try {
      result = parse(str);
    } catch (_error) {
      e = _error;
      spl = str.split('\n');
      e.message = e.message + '\n----\n    ' + spl.slice(e.line - 3, +(e.line - 2) + 1 || 9e9).join('\n    ') + '\n--->' + spl[e.line - 1] + '\n    ' + spl.slice(e.line, +(e.line + 2) + 1 || 9e9).join('\n    ') + '\n----';
      console.error('\n' + e.message + '\n');
      throw e;
    }
    return cb(null, JSON.stringify(result, null, (pretty ? 2 : 0)) + '\n');
  });
};

cod = function() {
  if (arguments[0] instanceof Buffer) {
    arguments[0] = arguments[0].toString('utf8');
  }
  if (typeof arguments[0] === 'string') {
    return processString.apply(null, arguments);
  }
  return processStream.apply(null, arguments);
};

module.exports = cod;
