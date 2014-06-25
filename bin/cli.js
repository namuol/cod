#!/usr/bin/env node
var cod, doc, docopt, file, fs, input, inputs, options, output, path, pkg, _i, _len, _ref;

doc = "`             ,\n           _-\"\"-,-\"'._         \n     .-*'``           ``-.__.-`:\n  .'o   ))` ` ` ` ` ` `_`.---._:\n   `-'.._,,____...--*\"` `\"     \n         ``\ncod: An unassuming documentation generator.\n\nUsage:\n  cod [-b <doc-begin> -e <doc-end>] [-o <output-file>] [-u] [<input-file>...]\n  cod -h | --help | --version\n\nOptions:\n  -b <doc-begin>    String that marks the start of a doc-block [default: /**]\n  -e <doc-end>      String that marks the end of a doc-block [default: */]\n  -o <output-file>  Output file [default: STDOUT]\n  -u --ugly         Output non-pretty JSON.\n  -v --version      Show version.\n  -h --help         Show this screen.\n  <input-file>...   File(s) containing docs. If none, cod reads from STDIN.\n\nExamples:\n\n  cod -o api.json *.js\n  \n  cod -b '###*' -e '###' -o api.json *.coffee\n  \n  cat *.js | cod -u | gzip > dist/api.json.gz\n";

docopt = require('docopt').docopt;

pkg = require('../package');

cod = require('../lib/index');

fs = require('fs');

path = require('path');

options = docopt(doc, {
  version: pkg.version
});

inputs = options['<input-file>'];

if (inputs.length === 0) {
  input = process.stdin;
} else {
  input = require('combined-stream').create();
  for (_i = 0, _len = inputs.length; _i < _len; _i++) {
    file = inputs[_i];
    input.append(fs.createReadStream(path.join(process.cwd(), file)));
  }
}

if ((_ref = options['-o']) === 'STDOUT' || _ref === '-') {
  output = process.stdout;
} else {
  output = fs.createWriteStream(path.join(process.cwd(), options['-o']));
}

input.pipe(cod({
  docBegin: options['-b'],
  docEnd: options['-e'],
  pretty: !options['--ugly']
})).pipe(output);
