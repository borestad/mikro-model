module.exports = ($, options, gulp) ->

  {src} = o = options

  gulp.task 'start-development', [
    'clean'
    'watchify'
    'browsersync'
    ], ->

    require! 'run-sequence'
    # Compiled Javascript is using Watchify