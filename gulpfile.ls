require! <[ watchify browserify gulp ]>
require! 'vinyl-source-stream': source
require! 'vinyl-buffer': buffer
require! 'gulp-util': gutil
require! 'browserify-livescript': bl
require! 'gulp-uglify' : uglify


gulp.task \bundle !->
    bundler = watchify browserify {} <<< watchify.args <<<
        entries: ['./src/model.ls', './test/model_spec.ls']
        debug: true
        transform: [bl]

    bundler.on \update, bundle
    bundler.on \log, gutil.log

    do function bundle
        bundler.bundle!
            .on \error, -> gutil.log "Browserify #it"
            .pipe source \model.js
            .pipe buffer!
            .pipe gulp.dest './.tmp'



gulp.task \build !->
    bundler = browserify(
      entries: ['./src/model.ls']
      debug: false
      transform: [bl]
    )

    do function bundle
        bundler.bundle!
            .on \error, -> gutil.log "Browserify #it"
            .pipe source \model.dist.js
            .pipe buffer!
            .pipe gulp.dest './.tmp'



gulp.task \compress !->
  gulp.src './.tmp/model.js'
    .pipe uglify!
    .pipe gulp.dest('dist')
