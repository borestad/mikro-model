module.exports = ($, options, gulp) ->

  gulp.task 'clean', [
    'clean-dist'
  ]

  gulp.task 'clean-dist', (cb) ->
    require! 'del'
    files = options.client.files
    del files, cb
