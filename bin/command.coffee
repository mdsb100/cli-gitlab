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

program.command("users")
.description("Get users from gitlab")
.option("--current", "Get current user")
.option("--show <userId>", "Show user by user id")
.action( (options) ->
  hasOptions = false

  if options.current?
    hasOptions = true
    worker.users.current()

  if typeof options.show is "string"
    hasOptions = true
    worker.users.show options.show

  worker.users.all() unless hasOptions
)

program.command("issues")
.description("Get issues from gitlab")
.action(worker.issues.all)

program.command("table-head")
.description("Control output. Get origin, get, set, remove or add head")
.option("--type <type>", "Type of table head [user]")
.option("--origin", "Get origin table head by type")
.option("--set <head1,head2>", "Set and store table head by type. Example: gitlab table-head --set 'id','name','username' --type user")
.option("--get", "Get table head by type")
.option("--add <column>", "Add a head to table")
.option("--remove <column>", "Remove a head to table")
.option("--reset", "Reset table head to origin")
.action( (options) ->
  hasOptions = false

  if options.origin?
    hasOptions = true
    worker.tableHead.getOrigin options.type

  if typeof options.set is "string" and typeof options.type is "string"
    hasOptions = true
    worker.tableHead.set options.type, options.set.trim().split(",")
  else if options.get and typeof options.type is "string"
    hasOptions = true
    worker.tableHead.get options.type

  if typeof options.add is "string" and typeof options.type is "string"
    hasOptions = true
    worker.tableHead.add options.type, options.add
  else if typeof options.remove is "string" and typeof options.type is "string"
    hasOptions = true
    worker.tableHead.remove options.type, options.remove

  if options.reset and typeof options.type is "string"
    hasOptions = true
    worker.tableHead.reset options.type

  worker.tableHead.getType() unless hasOptions
)

program.parse process.argv

program.help()  if process.argv.length is 2
