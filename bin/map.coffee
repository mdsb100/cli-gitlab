stringify = require("json-stable-stringify")

stringifyFormat = (data) ->
  console.log(stringify(data, {space: 2})) if data?

accessLevelsCustomHelp = ->
  console.log "  access_levels"
  console.log "    GUEST:      10"
  console.log "    REPORTER:   20"
  console.log "    DEVELOPER:  30"
  console.log "    MASTER:     40"
  console.log "    OWNER:      50"

module.exports =
  #Groups
  "groups":
    options:
      per_page: {
        param: "[per_page]"
        alias: "e"
        desc: "(optional) - The limit of list."
        type: true
        index: 0
      }
      page: {
        param: "[page]"
        alias: "p"
        desc: "(optional) - The offset of list."
        type: true
        index: 0
      }
    desc: "Get retrive groups from gitlab."
    nameSpaces: "groups.all"
    callback: stringifyFormat
  "showGroup":
    param: [
      "<group_id>"
    ]
    desc: "Get retrive group of a given group."
    nameSpaces: "groups.show"
    callback: stringifyFormat
  "showGroupProjects":
    filter: true
    size: true
    param: [
      "<group_id>"
    ]
    desc: "Get retrive projects of a given group."
    nameSpaces: "groups.listProjects"
    callback: stringifyFormat
  "showGroupMembers":
    filter: true
    size: true
    param: [
      "<group_id>"
    ]
    help: accessLevelsCustomHelp
    desc: "Get retrive memebers of a given group."
    nameSpaces: "groups.listMembers"
    callback: stringifyFormat
  "addGroupMember":
    param: [
      "<group_id>"
      "<user_id>"
      "<access_level>"
    ]
    desc: "Adds a user to the list of group members."
    help: accessLevelsCustomHelp
    nameSpaces: "groups.addMember"
    callback: stringifyFormat

  #Issues
  "issues":
    filter: true
    assigned_to_me: "assignee.id"
    size: true
    options:
      state:
        param: "[state]"
        alias: "s"
        type: true
        index: 0
        desc: "(optional) - Return all issues or just those that are opened or closed"
      labels:
        param: "[labels]"
        alias: "l"
        type: true
        index: 0
        desc: "(optional) - Comma-separated list of label names"
      order_by:
        param: "[order_by]"
        alias: "o"
        type: true
        index: 0
        desc: "(optional) - Return requests ordered by created_at or updated_at fields. Default is created_at"
      sort:
        param: "[sort]"
        alias: "d"
        type: true
        index: 0
        desc: "(optional) - Return requests sorted in asc or desc order. Default is desc"
      per_page: {
        param: "[per_page]"
        alias: "e"
        desc: "(optional) - The limit of list."
        type: true
        index: 0
      }
      page: {
        param: "[page]"
        alias: "p"
        desc: "(optional) - The offset of list."
        type: true
        index: 0
      }
    desc: "Get all issues created by authenticated user. This function takes pagination parameters page and per_page to restrict the list of issues."
    nameSpaces: "issues.all"
    callback: stringifyFormat
  "showIssue":
    param: [
      "<project_id>"
      "<issue_id>"
    ]
    desc: "Get retrive issue of a given project and a given issue."
    nameSpaces: "issues.show"
    callback: stringifyFormat
  "createIssue":
    param: [
      "<project_id>"
    ]
    options:
      "title": {
        param: "<title>"
        alias: "t"
        desc: "(required) - The title of an issue."
        type: true
        index: 1
      }
      "description": {
        param: "[desc]"
        alias: "d"
        desc: "(optional) - The description of an issue."
        type: true
        index: 1
      }
      "assignee_id": {
        param: "[assignee_id]"
        alias: "a"
        desc: "(optional) - The ID of a user to assign issue."
        type: true
        index: 1
      }
      "milestone_id": {
        param: "[milestone_id]"
        alias: "m"
        desc: "(optional) - The ID of a milestone to assign issue."
        type: true
        index: 1
      }
      "labels": {
        param: "[labels]"
        alias: "l"
        desc: "(optional) - Comma-separated label names for an issue."
        type: true
        index: 1
      }
    desc: "Creates a new project issue.If the operation is successful, 200 and the newly created issue is returned. If an error occurs, an error number and a message explaining the reason is returned."
    nameSpaces: "issues.create"
    callback: stringifyFormat
  "editIssue":
    param: [
      "<project_id>"
      "<issue_id>"
    ]
    options:
      "title": {
        param: "[title]"
        alias: "t"
        desc: "(optional) - The title of an issue."
        type: true
        index: 2
      }
      "description": {
        param: "[desc]"
        alias: "d"
        desc: "(optional) - The description of an issue."
        type: true
        index: 2
      }
      "assignee_id": {
        param: "[assignee_id]"
        alias: "a"
        desc: "(optional) - The ID of a user to assign issue."
        type: true
        index: 2
      }
      "milestone_id": {
        param: "[milestone_id]"
        alias: "m"
        desc: "(optional) - The ID of a milestone to assign issue."
        type: true
        index: 2
      }
      "labels": {
        param: "[labels]"
        alias: "l"
        desc: "(optional) - Comma-separated label names for an issue."
        type: true
        index: 2
      }
      "state_event": {
        param: "[state_event]"
        alias: "s"
        desc: "(optional) - The state event of an issue ('close' to close issue and 'reopen' to reopen it)."
        type: true
        index: 2
      }
    desc: "Updates an existing project issue. This function is also used to mark an issue as closed.If the operation is successful, 200 and the updated issue is returned. If an error occurs, an error number and a message explaining the reason is returned."
    nameSpaces: "issues.edit"
    callback: stringifyFormat

  #ProjectDeployKeys
  "keys":
    filter: true
    size: true
    param: [
      "<project_id>"
    ]
    desc: "Get a list of a project's deploy keys by project id."
    nameSpaces: "projects.deploy_keys.listKeys"
    callback: stringifyFormat
  "getKey":
    param: [
      "<project_id>"
      "<key_id>"
    ]
    desc: "Get a single key by project id and key id."
    nameSpaces: "projects.deploy_keys.getKey"
    callback: stringifyFormat
  "addKey":
    param: [
      "<project_id>"
    ]
    options:
      title:
        param: "<title>"
        alias: "t"
        type: true
        index: 1
        desc: "(required) - New deploy key's title"
      key:
        param: "<key>"
        alias: "k"
        type: true
        index: 1
        desc: "(required) - New deploy key"
    desc: "Creates a new deploy key for a project. If deploy key already exists in another project - it will be joined to project but only if original one was is accessible by same user."
    nameSpaces: "projects.deploy_keys.addKey"
    callback: stringifyFormat

  #ProjectHooks
  "hooks":
    param: [
      "<project_id>"
    ]
    desc: "Get retrive hooks of a given project."
    nameSpaces: "projects.hooks.list"
    callback: stringifyFormat
  "showHook":
    param: [
      "<project_id>"
      "<hook_id>"
    ]
    desc: "Get retrive hook of a given project and a give hook."
    nameSpaces: "projects.hooks.show"
    callback: stringifyFormat
  "addHook":
    param: [
      "<project_id>"
      "<url>"
    ]
    desc: "Add hook by a given porject id and url."
    nameSpaces: "projects.hooks.add"
    callback: stringifyFormat
  "updateHook":
    param: [
      "<project_id>"
      "<hook_id>"
      "<url>"
    ]
    desc: "Update hook by a given porject id, a given hook id and url."
    nameSpaces: "projects.hooks.update"
    callback: stringifyFormat
  "removeHook":
    param: [
      "<project_id>"
      "<hook_id>"
    ]
    desc: "Remove hook by a given porject id abd a given hook id."
    nameSpaces: "projects.hooks.remove"
    callback: stringifyFormat

  #ProjectIssue
  "projectIssues":
    filter: true
    size: true
    assigned_to_me: "assignee.id"
    created_by_me: "author.id"
    param: [
      "<project_id>"
    ]
    options:
      state:
        param: "[state]"
        alias: "s"
        type: true
        index: 1
        desc: "(optional) - Return all issues or just those that are opened or closed"
      labels:
        param: "[labels]"
        alias: "l"
        type: true
        index: 1
        desc: "(optional) - Comma-separated list of label names"
      milestone:
        param: "[milestone]"
        alias: "m"
        type: true
        index: 1
        desc: "milestone (optional) - Milestone title"
      order_by:
        param: "[order_by]"
        alias: "o"
        type: true
        index: 1
        desc: "(optional) - Return requests ordered by created_at or updated_at fields. Default is created_at"
      sort:
        param: "[sort]"
        alias: "d"
        type: true
        index: 1
        desc: "(optional) - Return requests sorted in asc or desc order. Default is desc"
      per_page: {
        param: "[per_page]"
        alias: "e"
        desc: "(optional) - The limit of list."
        type: true
        index: 1
      }
      page: {
        param: "[page]"
        alias: "p"
        desc: "(optional) - The offset of list."
        type: true
        index: 1
      }
    desc: "Get a list of project issues. This function accepts pagination parameters page and per_page to return the list of project issues."
    nameSpaces: "projects.issues.list"
    callback: stringifyFormat

  #ProjectMembers
  "members":
    filter: true
    param: [
      "<project_id>"
    ]
    desc: "Get a list of a project's team members."
    nameSpaces: "projects.members.list"
    callback: stringifyFormat
  "showMember":
    param: [
      "<project_id>"
      "<user_id>"
    ]
    desc: "Gets a project team member."
    nameSpaces: "projects.members.show"
    callback: stringifyFormat
  "addMember":
    param: [
      "<project_id>"
      "<user_id>"
      "[accessLevel]"
    ]
    help: accessLevelsCustomHelp
    desc: "Adds a user to a project team. This is an idempotent method and can be called multiple times with the same parameters. Adding team membership to a user that is already a member does not affect the existing membership."
    nameSpaces: "projects.members.add"
    callback: stringifyFormat
  "updateMember":
    param: [
      "<project_id>"
      "<user_id>"
      "[accessLevel]"
    ]
    help: accessLevelsCustomHelp
    desc: "Updates a project team member to a specified access level."
    nameSpaces: "projects.members.update"
    callback: stringifyFormat
  "removeMember":
    param: [
      "<project_id>"
      "<user_id>"
    ]
    desc: "Removes a user from a project team."
    nameSpaces: "projects.members.remove"
    callback: stringifyFormat

  #ProjectMergeRequests
  "mergeRequests":
    filter: true
    param: [
      "<project_id>"
    ]
    options:
      per_page: {
        param: "[per_page]"
        alias: "e"
        desc: "(optional) - The limit of list."
        type: true
        index: 1
      }
      page: {
        param: "[page]"
        alias: "p"
        desc: "(optional) - The offset of list."
        type: true
        index: 1
      }
      state:
        param: "[state]"
        alias: "s"
        type: true
        index: 1
        desc: "(optional) - Return all requests or just those that are merged, opened or closed"
      order_by:
        param: "[order_by]"
        alias: "o"
        type: true
        index: 1
        desc: "(optional) - Return requests ordered by created_at or updated_at fields. Default is created_at"
      sort:
        param: "[sort]"
        alias: "d"
        type: true
        index: 1
        desc: "(optional) - Return requests sorted in asc or desc order. Default is desc"
    desc: "Get all merge requests for this project."
    nameSpaces: "projects.merge_requests.list"
    callback: stringifyFormat
  "showMergeRequest":
    param: [
      "<project_id>"
      "<merge_request_id>"
    ]
    desc: "Shows information about a single merge request."
    nameSpaces: "projects.merge_requests.show"
    callback: stringifyFormat
  "addMergeRequest":
    param: [
      "<project_id>"
      "<sourceBranch>"
      "<targetBranch>"
      "<assignee_id>"
      "<title>"
    ]
    desc: "Creates a new merge request."
    nameSpaces: "projects.merge_requests.add"
    callback: stringifyFormat
  "updateMergeRequest":
    param: [
      "<project_id>"
      "<merge_request_id>"
    ]
    options:
      source_branch:
        param: "[source_branch]"
        alias: "s"
        type: true
        index: 2
        desc: "(optional) - The source branch."
      target_branch:
        param: "[target_branch]"
        alias: "b"
        type: true
        index: 2
        desc: "(optional) - The target branch."
      assignee_id:
        param: "[assignee_id]"
        alias: "a"
        type: true
        index: 2
        desc: "(optional) - Assignee user ID."
      title:
        param: "[title]"
        alias: "t"
        type: true
        index: 2
        desc: "(optional) - Title of MR."
      description:
        param: "[desc]"
        alias: "d"
        type: true
        index: 2
        desc: "(optional) - Description of MR."
      state_event:
        param: "[state_event]"
        alias: "e"
        type: true
        index: 2
        desc: "(optional) - New state (close|reopen|merge)."
    desc: "Updates an existing merge request. You can change branches, title, or even close the MR."
    nameSpaces: "projects.merge_requests.update"
    callback: stringifyFormat
  "commentMergeRequest":
    param: [
      "<project_id>"
      "<merge_request_id>"
      "<note>"
    ]
    desc: "Adds a comment to a merge request."
    nameSpaces: "projects.merge_requests.comment"
    callback: stringifyFormat

  #ProjectMilestones
  "milestones":
    filter: true
    param: [
      "<project_id>"
    ]
    desc: "Get retrive milestones of a given project."
    nameSpaces: "projects.milestones.list"
    callback: stringifyFormat
  "showMilestones":
    param: [
      "<project_id>"
      "<milestone_id>"
    ]
    desc: "Get retrive merge request of a given project and a milestone."
    nameSpaces: "projects.milestones.show"
    callback: stringifyFormat
  "addMilestones":
    param: [
      "<project_id>"
      "<title>"
      "<description>"
      "<due_date>"
    ]
    desc: "Add milestones by list of parameters."
    nameSpaces: "projects.milestones.add"
    callback: stringifyFormat
  "updateMilestones":
    param: [
      "<project_id>"
      "<milestone_id>"
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
    filter: true
    param: [
      "<project_id>"
    ]
    desc: "Get retrive branches of a given project."
    nameSpaces: "projects.repository.listBranches"
    callback: stringifyFormat

  "showBranch":
    param: [
      "<project_id>",
      "<branchId>"
    ]
    desc: "Get retrive branche of a given project and a branch id."
    nameSpaces: "projects.repository.showBranch"
    callback: stringifyFormat

  "listTags":
    filter: true
    param: [
      "<project_id>"
    ]
    desc: "Get retrive list tags of a given project."
    nameSpaces: "projects.repository.listTags"
    callback: stringifyFormat

  "listCommits":
    filter: true
    param: [
      "<project_id>"
    ]
    desc: "Get retrive list commits of a given project."
    nameSpaces: "projects.repository.listCommits"
    callback: stringifyFormat

  "showCommit":
    param: [
      "<project_id>",
      "<commit_id>"
    ]
    desc: "Get retrive commit of a given project and a commit id."
    nameSpaces: "projects.repository.showCommit"
    callback: stringifyFormat

  "diffCommit":
    param: [
      "<project_id>",
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
    filter: true
    options:
      per_page: {
        param: "[per_page]"
        alias: "e"
        desc: "(optional) - The limit of list."
        type: true
        index: 0
      }
      page: {
        param: "[page]"
        alias: "p"
        desc: "(optional) - The offset of list."
        type: true
        index: 0
      }
    desc: "Get retrive projects."
    nameSpaces: "projects.all"
    callback: stringifyFormat
  #todo show
  #todo create

  #ProjectUsers
  "users":
    filter: true
    desc: "Get retrive users from gitlab."
    nameSpaces: "users.all"
    callback: stringifyFormat
  "me":
    desc: "About me."
    nameSpaces: "users.current"
    callback: stringifyFormat
  "showUser":
    param: [
      "<user_id>"
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
