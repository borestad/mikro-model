module.exports = ($, options, gulp) ->

  gulp.task 'flags-set-prod', ->
    $.env.is-prod = true
    $.env.is-dev = false

  gulp.task 'flags-set-watch', ->
    global.isWatching = true
