nconf = require("nconf")
fs = require("fs")
path = require("path")
cliff = require("cliff");

gitlabDircPath = path.join(process.env[(if process.platform is "win32" then "USERPROFILE" else "HOME")], ".gitlab")
fs.mkdirSync gitlabDircPath  unless fs.existsSync(gitlabDircPath)
configFilePath = path.join(gitlabDircPath, "config.json")
nconf.file file: configFilePath
nconf.defaults
  "table_head_user": JSON.stringify(["id", "name", "username", "state", "email", "created_at"])
  "table_head_project": JSON.stringify(["id", "name", "public", "archived", "visibility_level", "issues_enabled", "wiki_enabled", "created_at", "last_activity_at"])
  "table_head_issue": JSON.stringify(["id", "iid", "project_id", "title", "description", "state", "created_at", "updated_at", "labels", "assignee", "author"])
  "table_head_commite": JSON.stringify(["id", "title", "author_name", "created_at"])
gitlab = null

tableHeadType = ["user", "project", "issue", "commite"]

checkOptions = ->
  unless nconf.get("url")
    console.log "You should set url by 'gitlab --url http://example.com' "
    return false
  unless nconf.get("token")
    console.log "You should set token by 'gitlab --token abcdefghij123456' "
    return false
  true

makeTableByData = (datas, table_head) ->
  if datas.constructor is Array and not datas.length
    return console.log("No Datas Or No Permission")
  else if datas.constructor isnt Array
    datas = [datas]

  unless table_head?
    table_head = getTableHeadByData(datas[0])

  rows = [ table_head ]
  for data in datas
    row = []
    rows.push row
    for key in table_head
      value = data[key]
      value = value.name or value.id if value? and typeof value is "object"
      row.push value or ""

  console.log cliff.stringifyRows(rows)

makeTableByUser = (data) ->
  makeTableByData data, JSON.parse(nconf.get "table_head_user")

makeTableByProject = (data) ->
  makeTableByData data, JSON.parse(nconf.get "table_head_project")

makeTableByIssue = (data) ->
  makeTableByData data, JSON.parse(nconf.get "table_head_issue")

getTableHeadByData = (data) ->
  table_head = []
  # Make id is first
  if data? and data.constructor is Array
    for key in data
      if key isnt "id" then table_head.push(key) else table_head.unshift(key)
  else
    for key of data
      if key isnt "id" then table_head.push(key) else table_head.unshift(key)
  return table_head

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

getGitlabDataTypeMap = (type="user") ->
  gitlab = requireOrGetGitlab()
  map =
    "user": gitlab.users.current
    "project": (callback) ->
      gitlab.projects.all (projects) ->
        callback(projects[0])
    "issue": (callback) ->
      gitlab.issues.all (issues) ->
        callback(issues[0])

  map[type] or map["user"]

exports.users =
  all: ->
    requireOrGetGitlab().users.all (users) ->
      users.sort (user1, user2) ->
        parseInt(user1.id) - parseInt(user2.id)

      makeTableByUser users

  current: ->
    requireOrGetGitlab().users.current makeTableByUser

  show: (userId) ->
    requireOrGetGitlab().users.show userId, makeTableByUser

exports.projects =
  all: ->
    requireOrGetGitlab().projects.all (projects) ->
      projects.sort (project1, project2) ->
        parseInt(project1.id) - parseInt(project2.id)

      makeTableByProject projects

  show: (userId) ->
    requireOrGetGitlab().projects.show userId, makeTableByProject

  members:
    list: (projectId) ->
      requireOrGetGitlab().projects.members.list projectId, makeTableByUser
  repository:
    branches: (projectId) ->
      requireOrGetGitlab().projects.repository.listBranches projectId, makeTableByData
    commits: (projectId) ->
      requireOrGetGitlab().projects.repository.listCommits projectId, (commits) ->
        makeTableByData commits, JSON.parse(nconf.get "table_head_user")
    tags: (projectId) ->
      requireOrGetGitlab().projects.repository.listTags projectId, makeTableByData
    tree: (projectId) ->
      requireOrGetGitlab().projects.repository.listTree projectId, makeTableByData

exports.issues =
  all: ->
    requireOrGetGitlab().issues.all (issues) ->
      issues.sort (issue1, issue2) ->
        parseInt(issue1.id) - parseInt(issue2.id)

      makeTableByIssue issues

exports.tableHead =
  checkTableHead: (table_head) ->
    return  unless table_head? or table_head.constructor is Array or table_head.length
    # Make id exists and id is first one in array
    for key, index in table_head
      table_head[index] = (key+"").trim()

    for key, index in table_head
      if key is "id"
        temp = table_head[0]
        table_head[0] = table_head[index]
        table_head[index] = temp
        return table_head

    table_head[0] = "id"
    return table_head

  set: (type, table_head) ->
    table_head = @checkTableHead(table_head)
    if table_head?
      nconf.set "table_head_#{type}", JSON.stringify(table_head)
      nconf.save()
      console.log "Save #{type} table head"
    else
      console.log "Can not save #{type} table head, please check it"

  get: (type) ->
    table_head = nconf.get("table_head_#{type}")
    if table_head?
      console.log(JSON.parse(table_head))
    else
      console.log("Can not find #{type} table head")

  add: (type, column) ->
    table_head = nconf.get("table_head_#{type}")
    if table_head?
      table_head = JSON.parse(table_head)
      if table_head.indexOf(column) < 0
        table_head.push(column)
        @set(type, table_head)

  remove: (type, column) ->
    table_head = nconf.get("table_head_#{type}")
    if table_head?
      table_head = JSON.parse(table_head)
      index = table_head.indexOf(column)
      if index > -1
        table_head.splice(index, 1)
        @set(type, table_head)

  reset: (type) ->
    getGitlabDataTypeMap(type)?( (data) ->
      exports.tableHead.set(type, getTableHeadByData(data)) if data?
    )

  getType: ->
    console.log("type of table head:", tableHeadType)

  getOrigin: (type) ->
    fn = getGitlabDataTypeMap(type)

    if fn?
      fn (data) ->
        return console.log("Can not get this type data") unless data?
        console.log(getTableHeadByData(data))
    else
      console.log "Error type:%j", type

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
