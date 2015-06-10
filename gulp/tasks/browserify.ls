module.exports = ($, options, gulp) ->

  gulp.task 'browserify', (callback) ->
    require! 'browserify'
    require! 'watchify'

    source        = require 'vinyl-source-stream'
    bundleQueue   = options.client.bundleConfigs.length

    browserifyThis = (bundleConfig) ->
      {extensions, debug} = options.client

      bundler = browserify {
        cache: {}
        packageCache: {}
        fullPaths: false # Would we ever want this to be true?
        bundleConfig.entries
        extensions
        debug
      }

      for value, key of options.transforms
        bundler.transform key

      bundle = ->
        $.lilly.bundleLogger.start bundleConfig.outputName
        bundler.bundle!
          .on 'error', $.lilly.handleErrors
          .pipe source bundleConfig.outputName
          # Derequire is an expensive task, only use in production mode
          #.pipe $.if $.is-prod, $.derequire!
          .pipe gulp.dest bundleConfig.dest
          .on 'end', reportFinished
          .pipe $.fn.reload { stream: true }

      if global.isWatching
        bundler = watchify bundler
        bundler.on 'update', bundle

      reportFinished = ->
        $.lilly.bundleLogger.end bundleConfig.outputName
        if bundleQueue
          bundleQueue--
          callback! if bundleQueue is 0
      bundle!

    options.client.bundleConfigs.forEach browserifyThis
