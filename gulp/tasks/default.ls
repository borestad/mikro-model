module.exports = ($, options, gulp) ->

  gulp.task 'default',
    [if $.env.is-dev then 'start-development' else 'start-production']
