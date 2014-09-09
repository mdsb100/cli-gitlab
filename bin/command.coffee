program = require("commander")
packageInfo = require("./../package.json")
worker = require("./worker.js")

program.usage("[options]")
.version(packageInfo.version)
.option("-o, --option", "Get option", worker.getOption)

program.command("url [url]")
.description("Get or Set url of gitlab")
.action(worker.url)

program.command("token [token]")
.description("Get or Set token of gitlab")
.action(worker.token)

program.command("me")
.description("Get current user")
.action(worker.users.current)

projects = program.command("projects")
.description("Get projects from gitlab")
.option("--id <projectId>", "Project id")
.action( (cmd, options) ->
  unless options?
    options = cmd
    cmd = null

  if cmd?
    if options.id?
      map = 
        members: worker.projects.members.list
        show: worker.projects.show
        branches: worker.projects.repository.branches
        commits: worker.projects.repository.commits
        tags: worker.projects.repository.tags
      if map[cmd]?
        map[cmd](options.id)
      else
        console.log "  error: command %s missing", cmd 
    else
      console.log "  error: option `--id <projectId>' argument missing"
  else
    worker.projects.all()
)
projects.command("members", "Get members by id from project")
projects.command("show", "Get project by id from gitlab")
projects.command("branches", "Get retrive branches of a given project")
projects.command("commits", "Get retrive commits of a given project")
projects.command("tags", "Get retrive tags of a given project")
projects.command("tree", "Get retrive tree of a given project")

users = program.command("users")
.description("Get users from gitlab")
.action( (cmd) ->
  argLen = arguments.length
  if typeof arguments[0] is "object"
    cmd = null
  options = arguments[argLen-1]

  if cmd?
    if cmd is "current"
      worker.users.current()
    else if cmd is "show"
      userId = if typeof arguments[1] isnt "object" then arguments[1] else null
      if userId?
          worker.users.show(userId)
      else
        console.log "  error: `show <userId>' argument missing"
    else
      console.log "  error: command %s missing", cmd 
  else
    worker.users.all()
)
users.command("current", "Get current user")
users.command("show <userId>", "Show user by user id")

issues = program.command("issues")
.description("Get issues from gitlab")
.action( (cmd) ->
  argLen = arguments.length
  if typeof arguments[0] is "object"
    cmd = null
  options = arguments[argLen-1]
  if cmd?
  else
    worker.issues.all()
)

tablehead = program.command("table-head")
.option("--type <type>", "Type of table head [user]")
.description("Control output. Get origin, get, set, remove or add head")
.action( (cmd) ->
  argLen = arguments.length
  if typeof arguments[0] is "object"
    cmd = null
  options = arguments[argLen-1]
  if cmd?
    if options.type?
      cmdParam = if typeof arguments[1] isnt "object" then arguments[1] else null
      switch cmd
        when "set"
          if cmdParam?
            worker.tableHead.set options.type, cmdParam.trim().split(",")
          else
            console.log "  error: `set <head1,head2>' argument missing"
        when "get", "reset", "getOrigin"
            worker.tableHead[cmd] options.type
        when "remove", "add"
          if cmdParam?
            worker.tableHead[cmd] options.type, cmdParam
          else
            console.log "  error: `#{options.type} <column>' argument missing"
            
    else
      console.log "  error: `--type <type>' argument missing"
  else
    worker.tableHead.getType()
)
tablehead.command("getOrigin", "Get origin table head by type")
tablehead.command("set <head1,head2>", "Set and store table head by type. Example: gitlab table-head set 'id','name','username' --type user")
tablehead.command("get", "Get table head by type")
tablehead.command("add <column>", "Add a head to table")
tablehead.command("remove <column>", "Remove a head to table")
tablehead.command("reset", "Reset table head to origin")

program.parse process.argv

program.help()  if process.argv.length is 2
