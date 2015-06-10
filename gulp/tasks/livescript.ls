module.exports = ($, options, gulp) ->

  gulp.task 'livescript:bundle', ->
    gulp.src options.src
      .pipe $.livescript { bare: true }
      #.pipe $.rename { suffix: "-bundle"}
      .on 'error', $.util.log
      .pipe gulp.dest options.dest
