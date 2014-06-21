module.exports.parse = function(text, openPat, closePat) {
  var depth, idx, inside, line, result, _i, _len, _ref;
  if (openPat == null) {
    openPat = '###';
  }
  if (closePat == null) {
    closePat = '###';
  }
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
        continue;
      }
    } else {
      idx = line.indexOf(closePat);
      if (idx >= 0) {
        inside = false;
      } else {
        result.push(line.substr(depth));
      }
    }
  }
  return result.join('\n');
};
