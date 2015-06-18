require! 'path'

basedir       = path.resolve(process.cwd!)
dest          = "#{basedir}/build"
root          = "#{basedir}"
src           = "#{root}/src"

require! 'glob'

export server =
  host: '0.0.0.0'
  port: 10000

export src            = src
export node_modules   = "#{root}/node_modules"


################################################
# Clean
################################################
export clean =
  client:
    files:
      * dest

################################################
# Livescript
################################################
export livescript =
  client:
    src:
      * "#{src}/*.ls"
    dest: dest


################################################
# Browsersync
################################################
export browserSync =
  version:            require('browser-sync/package.json').version
  client:
    debugInfo:        off
    open:             off
    notify:           on
    port:             10002


################################################
# Livescript
################################################

export browserify =
  transforms:
    liveify: "#{node_modules}/liveify"

  client:
    # Enable source maps
    debug: on

    bare: true

    # Additional file extentions to make optional
    extensions:
      * \.ls

    bundleConfigs: []


for file in glob.sync "#{src}/*.ls"

  filename  = path.basename file              # '/foo/bar.ls' => 'bar.ls'
  dotext    = path.extname filename           # .ls
  ext       = dotext.replace '.', '', 'g'     # ls
  basename  = path.basename(filename, dotext) # bar

  browserify.client.bundleConfigs.push {
    entries: "#{src}/#{filename}"
    dest: dest
    outputName: "#{basename}.js"
  }
