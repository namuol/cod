gulp = require 'gulp'
gutil = require 'gulp-util'

jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
nib = require 'nib'
connect = require 'gulp-connect'
open = require 'gulp-open'

paths =
  snippets: 'src/snippets/*'
  main: 'src/index.jade'
  styles: 'src/**.styl'

snippets = {}
gulp.task 'snippets', ->
  gulp.src paths.snippets
    .pipe gutil.buffer (err, files) ->
      throw err  if err

      for file in files
        filename = file.path.replace file.base, ''
        snippets[filename] = file.contents.toString()

gulp.task 'main', ->
  gulp.src paths.main
    .pipe jade
      data:
        snippets: snippets
    .pipe gulp.dest './'

gulp.task 'styles', ->
  gulp.src paths.styles
    .pipe stylus
      use: [nib()]
    .pipe gulp.dest './'

gulp.task 'watch:src', ->
  gulp.watch paths.snippets, ['snippets', 'main']
  gulp.watch paths.main, ['main']
  gulp.watch paths.styles, ['styles']
  gulp.watch './docs.json', ['main']

gulp.task 'watch:dist', ->
  gulp.watch [
    './*.html'
    './*.css'
    './*.js'
    './img/*'
  ], ['reload']

gulp.task 'reload', ->
  gulp.src([
    './*.html'
    './*.css'
    './*.js'
    './*.json'
    './img/*'
  ]).pipe connect.reload()

PORT = gutil.env.PORT || 3000

gulp.task 'connect', ->
  connect.server
    root: __dirname
    port: PORT
    livereload: true

gulp.task 'open', ->
  gulp.src './index.html'
    .pipe open '',
      url: "http://localhost:#{PORT}"

gulp.task 'build', ['snippets', 'main', 'styles']
gulp.task 'default', ['connect', 'build', 'watch:src', 'watch:dist', 'open']
