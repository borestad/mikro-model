module.exports = ($, options, gulp) ->

  gulp.task 'watchify', [
    'flags-set-watch',
    'browserify'
  ]