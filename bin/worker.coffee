nconf = require("nconf")
fs = require("fs")
path = require("path")
_ = require("underscore")

gitlabDircPath = path.join(process.env[(if process.platform is "win32" then "USERPROFILE" else "HOME")], ".gitlab")
fs.mkdirSync gitlabDircPath  unless fs.existsSync(gitlabDircPath)
configFilePath = path.join(gitlabDircPath, "config.json")
nconf.file file: configFilePath
gitlab = null

checkOptions = ->
  unless nconf.get("url")
    console.log "You should set url by 'gitlab url http://example.com' "
    return false
  unless nconf.get("token")
    console.log "You should set token by 'gitlab token abcdefghij123456' "
    return false
  true

requireOrGetGitlab = ->
  if gitlab?
    gitlab
  else
    if checkOptions()
      gitlab = require("gitlab")(
        url: nconf.get("url")
        token: nconf.get("token")
      )
      gitlab

exports.url = (url) ->
  if url?
    nconf.set "url", url
    nconf.save()
    console.log "Save url"
  else
    console.log nconf.get "url"

exports.token = (token) ->
  if token?
    nconf.set "token", token
    nconf.save()
    console.log "Save token"
  else
    console.log nconf.get "token"

exports.getOption = ->
  opitons = nconf.get()
  for key,value of opitons
    console.log "#{key}:#{value}"

exports.createOptions =  (program, param) ->
  for key, value of param
    program.option( (if value.alias? then "-#{value.alias}," else "" )+" --#{key} #{value.param}", value.desc )

exports.createParam = (params) ->
  return "" unless params?
  ret = []
  for item in params
    ret.push item
  ret.join(" ")

exports.createCommands = (map, program) ->
  _.forEach map, (cmd, key) ->
    command = program.command("#{key} #{exports.createParam(cmd.param)}")
    command.description(cmd.desc)

    if cmd.filter is true
      cmd.options.filter =
        param: "[filter]"
        type: true
        desc: "(optional) - Filter result. For example: --filter 'item.assignee.id == 9' "

    exports.createOptions(command, cmd.options) if cmd.options?

    command.action( ->
      options = arguments[arguments.length - 1] or {}
      arg = []

      if cmd.param? and typeof arguments[0] isnt "object"
        i = 0
        while typeof arguments[i] isnt "object"
          arg.push arguments[i]
          i++

      for key, value of cmd.options
        unless value.index?
          continue
        if value.type
          unless arg[value.index]?
            arg[value.index] = {}
          arg[value.index][key] = options[key] if options[key]?
        else
          arg[value.index] = options[key] if options[key]?

      target = requireOrGetGitlab()

      nameSpaces = cmd.nameSpaces.split(".")

      fn = nameSpaces.pop()

      if cmd.callback?
        if cmd.filter is true and options? and options.filter?
          cmd.callback = _.wrap(cmd.callback, (fn, data) ->
            evalFnString = "(function(item){ return #{options.filter}; });"
            evalFn = eval(evalFnString)
            data = _.filter(data, evalFn)
            fn(data)
          )
        arg.push(cmd.callback)

      for name in nameSpaces
        target = target[name]
      target[fn].apply(target, arg)
    )

exports.url = (url) ->
  if url?
    nconf.set "url", url
    nconf.save()
    console.log "Save url"
  else
    console.log nconf.get "url"

exports.token = (token) ->
  if token?
    nconf.set "token", token
    nconf.save()
    console.log "Save token"
  else
    console.log nconf.get "token"

exports.getOption = ->
  opitons = nconf.get()
  for key,value of opitons
    console.log "#{key}:#{value}"