doc = """
`             ,
           _-""-,-"'._         
     .-*'``           ``-.__.-`:
  .'o   ))` ` ` ` ` ` `_`.---._:
   `-'.._,,____...--*"` `"     
         ``
cod: An unopinionated documentation generator.

Usage:
  cod [-b <open-pattern> -e <close-pattern>] [-o <output-file>] <input-file>...
  cod -h | --help | --version

Options:
  -b <open-pattern>   Doc-block OPEN comment pattern [default: "/**"]
  -e <close-pattern>  Doc-block CLOSE comment pattern [default: "*/"]
  -o <output-file>    Output file [default: STDOUT]
  -v --version        Show version.
  -h --help           Show this screen.
"""

{docopt} = require 'docopt'
file = require('file-utils').createEnv process.cwd()

pkg = require '../package'
cod = require '../lib/index'

options = docopt doc, version: pkg.version

inputs = []
for f in options['<input-file>']
  inputs.push file.read f

result = JSON.stringify cod inputs.join(''),
  open: options['-b']
  close: options['-c']

if options['-o'] in ['STDOUT', '-']
  console.log result
else
  file.write options['-o'], result
