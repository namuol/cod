#!/usr/bin/env node
var cod, doc, docopt, f, file, inputs, options, pkg, result, _i, _len, _ref, _ref1;

doc = "`             ,\n           _-\"\"-,-\"'._         \n     .-*'``           ``-.__.-`:\n  .'o   ))` ` ` ` ` ` `_`.---._:\n   `-'.._,,____...--*\"` `\"     \n         ``\ncod: An unopinionated documentation generator.\n\nUsage:\n  cod [-b <open-pattern> -e <close-pattern>] [-o <output-file>] <input-file>...\n  cod -h | --help | --version\n\nOptions:\n  -b <open-pattern>   Doc-block OPEN comment pattern [default: \"/**\"]\n  -e <close-pattern>  Doc-block CLOSE comment pattern [default: \"*/\"]\n  -o <output-file>    Output file [default: STDOUT]\n  -v --version        Show version.\n  -h --help           Show this screen.";

docopt = require('docopt').docopt;

file = require('file-utils').createEnv(process.cwd());

pkg = require('../package');

cod = require('../lib/index');

options = docopt(doc, {
  version: pkg.version
});

inputs = [];

_ref = options['<input-file>'];
for (_i = 0, _len = _ref.length; _i < _len; _i++) {
  f = _ref[_i];
  inputs.push(file.read(f));
}

result = JSON.stringify(cod(inputs.join(''), {
  open: options['-b'],
  close: options['-c']
}));

if ((_ref1 = options['-o']) === 'STDOUT' || _ref1 === '-') {
  console.log(result);
} else {
  file.write(options['-o'], result);
}
