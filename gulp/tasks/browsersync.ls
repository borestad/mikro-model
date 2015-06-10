module.exports = ($, options, gulp) ->

  gulp.task 'browsersync', ->
    $.fn.browser-sync.init null, options.client
