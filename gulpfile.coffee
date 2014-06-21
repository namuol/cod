gulp = require 'gulp'
template = require 'gulp-template'
peg = require 'gulp-peg'
coffee = require 'gulp-coffee'
compile_coffee = require('coffee-script').compile
file = require 'file-utils'

buildPEG = (name) ->
  initializer_cs = file.read "src/#{name}.coffee"
  try
    initializer = compile_coffee initializer_cs, bare: true
  catch err
    @emit 'error', new Error err
    return

  gulp.src "src/#{name}.pegjs"
    .pipe template initializer: initializer
    .pipe gulp.dest 'tmp'
    .pipe peg()
    .pipe gulp.dest 'lib'

gulp.task 'build:parser', -> buildPEG 'parser'
gulp.task 'build:coffee', ->
  gulp.src 'src/*.coffee'
    .pipe coffee bare: true
    .pipe gulp.dest 'lib'

gulp.task 'default', ['build:parser', 'build:coffee']