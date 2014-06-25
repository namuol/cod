doc = """
`             ,
           _-""-,-"'._         
     .-*'``           ``-.__.-`:
  .'o   ))` ` ` ` ` ` `_`.---._:
   `-'.._,,____...--*"` `"     
         ``
cod: An unassuming documentation generator.

Usage:
  cod [-b <doc-begin> -e <doc-end>] [-o <output-file>] [-u] [<input-file>...]
  cod -h | --help | --version

Options:
  -b <doc-begin>    String that marks the start of a doc-block [default: /**]
  -e <doc-end>      String that marks the end of a doc-block [default: */]
  -o <output-file>  Output file [default: STDOUT]
  -u --ugly         Output non-pretty JSON.
  -v --version      Show version.
  -h --help         Show this screen.
  <input-file>...   File(s) containing docs. If none, cod reads from STDIN.

Examples:

  cod -o api.json *.js
  
  cod -b '###*' -e '###' -o api.json *.coffee
  
  cat *.js | cod -u | gzip > dist/api.json.gz

"""

{docopt} = require 'docopt'

pkg = require '../package'
cod = require '../lib/index'
fs = require 'fs'
path = require 'path'

options = docopt doc, version: pkg.version

inputs = options['<input-file>']

if inputs.length is 0
  input = process.stdin
else
  input = require('combined-stream').create()
  for file in inputs
    input.append fs.createReadStream path.join process.cwd(), file

if options['-o'] in ['STDOUT', '-']
  output = process.stdout
else
  output = fs.createWriteStream path.join process.cwd(), options['-o']


input.pipe cod
  docBegin: options['-b']
  docEnd: options['-e']
  pretty: !options['--ugly']
.pipe output
