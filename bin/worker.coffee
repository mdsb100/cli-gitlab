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
    gitlab = requireOrGetGitlab()
    gitlab.users.current (data) ->
      nconf.set "me", JSON.stringify(data)
      nconf.save()
  else
    console.log nconf.get "token"

getMe = ->
  me = nconf.get("me")
  if me?
    JSON.parse(me)
  else
    console.log "Please save token again!"
    null

getObjectByNameSpaces = (currentObject, nameSpaces) ->
  object = currentObject
  nameSpaces = nameSpaces.split(".")
  for name in nameSpaces
    object = object[name]
  object

exports.getOption = ->
  opitons = nconf.get()
  for key,value of opitons
    console.log "#{key}:#{value}"

exports.createOptions =  (program, param) ->
  for key, value of param
    program.option( (if value.alias? then "-#{value.alias}," else "" )+" --#{key} #{if value.param? then value.param else ''}", value.desc )

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
    if cmd.help?
      command.on "--help", cmd.help

    cmd.options = {} unless cmd.options?

    if cmd.assigned_to_me?
      cmd.options.assigned_to_me =
        type: true
        desc: "(optional) - Filter result if assigned to me."

    if cmd.created_by_me?
      cmd.options.created_by_me =
        type: true
        desc: "(optional) - Filter result if created by me."

    if cmd.size?
      cmd.options.size =
        type: true
        desc: "(optional) - Output size of result."

    if cmd.filter is true
      cmd.options.filter =
        param: "<filter>"
        type: true
        desc: "(required) - Filter result. For example: --filter 'item.assignee.id == 9' "

    exports.createOptions(command, cmd.options)

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
        callback = cmd.callback

        arg.push (data) ->
          if cmd.filter is true and options? and options.filter?
            evalFnString = "(function(item){ return #{options.filter}; });"
            evalFn = eval(evalFnString)
            data = _.filter(data, evalFn)
          if cmd.assigned_to_me? and options.assigned_to_me?
            data = _.filter data, (item) ->
              return getObjectByNameSpaces(item, cmd.assigned_to_me) == getMe().id

          if cmd.created_by_me? and options.created_by_me?
            data = _.filter data, (item) ->
              return getObjectByNameSpaces(item, cmd.created_by_me) == getMe().id
          callback(data)

          if cmd.size? and options.size?
            console.log data.length

      for name in nameSpaces
        target = target[name]
      target[fn].apply(target, arg)
    )

exports.getOption = ->
  opitons = nconf.get()
  for key,value of opitons
    console.log "#{key}:#{value}"