module.exports = function(text, openPat, closePat) {
  var depth, idx, inside, line, result, substr, _i, _len, _ref;
  result = [];
  depth = 0;
  inside = false;
  _ref = text.split('\n');
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    line = _ref[_i];
    if (!inside) {
      depth = line.indexOf(openPat);
      if (depth >= 0) {
        inside = true;
      }
    } else {
      idx = line.indexOf(closePat);
      if (idx >= 0) {
        inside = false;
      } else {
        substr = line.substr(depth);
        if (substr.trim().length > 0) {
          result.push(substr);
        }
      }
    }
  }
  return result.join('\n');
};
