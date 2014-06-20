gulp = require 'gulp'
template = require 'gulp-template'
peg = require 'gulp-peg'
coffee = require 'coffee-script'
file = require 'file-utils'

gulp.task 'build:parser', ->
  initializer_cs = file.read 'src/parser.coffee'
  try
    initializer = coffee.compile initializer_cs, bare: true
  catch err
    @emit 'error', new Error err
    return

  gulp.src 'src/parser.pegjs'
    .pipe template initializer: initializer
    .pipe gulp.dest 'tmp'
    .pipe peg()
    .pipe gulp.dest 'lib'

gulp.task 'default', ['build:parser']