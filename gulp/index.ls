# For development => gulp
# For production  => gulp -p
module.exports = (gulp) ->
  startTime = void
  debug = require('debug')('lilly:gulp')

  unless gulp
    throw new Error("We need an instance of gulp as an argument")
    process.exit 1

  env         = (require 'minimist') process.argv.slice 2
  $           = (require 'gulp-load-plugins') { lazy: true }

  $.env = {}
  $.env.is-prod    = false #!!env.p
  $.env.is-dev     = true #not $.env.is-prod

  # Lilly functionality
  $.lilly =
    bundle-logger:
      start: (filepath) ->
        startTime := process.hrtime!
        $.util.log 'Bundling', ($.util.colors.green filepath) + '...'

      end: (filepath) ->
        taskTime = process.hrtime startTime
        prettyTime = prettyHrtime taskTime
        $.util.log 'Bundled', ($.util.colors.green filepath), 'in', $.util.colors.magenta prettyTime

    handle-errors:  ->
      args = Array::slice.call arguments
      ($.notify.onError {
        title: 'Compile Error'
        message: '<%= error %>'
      }).apply this, args
      @emit 'end'

    config:         require './config'
    #log-events:     require('./util/logEvents')(gulp)

  # Common functionality
  $.fn =
    browser-sync:   require 'browser-sync'
    reload:         require('browser-sync').reload
    pretty-hrtime:  require 'pretty-hrtime'
    chalk:          require 'chalk'
    path:           require 'path'
    fs:             require 'fs'
    _:              require 'lodash-contrib'


  # Deconstruct
  { path, fs, prettyHrtime, chalk } = $.fn
  { config }   = $.lilly


  # Highly optimized require-dir instead of glob
  # TODO: Try to use readdir as async option instead
  # TODO: Break out as a utility
  for dir in ["#{__dirname}/tasks"]
    dirn = path.normalize dir

    files = fs.readdirSync dirn
      .filter (name) -> /(\.ls$)/

    for name in files
      startTime = process.hrtime!
      path = "./tasks/#{name}"
      task = name.replace /.(js|coffee|ls)$/, ''
      conf = config[task] or config

      # Wrapper for tasks
      # This enables hooks for reading recipes and tasks
      # task = ->
      #   gulp.task.apply gulp, arguments

      tasks = require(path)($, conf, gulp)
      taskTime = process.hrtime startTime
      prettyTime = prettyHrtime taskTime
      msg =  chalk.green("lilly:#{task}") + chalk.gray " loaded " + "in #{prettyTime}"

      debug msg

  export tasks
  export $
