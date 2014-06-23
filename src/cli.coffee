doc = """
`             ,
           _-""-,-"'._         
     .-*'``           ``-.__.-`:
  .'o   ))` ` ` ` ` ` `_`.---._:
   `-'.._,,____...--*"` `"     
         ``
cod: An unopinionated documentation generator.

Usage:
  cod [-b <doc-begin> -e <doc-end>] [-o <output-file>] <input-file>...
  cod -h | --help | --version

Options:
  -b <doc-begin>    String that marks the start of a doc-block [default: "/**"]
  -e <doc-end>      String that marks the end of a doc-block [default: "*/"]
  -o <output-file>  Output file [default: STDOUT]
  -v --version      Show version.
  -h --help         Show this screen.
"""

{docopt} = require 'docopt'
file = require('file-utils').createEnv process.cwd()

pkg = require '../package'
cod = require '../lib/index'

options = docopt doc, version: pkg.version

inputs = []
for f in options['<input-file>']
  inputs.push file.read f

result = JSON.stringify cod(inputs.join(''),
  docBegin: options['-b']
  docEnd: options['-e']
)

if options['-o'] in ['STDOUT', '-']
  console.log result
else
  file.write options['-o'], result
