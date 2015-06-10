module.exports = ($, options, gulp) ->

  gulp.task 'serve:dist', ->
    files = [
      'dist/**/*.html'
      'dist/**/*.css'
      'dist/img/**/*'
      'dist/**/*.js'
    ]

    $.fn.browser-sync do
      files: files
      htdocs:
        baseDir: './dist/'
