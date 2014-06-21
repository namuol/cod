module.exports = function(text, openPat, closePat) {
  var depth, idx, inside, line, result, search, subdepth, substr, _i, _len, _ref;
  result = [];
  depth = 0;
  subdepth = 0;
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
        search = substr.search(/[^ ]/);
        if (search >= 0) {
          subdepth = search;
        } else {
          substr = (new Array(subdepth + 1)).join(' ');
        }
        result.push(substr);
      }
    }
  }
  return result.join('\n');
};
