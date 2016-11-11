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
  "createGroup":
    options:
      "name": {
        param: "<name>"
        alias: "n"
        desc: "name (required) - The name of the group"
        type: true
        index: 0
      }
      "path": {
        param: "<path>"
        alias: "p"
        desc: "path (required) - The path of the group."
        type: true
        index: 0
      }
      "description": {
        param: "[desc]"
        alias: "d"
        desc: "(optional) - The description of an issue."
        type: true
        index: 0
      }
      "visibility_level": {
        param: "[visibility_level]"
        alias: "v"
        desc: "(optional) - The group's visibility. 0 for private, 10 for internal, 20 for public."
        type: true
        index: 0
      }
    desc: "Creates a new project group. Available only for users who can create groups."
    help: accessLevelsCustomHelp
    nameSpaces: "groups.create"
    callback: stringifyFormat
  "transferProjectToGroup":
    param: [
      "<id>"
      "<project_id>"
    ]
    desc: "Transfer a project to the Group namespace. Available only for admin."
    # help: accessLevelsCustomHelp
    nameSpaces: "groups.addProject"
    callback: stringifyFormat
  "searchGroup":
    param: [
      "<nameOrPath>"
    ]
    desc: "Get all groups that match your string in their name or path."
    # help: accessLevelsCustomHelp
    nameSpaces: "groups.search"
    callback: stringifyFormat

  #IssuesNote
  "issueNotes":
    filter: true
    size: true
    param: [
      "<projectId>"
      "<issueId>"
    ]
    desc: "List project issue notes."
    nameSpaces: "issues.notes.all"
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
      "due_date": {
        param: "[due_date]"
        alias: "dd"
        desc: "(optional) - Date time string in the format YEAR-MONTH-DAY, e.g. 2016-03-11"
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
      "due_date": {
        param: "[due_date]"
        alias: "dd"
        desc: "(optional) - Date time string in the format YEAR-MONTH-DAY, e.g. 2016-03-11"
        type: true
        index: 2
      }
    desc: "Updates an existing project issue. This function is also used to mark an issue as closed.If the operation is successful, 200 and the updated issue is returned. If an error occurs, an error number and a message explaining the reason is returned."
    nameSpaces: "issues.edit"
    callback: stringifyFormat

  #Labels
  "createLabel":
    param: [
      "<project_id>"
    ]
    options:
      title:
        param: "<name>"
        alias: "n"
        type: true
        index: 1
        desc: "(required) - The name of the label."
      key:
        param: "<color>"
        alias: "c"
        type: true
        index: 1
        desc: "(required) - The color of the label in 6-digit hex notation with leading # sign."
      description:
        param: "[description]"
        alias: "d"
        type: true
        index: 1
        desc: "(optional) - The description of the label."
    desc: "Creates a new label for the given repository with the given name and color."
    nameSpaces: "labels.create"
    callback: stringifyFormat

  #Notes
  "createNote":
    param: [
      "<project_id>"
      "<issue_id>"
    ]
    options:
      body:
        param: "<body>"
        alias: "b"
        type: true
        index: 1
        desc: "(required) - The content of a note."
      created_at:
        param: "[created_at]"
        alias: "c"
        type: true
        index: 1
        desc: " (optional) - Date time string, ISO 8601 formatted, e.g. 2016-03-11T03:45:40Z."
    desc: "Creates a new note to a single project issue."
    nameSpaces: "notes.create"
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
  
  #ProjectLabels
  "projectLabels":
    filter: true
    size: true
    param: [
      "<project_id>"
    ]
    desc: "Get all labels for a given project."
    nameSpaces: "projects.lables.all"
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
    # options:
    #   description:
    #     param: "[desc]"
    #     alias: "d"
    #     type: true
    #     index: 6
    #     desc: "(optional) - Description of MR."
    #   target_project_id:
    #     param: "[target_project_id]"
    #     alias: "p"
    #     type: true
    #     index: 6
    #     desc: "(optional) - The target project (numeric id)."
    #   labels:
    #     param: "[lables]"
    #     alias: "l"
    #     type: true
    #     index: 6
    #     desc: "(optional) - Labels for MR as a comma-separated list."
    #   milestone_id:
    #     param: "[milestone_id]"
    #     alias: "m"
    #     type: true
    #     index: 6
    #     desc: "(optional) - Milestone ID."
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
      labels:
        param: "[lables]"
        alias: "l"
        type: true
        index: 2
        desc: "(optional) - Labels for MR as a comma-separated list."
      milestone_id:
        param: "[milestone_id]"
        alias: "m"
        type: true
        index: 2
        desc: "(optional) - Milestone ID."
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
    desc: "Returns a list of project milestones."
    nameSpaces: "projects.milestones.list"
    callback: stringifyFormat
  "showMilestones":
    param: [
      "<project_id>"
      "<milestone_id>"
    ]
    desc: "Gets a single project milestone."
    nameSpaces: "projects.milestones.show"
    callback: stringifyFormat
  "addMilestones":
    param: [
      "<project_id>"
      "<title>"
      "<description>"
      "<due_date>"
    ]
    desc: "Creates a new project milestone."
    nameSpaces: "projects.milestones.add"
    callback: stringifyFormat
  "updateMilestones":
    param: [
      "<project_id>"
      "<milestone_id>"
      "<title>"
      "<description>"
      "<due_date>"
      "<state_event>"
    ]
    desc: "Updates an existing project milestone. The state event of the milestone (close|activate)."
    nameSpaces: "projects.milestones.update"
    callback: stringifyFormat

  #ProjectRepository
  "branches":
    filter: true
    param: [
      "<project_id>"
    ]
    desc: "Get a list of repository branches from a project, sorted by name alphabetically."
    nameSpaces: "projects.repository.listBranches"
    callback: stringifyFormat
  "showBranch":
    param: [
      "<project_id>",
      "<branch_id>"
    ]
    desc: "Get a single project repository branch."
    nameSpaces: "projects.repository.showBranch"
    callback: stringifyFormat
  "protectBranch":
    param: [
      "<project_id>",
      "<branch_id>"
    ]
    desc: "Protects a single project repository branch. This is an idempotent function, protecting an already protected repository branch still returns a 200 OK status code."
    nameSpaces: "projects.repository.protectBranch"
    callback: stringifyFormat
  "unprotectBranch":
    param: [
      "<project_id>",
      "<branch_id>"
    ]
    desc: "Unprotects a single project repository branch. This is an idempotent function, unprotecting an already unprotected repository branch still returns a 200 OK status code."
    nameSpaces: "projects.repository.unprotectBranch"
    callback: stringifyFormat
  "createBranch":
    options:
      project_id:
        param: "<project_id>"
        alias: "i"
        type: true
        index: 0
        desc: "(required) - The ID of a project."
      branch_name:
        param: "<branch_name>"
        alias: "b"
        type: true
        index: 0
        desc: "(required) - The name of the branch."
      ref:
        param: "<ref>"
        alias: "r"
        type: true
        index: 0
        desc: "(required) - Create branch from commit SHA or existing branch."
    desc: "It return 200 if succeed or 400 if failed with error message explaining reason.."
    nameSpaces: "projects.repository.createBranch"
    callback: stringifyFormat
  "deleteBranch":
    param: [
      "<project_id>",
      "<branch_id>"
    ]
    desc: "It return 200 if succeed, 404 if the branch to be deleted does not exist or 400 for other reasons. In case of an error, an explaining message is provided."
    nameSpaces: "projects.repository.deleteBranch"
    callback: stringifyFormat

  "tags":
    filter: true
    param: [
      "<project_id>"
    ]
    desc: "Get retrive list tags of a given project."
    nameSpaces: "projects.repository.listTags"
    callback: stringifyFormat

  "commits":
    filter: true
    param: [
      "<project_id>"
    ]
    desc: "Get a list of repository commits in a project."
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
    desc: "Get the diff of a commit in a project."
    nameSpaces: "projects.repository.diffCommit"
    callback: stringifyFormat

  "trees":
    filter: true
    param: [
      "<project_id>"
    ]
    options:
      path:
        param: "<path>"
        alias: "p"
        type: true
        index: 1
        desc: " (optional) - The path inside repository. Used to get contend of subdirectories."
      ref_name:
        param: "<ref_name>"
        alias: "r"
        type: true
        index: 1
        desc: "(optional) - The name of a repository branch or tag or if not given the default branch."
    desc: "Get a list of repository files and directories in a project."
    nameSpaces: "projects.repository.listTree"
    callback: stringifyFormat

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
      archived:
        param: "[archived]"
        alias: "a"
        type: true
        index: 0
        desc: "(optional) - if passed, limit by archived status."
      order_by:
        param: "[order_by]"
        alias: "o"
        type: true
        index: 0
        desc: "(optional) - Return requests ordered by id, name, path, created_at, updated_at or last_activity_at fields. Default is created_at."
      sort:
        param: "[sort]"
        alias: "s"
        type: true
        index: 0
        desc: "(optional) - Return requests sorted in asc or desc order. Default is desc."
      search:
        param: "[search]"
        alias: "e"
        type: true
        index: 0
        desc: "(optional) - Return list of authorized projects according to a search criteria."
    desc: "Get a list of projects accessible by the authenticated user."
    nameSpaces: "projects.all"
    callback: stringifyFormat
  "showProject":
    param: [
      "<project_id>"
    ]
    desc: "Get single project."
    nameSpaces: "projects.show"
    callback: stringifyFormat
  "createProject":
    param: []
    options:
      name: {
        param: "<name>"
        desc: "(required) - new project name."
        type: true
        index: 0
      }
      path: {
        param: "[path]"
        alias: "p"
        desc: "(optional) - custom repository name for new project. By default generated based on name."
        type: true
        index: 0
      }
      namespace_id: {
        param: "[namespace_id]"
        alias: "n"
        desc: "(optional) - namespace for the new project (defaults to user)."
        type: true
        index: 0
      }
      description: {
        param: "[desc]"
        alias: "d"
        desc: "(optional) - namespace for the new project (defaults to user)."
        type: true
        index: 0
      }
      issues_enabled: {
        param: "[issues_enabled]"
        alias: "i"
        desc: "(optional)"
        type: true
        index: 0
      }
      merge_requests_enabled: {
        param: "[merge_requests_enabled]"
        alias: "m"
        desc: "(optional)"
        type: true
        index: 0
      }
      wiki_enabled: {
        param: "[wiki_enabled]"
        alias: "w"
        desc: "(optional)"
        type: true
        index: 0
      }
      snippets_enabled: {
        param: "[snippets_enabled]"
        alias: "s"
        desc: "(optional)"
        type: true
        index: 0
      }
      public_builds: {
        param: "[public_builds]"
        alias: "p"
        desc: "(optional) - if true same as setting visibility_level = 20."
        type: true
        index: 0
      }
      visibility_level: {
        param: "[visibility_level]"
        alias: "v"
        desc: "(optional)"
        type: true
        index: 0
      }
      import_url: {
        param: "[import_url]"
        alias: "u"
        desc: "(optional)"
        type: true
        index: 0
      }
    desc: "Creates a new project owned by the authenticated user."
    nameSpaces: "projects.create"
    callback: stringifyFormat
  "createProjectForUser":
    param: []
    options:
      user_id: {
        param: "<user_id>"
        alias: "u"
        desc: "(required) - user_id of owner."
        type: true
        index: 0
      }
      name: {
        param: "<name>"
        alias: "n"
        desc: " (required) - new project name."
        type: true
        index: 0
      }
      description: {
        param: "[desc]"
        alias: "d"
        desc: "(optional) - namespace for the new project (defaults to user)."
        type: true
        index: 0
      }
      issues_enabled: {
        param: "[issues_enabled]"
        alias: "i"
        desc: "(optional)"
        type: true
        index: 0
      }
      merge_requests_enabled: {
        param: "[merge_requests_enabled]"
        alias: "m"
        desc: "(optional)"
        type: true
        index: 0
      }
      builds_enabled: {
        param: "[builds_enabled]"
        alias: "b"
        desc: "(optional)"
        type: true
        index: 1
      }
      wiki_enabled: {
        param: "[wiki_enabled]"
        alias: "w"
        desc: "(optional)"
        type: true
        index: 1
      }
      snippets_enabled: {
        param: "[snippets_enabled]"
        alias: "s"
        desc: "(optional)"
        type: true
        index: 1
      }
      container_registry_enabled: {
        param: "[container_registry_enabled]"
        alias: "c"
        desc: "(optional)"
        type: true
        index: 1
      }
      shared_runners_enabled: {
        param: "[shared_runners_enabled]"
        alias: "r"
        desc: "(optional)"
        type: true
        index: 1
      }
      public: {
        param: "[public]"
        alias: "p"
        desc: "(optional) - if true same as setting visibility_level = 20."
        type: true
        index: 1
      }
      visibility_level: {
        param: "[visibility_level]"
        alias: "v"
        desc: "(optional)"
        type: true
        index: 1
      }
      public_builds: {
        param: "[public_builds]"
        desc: "(optional)"
        type: true
        index: 1
      }
    desc: "Creates a new project owned by the specified user. Available only for admins."
    nameSpaces: "projects.create_for_user"
    callback: stringifyFormat
  "updateProject":
    param: [
      "projectId"
    ]
    options:
      name: {
        param: "<name>"
        desc: "(required) - new project name."
        type: true
        index: 1
      }
      path: {
        param: "[path]"
        alias: "p"
        desc: "(optional) - custom repository name for new project. By default generated based on name."
        type: true
        index: 1
      }
      description: {
        param: "[desc]"
        alias: "d"
        desc: "(optional) - namespace for the new project (defaults to user)."
        type: true
        index: 1
      }
      default_branch: {
        param: "[default_branch]"
        alias: "b"
        desc: "(optional)"
        type: true
        index: 1
      }
      issues_enabled: {
        param: "[issues_enabled]"
        alias: "i"
        desc: "(optional)"
        type: true
        index: 1
      }
      merge_requests_enabled: {
        param: "[merge_requests_enabled]"
        alias: "m"
        desc: "(optional)"
        type: true
        index: 1
      }
      builds_enabled: {
        param: "[builds_enabled]"
        alias: "b"
        desc: "(optional)"
        type: true
        index: 1
      }
      wiki_enabled: {
        param: "[wiki_enabled]"
        alias: "w"
        desc: "(optional)"
        type: true
        index: 1
      }
      snippets_enabled: {
        param: "[snippets_enabled]"
        alias: "s"
        desc: "(optional)"
        type: true
        index: 1
      }
      container_registry_enabled: {
        param: "[container_registry_enabled]"
        alias: "c"
        desc: "(optional)"
        type: true
        index: 1
      }
      shared_runners_enabled: {
        param: "[shared_runners_enabled]"
        alias: "r"
        desc: "(optional)"
        type: true
        index: 1
      }
      public: {
        param: "[public]"
        alias: "p"
        desc: "(optional) - if true same as setting visibility_level = 20."
        type: true
        index: 1
      }
      visibility_level: {
        param: "[visibility_level]"
        alias: "v"
        desc: "(optional)"
        type: true
        index: 1
      }
      public_builds: {
        param: "[public_builds]"
        desc: "(optional)"
        type: true
        index: 1
      }
    desc: "Update project."
    nameSpaces: "projects.edit"
    callback: stringifyFormat
  "projectsAdminOnly":
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
      archived:
        param: "[archived]"
        alias: "a"
        type: true
        index: 0
        desc: "(optional) - if passed, limit by archived status."
      order_by:
        param: "[order_by]"
        alias: "o"
        type: true
        index: 0
        desc: "(optional) - Return requests ordered by id, name, path, created_at, updated_at or last_activity_at fields. Default is created_at."
      sort:
        param: "[sort]"
        alias: "s"
        type: true
        index: 0
        desc: "(optional) - Return requests sorted in asc or desc order. Default is desc."
      search:
        param: "[search]"
        alias: "e"
        type: true
        index: 0
        desc: "(optional) - Return list of authorized projects according to a search criteria."
    desc: "Get a list of all GitLab projects (admin only)."
    nameSpaces: "projects.allAdmin"
    callback: stringifyFormat
  "removeProject":
    param: [
      "<projectId>"
    ]
    desc: "Remove project by project id."
    nameSpaces: "projects.remove"
    callback: stringifyFormat
  "forkProject":
    param: [
      "<projectId>"
    ]
    desc: "Forks a project into the user namespace of the authenticated user."
    nameSpaces: "projects.fork"
    callback: stringifyFormat
  "searchProject":
    size: true
    filter: true
    param: [
      "<projectName>"
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
      archived:
        param: "[archived]"
        alias: "a"
        type: true
        index: 1
        desc: "(optional) - if passed, limit by archived status."
      order_by:
        param: "[order_by]"
        alias: "o"
        type: true
        index: 1
        desc: "(optional) - Return requests ordered by id, name, path, created_at, updated_at or last_activity_at fields. Default is created_at."
      sort:
        param: "[sort]"
        alias: "s"
        type: true
        index: 1
        desc: "(optional) - Return requests sorted in asc or desc order. Default is desc."
    desc: "Search for projects by name which are accessible to the authenticated user."
    nameSpaces: "projects.search"
    callback: stringifyFormat
  "triggersOfProject":
    size: true
    filter: true
    param: [
      "<projectId>"
    ]
    desc: "Get triggers from project"
    nameSpaces: "projects.listTriggers"
    callback: stringifyFormat

  #ProjectServices
  "showProjectService":
    param: [
      "<projectId>"
      "<serviceName>"
    ]
    desc: "Show project Service by project id and service name."
    nameSpaces: "projects.services.show"
    callback: stringifyFormat
  # "updateProjectService":
  #   param: [
  #     "<projectId>"
  #     "<serviceName>"
  #   ]
  #   desc: "Update project Service by project id and service name."
  #   nameSpaces: "projects.services.update"
  #   callback: stringifyFormat
  "removeProjectService":
    param: [
      "<projectId>"
      "<serviceName>"
    ]
    desc: "Remove project Service by project id and service name."
    nameSpaces: "projects.services.remove"
    callback: stringifyFormat


  #UserKeys
  "userKeys":
    filter: true
    param: [
      "<userId>"
    ]
    desc: "Get user keys by user id."
    nameSpaces: "users.keys.all"
    callback: stringifyFormat
  "addUserKey":
    param: [
      "<userId>"
      "<title>"
      "<key>"
    ]
    desc: "Add user keys by user id and title and key."
    nameSpaces: "users.keys.addKey"
    callback: stringifyFormat

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
  "createUser":
    param: []
    options:
      name: {
        param: "<name>"
        alias: "n"
        desc: "(required) - Name."
        type: true
        index: 0
      }
      password: {
        param: "<password>"
        alias: "p"
        desc: "(required) - Password."
        type: true
        index: 0
      }
      username: {
        param: "<username>"
        alias: "u"
        desc: "(required) - Username."
        type: true
        index: 0
      }
      email: {
        param: "<email>"
        alias: "e"
        desc: "(required) - Email."
        type: true
        index: 0
      }
      skype: {
        param: "[skype]"
        alias: "s"
        desc: "(optional) - Skype ID."
        type: true
        index: 0
      }
      linkedin: {
        param: "[linkedin]"
        alias: "l"
        desc: "(optional) - LinkedIn."
        type: true
        index: 0
      }
      twitter: {
        param: "[twitter]"
        alias: "t"
        desc: "(optional) - Twitter account."
        type: true
        index: 0
      }
      website_url: {
        param: "[website_url]"
        alias: "w"
        desc: "(optional) - Website URL."
        type: true
        index: 0
      }
      projects_limit: {
        param: "[projects_limit]"
        alias: "p"
        desc: "(optional) - Number of projects user can create."
        type: true
        index: 0
      }
      extern_uid: {
        param: "[extern_uid]"
        alias: "x"
        desc: "(optional) - External UID."
        type: true
        index: 0
      }
      provider: {
        param: "[provider]"
        alias: "r"
        desc: "(optional) - External provider name."
        type: true
        index: 0
      }
      bio: {
        param: "[bio]"
        alias: "b"
        desc: "(optional) - User's biography."
        type: true
        index: 0
      }
      location: {
        param: "[location]"
        alias: "lo"
        desc: "(optional) - User's location."
        type: true
        index: 0
      }
      admin: {
        param: "[admin]"
        alias: "a"
        desc: "(optional) - User is admin - true or false (default)."
        type: true
        index: 0
      }
      can_create_group: {
        param: "[can_create_group]"
        alias: "c"
        desc: "(optional) - User can create groups - true or false."
        type: true
        index: 0
      }
      confirm: {
        param: "[confirm]"
        alias: "co"
        desc: "(optional) - Require confirmation - true (default) or false."
        type: true
        index: 0
      }
      external: {
        param: "[external]"
        alias: "ex"
        desc: "(optional) - Flags the user as external - true or false(default)."
        type: true
        index: 0
      }
    desc: "Creates a new user. Note only administrators can create new users."
    nameSpaces: "users.create"
    callback: stringifyFormat
  "session":
    param: [
      "<email>"
      "<password>"
    ]
    desc: "Get session by email and password."
    nameSpaces: "users.session"
    callback: stringifyFormat
  "searchUsers":
    filter: true
    size: true
    param: [
      "<emailOrUsername>"
    ]
    desc: "Search user by email or username."
    nameSpaces: "users.search"
    callback: stringifyFormat
