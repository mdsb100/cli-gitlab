nconf = require("nconf")
fs = require("fs")
path = require("path")
_ = require("underscore")
stringify = require("json-stable-stringify")

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

stringifyFormat = (data) ->
  console.log(stringify(data, {space: 2})) if data?

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

map =
  #Groups
  "groups":
    options: 
      "per_page": {
        param: "[per_page]"
        alias: "e"
        desc: "The limit of list."
        type: true
        index: 0
      }
      page: {
        param: "[page]"
        alias: "p"
        desc: "The offset of list."
        type: true
        index: 0
      }
    desc: "Get retrive groups from gitlab."
    nameSpaces: "groups.all"
    callback: stringifyFormat
  "showGroup":
    param: [
      "<groupId>"
    ]
    desc: "Get retrive group fo a given group."
    nameSpaces: "groups.show"
    callback: stringifyFormat
  "showGroupProjects":
    param: [
      "<groupId>"
    ]
    desc: "Get retrive projects fo a given group."
    nameSpaces: "groups.listProjects"
    callback: stringifyFormat
  "showGroupMembers":
    param: [
      "<groupId>"
    ]
    desc: "Get retrive memebers fo a given group."
    nameSpaces: "groups.listProjects"
    callback: stringifyFormat

  #Issues
  "issues":
    desc: "Get retrive issues from gitlab."
    nameSpaces: "issues.all"
    callback: stringifyFormat
  "showIssue":
    param: [
      "<projectId>"
      "<issueId>"
    ]
    desc: "Get retrive issue fo a given project and a given issue."
    nameSpaces: "issues.show"
    callback: stringifyFormat
  #todo create
  #todo edit

  #ProjectDeployKeys
  "keys":
    param: [
      "<projectId>"
    ]
    desc: "Get retrive keys fo a given project."
    nameSpaces: "projects.deploy_keys.listKeys"
    callback: stringifyFormat
  "getKey":
    param: [
      "<projectId>"
      "<keyId>"
    ]
    desc: "Get retrive keys fo a given project and a give key."
    nameSpaces: "projects.deploy_keys.getKey"
    callback: stringifyFormat
  #to addKey

  #ProjectHooks
  "hooks":
    param: [
      "<projectId>"
    ]
    desc: "Get retrive hooks fo a given project."
    nameSpaces: "projects.hooks.list"
    callback: stringifyFormat
  "showHook":
    param: [
      "<projectId>"
      "<hookId>"
    ]
    desc: "Get retrive hook fo a given project and a give hook."
    nameSpaces: "projects.hooks.show"
    callback: stringifyFormat
  "addHook":
    param: [
      "<projectId>"
      "<url>"
    ]
    desc: "Add hook by a given porject id and url."
    nameSpaces: "projects.hooks.add"
    callback: stringifyFormat
  "updateHook":
    param: [
      "<projectId>"
      "<hookId>"
      "<url>"
    ]
    desc: "Update hook by a given porject id, a given hook id and url."
    nameSpaces: "projects.hooks.update"
    callback: stringifyFormat
  "removeHook":
    param: [
      "<projectId>"
      "<hookId>"
    ]
    desc: "Remove hook by a given porject id abd a given hook id."
    nameSpaces: "projects.hooks.remove"
    callback: stringifyFormat

  #ProjectIssue
  "projectIssues":
    param: [
      "<projectId>"
    ]
    options: 
      "per_page": {
        param: "[per_page]"
        alias: "e"
        desc: "The limit of list."
        type: true
        index: 1
      }
      page: {
        param: "[page]"
        alias: "p"
        desc: "The offset of list."
        type: true
        index: 1
      }
    desc: "Get retrive issue fo a given project."
    nameSpaces: "projects.issues.list"
    callback: stringifyFormat

  #ProjectMembers
  "members":
    param: [
      "<projectId>"
    ]
    desc: "Get retrive members fo a given project."
    nameSpaces: "projects.members.list"
    callback: stringifyFormat
  "showMember":
    param: [
      "<projectId>"
      "<userId>"
    ]
    desc: "Get retrive member fo a given project and a give user."
    nameSpaces: "projects.members.show"
    callback: stringifyFormat
  "addMember":
    param: [
      "<projectId>"
      "<userId>"
      "[accessLevel]"
    ]
    desc: "Add member by a given porject id and user id. Default of access level is 30."
    nameSpaces: "projects.members.add"
    callback: stringifyFormat
  #todo updatemember
  "removeMember":
    param: [
      "<projectId>"
      "<userId>"
    ]
    desc: "Remove member by a given porject id and user id."
    nameSpaces: "projects.members.remove"
    callback: stringifyFormat

  #ProjectMergeRequests
  "mergeRequests":
    param: [
      "<projectId>"
    ]
    options: 
      "per_page": {
        param: "[per_page]"
        alias: "e"
        desc: "The limit of list."
        type: true
        index: 1
      }
      page: {
        param: "[page]"
        alias: "p"
        desc: "The offset of list."
        type: true
        index: 1
      }
    desc: "Get retrive merge requests fo a given project."
    nameSpaces: "projects.merge_requests.list"
    callback: stringifyFormat
  "showMergeRequest":
    param: [
      "<projectId>"
      "<mergeRequestId>"
    ]
    desc: "Get retrive merge request fo a given project and a merge request."
    nameSpaces: "projects.merge_requests.show"
    callback: stringifyFormat
  "addMergeRequest":
    param: [
      "<projectId>"
      "<sourceBranch>"
      "<targetBranch>"
      "<assigneeId>"
      "<title>"
    ]
    desc: "Add merge request by list of parameters."
    nameSpaces: "projects.merge_requests.add"
    callback: stringifyFormat
  "updateMergeRequest":
    param: [
      "<projectId>"
      "<mergeRequestId>"
      "[accessLevel]"
    ]
    desc: "Update merge request fo a given project and a merge request. Default of access level is 30."
    nameSpaces: "projects.merge_requests.update"
    callback: stringifyFormat
  "commentMergeRequest":
    param: [
      "<projectId>"
      "<mergeRequestId>"
      "<note>"
    ]
    desc: "Comment  merge request by a given porject id, note and a merge request."
    nameSpaces: "projects.merge_requests.comment"
    callback: stringifyFormat

  #ProjectMilestones
  "milestones":
    param: [
      "<projectId>"
    ]
    desc: "Get retrive milestones fo a given project."
    nameSpaces: "projects.milestones.list"
    callback: stringifyFormat
  "showMilestones":
    param: [
      "<projectId>"
      "<milestoneId>"
    ]
    desc: "Get retrive merge request fo a given project and a milestone."
    nameSpaces: "projects.milestones.show"
    callback: stringifyFormat
  "addMilestones":
    param: [
      "<projectId>"
      "<title>"
      "<description>"
      "<due_date>"
    ]
    desc: "Add milestones by list of parameters."
    nameSpaces: "projects.milestones.add"
    callback: stringifyFormat
  "updateMilestones":
    param: [
      "<projectId>"
      "<milestoneId>"
      "<title>"
      "<description>"
      "<due_date>"
      "state_event"
    ]
    desc: "Update milestones by list of parameters."
    nameSpaces: "projects.milestones.update"
    callback: stringifyFormat

  #ProjectRepository
  "listBranches":
    param: [
      "<projectId>"
    ]
    desc: "Get retrive branches of a given project."
    nameSpaces: "projects.repository.listBranches"
    callback: stringifyFormat    

  "showBranch":
    param: [
      "<projectId>",
      "<branchId>"
    ]
    desc: "Get retrive branche of a given project and a branch id."
    nameSpaces: "projects.repository.showBranch"
    callback: stringifyFormat

  "listTags":
    param: [
      "<projectId>"
    ]
    desc: "Get retrive list tags of a given project."
    nameSpaces: "projects.repository.listTags"
    callback: stringifyFormat

  "listCommits":
    param: [
      "<projectId>"
    ]
    desc: "Get retrive list commits of a given project."
    nameSpaces: "projects.repository.listCommits"
    callback: stringifyFormat

  "showCommit":
    param: [
      "<projectId>",
      "<commitId>"
    ]
    desc: "Get retrive commit of a given project and a commit id."
    nameSpaces: "projects.repository.showCommit"
    callback: stringifyFormat

  "diffCommit":
    param: [
      "<projectId>",
      "<sha>"
    ]
    desc: "Diff commit of a given project and sha."
    nameSpaces: "projects.repository.diffCommit"
    callback: stringifyFormat

  #todo listTree
  #todo showFile
  #todo createFile
  #todo updateFile

  #Project
  "projects":
    options: 
      "per_page": {
        param: "[per_page]"
        alias: "e"
        desc: "The limit of list."
        type: true
        index: 0
      }
      page: {
        param: "[page]"
        alias: "p"
        desc: "The offset of list."
        type: true
        index: 0
      }
    desc: "Get retrive projects."
    nameSpaces: "projects.all"
    callback: stringifyFormat

  #ProjectUsers
  "users":
    desc: "Get retrive users from gitlab."
    nameSpaces: "users.all"
    callback: stringifyFormat
  "me":
    desc: "About me."
    nameSpaces: "users.current"
    callback: stringifyFormat
  "showUser":
    param: [
      "<userId>"
    ]
    desc: "Show users by user id."
    nameSpaces: "users.show"
    callback: stringifyFormat
  #todo create
  "session":
    param: [
      "<email>"
      "<password>"
    ]
    desc: "Get session by email and password."
    nameSpaces: "users.session"
    callback: stringifyFormat


exports.createOptions =  (program, param) ->    
  for key, value of param
    program.option( (if value.alias? then "-#{value.alias}," else "" )+" --#{key} #{value.param}", value.desc )

exports.createParam = (params) ->
  return "" unless params?
  ret = []
  for item in params
    ret.push item
  ret.join(" ")

exports.createCommands = (program) ->
  _.forEach map, (cmd, key) ->
    command = program.command("#{key} #{exports.createParam(cmd.param)}")
    command.description(cmd.desc)

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
        if value.type
          unless arg[value.index]?
            arg[value.index] = {}
          arg[value.index][key] = options[key]
        else
          arg[value.index] = options[key]

      target = requireOrGetGitlab()

      nameSpaces = cmd.nameSpaces.split(".")

      fn = nameSpaces.pop()

      if cmd.callback
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