cli-gitlab
===========
Check [node-gitlab](https://github.com/moul/node-gitlab)
Dependencie on node-gitlab 1.7.0 or late
Quick Start
=====

You need to be very careful to set 'gitlab url'. 

Please make sure your settings are 'http' or 'https'.

```bash
# Install from npm for global
npm install cli-gitlab -g
# You will see all command
gitlab --help
# For example
gitlab url "http://example.com"
gitlab token "abcdefghij123456"
gitlab me

{
  "avatar_url": "http://gitlab.baidao.com//uploads/user/avatar/9/764b89699bcc946e4239b04f28002ce9.jpeg",
  "bio": "",
  "can_create_group": true,
  "can_create_project": true,
  "color_scheme_id": 1,
  "created_at": "2014-08-06T03:30:19.417Z",
  "email": "jun.cao@baidao.com",
  "extern_uid": null,
  "id": 9,
  ......
}

```

Extend Usage
=============
```
gitlab map test.json
```
test.json:
```
{
  "t": {
    "filter": true,
    "size": true,
    "param": ["<emailOrUsername>"],
    "desc": "Search user by email or username.",
    "nameSpaces": "users.search"
  }
}
```

```
gitlab t --help
  Usage: t [options] <emailOrUsername>

  Search user by email or username.

  Options:

    -h, --help          output usage information
     --size             (optional) - Output size of result.
     --filter <filter>  (optional) - Filter result. For example: --filter 'item.assignee.id == 9'
```
Check [map rule](https://github.com/mdsb100/cli-gitlab/blob/master/bin/map.js)

'nameSpaces' please check [node-gitlab](https://github.com/node-gitlab/node-gitlab/tree/develop/src/Models)

For example:


```
# In Projects.coffee
# class Projects extends BaseModel ==> projects
# @members = @load 'ProjectMembers' ===> memebers

# In ProjectMembers
# update: (projectId, userId, accessLevel = 30, fn = null) => ===> update

# so nameSpaces is 'projects.memebers.update'
```

By the way, the 'extend' function is used by undersore.extend.

Filter Usage
=============
```
gitlab issues --help

  Usage: issues [options]

  Get all issues created by authenticated user. This function takes pagination parameters page and per_page to restrict the list of issues.

  Options:

    -h, --help                 output usage information
    -s, --state [state]        (optional) - Return all issues or just those that are opened or closed
    -l, --labels [labels]      (optional) - Comma-separated list of label names
    -o, --order_by [order_by]  (optional) - Return requests ordered by created_at or updated_at fields. Default is created_at
    -d, --sort [sort]          (optional) - Return requests sorted in asc or desc order. Default is desc
    -e, --per_page [per_page]  (optional) - The limit of list.
    -p, --page [page]          (optional) - The offset of list.
     --assigned_to_me          (optional) - Filter result if assigned to me.
     --size [size]             (optional) - Output size of result.
     --filter <filter>         (optional) - Filter result. For example: --filter 'item.assignee.id == 9'
```

```
# "item" means current object, so aways use "item.xx"
gitlab issues --filter "item.assignee.id==9" --state closed
[
...
{
    "assignee": {
      "avatar_url": "http://gitlab.baidao.com//uploads/user/avatar/9/764b89699bcc946e4239b04f28002ce9.jpeg",
      "id": 9,
      "name": "Cao Jun",
      "state": "active",
      "username": "mdsb100"
    },
    "author": {
      "avatar_url": "http://gitlab.baidao.com//uploads/user/avatar/9/764b89699bcc946e4239b04f28002ce9.jpeg",
      "id": 9,
      "name": "Cao Jun",
      "state": "active",
      "username": "mdsb100"
    },
    "created_at": "2014-08-14T06:28:20.398Z",
    "description": "测试一下",
    "id": 2,
    "iid": 1,
    "labels": [
    ],
    "milestone": null,
    "project_id": 10,
    "state": "closed",
    "title": "Test Issue",
    "updated_at": "2014-08-15T10:25:31.588Z"
  },
...
]

```

Assigned to me. Created by me. Size
===================================
```
gitlab issues --assigned_to_me --created_by_me --state opened --size
```

```
[
  {
    "assignee": {
      "avatar_url": "http://gitlab.baidao.com//uploads/user/avatar/9/764b89699bcc946e4239b04f28002ce9.jpeg",
      "id": 9,
      "name": "Cao Jun",
      "state": "active",
      "username": "mdsb100"
    },
    "author": {
      "avatar_url": "http://gitlab.baidao.com//uploads/user/avatar/9/764b89699bcc946e4239b04f28002ce9.jpeg",
      "id": 9,
      "name": "Cao Jun",
      "state": "active",
      "username": "mdsb100"
    },
    "created_at": "2015-01-06T09:07:04.626Z",
    "description": "使用time_t（秒数）来计算时间\r\n使用tm来结构化时间",
    "id": 274,
    "iid": 5,
    "labels": [
    ],
    "milestone": null,
    "project_id": 12,
    "state": "opened",
    "title": "把boost依赖移除",
    "updated_at": "2015-01-06T09:07:04.626Z"
  }
]
1

gitlab me
{
  ......
  "id": 9,
  "is_admin": false,
  "linkedin": "",
  "name": "Cao Jun",
  ......
}
```

Issues Usage
=============
Refernce [issues](http://doc.gitlab.com/ce/api/issues.html)
```
gitlab createIssue --help

  Usage: createIssue [options] <projectId>

  Creates a new project issue.If the operation is successful, 200 and the newly created issue is returned. If an error occurs, an error number and a message explaining the reason is returned.

  Options:

    -h, --help                         output usage information
    -t, --title <title>                (required) - The title of an issue.
    -d, --description [desc]           (optional) - The description of an issue.
    -a, --assignee_id [assignee_id]    (optional) - The ID of a user to assign issue.
    -m, --milestone_id [milestone_id]  (optional) - The ID of a milestone to assign issue.
    -l, --labels [labels]              (optional) - Comma-separated label names for an issue.
    -dd, --due_date [due_date]         (optional) - Date time string in the format YEAR-MONTH-DAY, e.g. 2016-03-11

```

```
gitlab createIssue 12 -t test -a 9

{
  "assignee": {
    "avatar_url": "http://gitlab.baidao.com//uploads/user/avatar/9/764b89699bcc946e4239b04f28002ce9.jpeg",
    "id": 9,
    "name": "Cao Jun",
    "state": "active",
    "username": "mdsb100"
  },
  "author": {
    "avatar_url": "http://gitlab.baidao.com//uploads/user/avatar/9/764b89699bcc946e4239b04f28002ce9.jpeg",
    "id": 9,
    "name": "Cao Jun",
    "state": "active",
    "username": "mdsb100"
  },
  "created_at": "2015-02-10T03:53:53.341Z",
  "description": null,
  "id": 807,
  "iid": 7,
  "labels": [
  ],
  "milestone": null,
  "project_id": 12,
  "state": "opened",
  "title": "test",
  "updated_at": "2015-02-10T03:53:53.341Z"
}
```

```
gitlab editIssue --help

  Usage: editIssue [options] <projectId> <issueId>

  Updates an existing project issue. This function is also used to mark an issue as closed.If the operation is successful, 200 and the updated issue is returned. If an error occurs, an error number and a message explaining the reason is returned.

  Options:

    -h, --help                         output usage information
    -t, --title [title]                (optional) - The title of an issue.
    -d, --description [desc]           (optional) - The description of an issue.
    -a, --assignee_id [assignee_id]    (optional) - The ID of a user to assign issue.
    -m, --milestone_id [milestone_id]  (optional) - The ID of a milestone to assign issue.
    -l, --labels [labels]              (optional) - Comma-separated label names for an issue.
    -s, --state_event [state_event]    (optional) - The state event of an issue ('close' to close issue and 'reopen' to reopen it).
    -dd, --due_date [due_date]         (optional) - Date time string in the format YEAR-MONTH-DAY, e.g. 2016-03-11
```

```
gitlab editIssue 12 807 -t test_it -d totest

{
  "assignee": {
    "avatar_url": "http://gitlab.baidao.com//uploads/user/avatar/9/764b89699bcc946e4239b04f28002ce9.jpeg",
    "id": 9,
    "name": "Cao Jun",
    "state": "active",
    "username": "mdsb100"
  },
  "author": {
    "avatar_url": "http://gitlab.baidao.com//uploads/user/avatar/9/764b89699bcc946e4239b04f28002ce9.jpeg",
    "id": 9,
    "name": "Cao Jun",
    "state": "active",
    "username": "mdsb100"
  },
  "created_at": "2015-02-10T03:53:53.341Z",
  "description": "totest",
  "id": 807,
  "iid": 7,
  "labels": [
  ],
  "milestone": null,
  "project_id": 12,
  "state": "opened",
  "title": "test_it",
  "updated_at": "2015-02-10T04:03:35.287Z"
}

```

[List of commands](https://github.com/mdsb100/cli-gitlab/blob/master/bin/map.coffee)
----------------
- groups
- showGroup
- showGroupProjects
- showGroupMembers
- addGroupMember
- createGroup
- transferProjectToGroup
- searchGroup
- issueNotes
- issues
- showIssue
- createIssue
- editIssue
- createLabel
- createNote
- keys
- getKey
- addKey
- hooks
- showHook
- addHook
- updateHook
- removeHook
- projectIssues
- projectLabels
- members
- showMember
- addMember
- updateMember
- removeMember
- mergeRequests
- showMergeRequest
- addMergeRequest
- updateMergeRequest
- commentMergeRequest
- milestones
- showMilestones
- addMilestones
- updateMilestones
- branches
- showBranch
- protectBranch
- unprotectBranch
- createBranch
- deleteBranch
- tags
- commits
- showCommit
- diffCommit
- trees
- projects
- showProject
- createProject
- createProjectForUser
- updateProject
- projectsAdminOnly
- removeProject
- forkProject
- searchProject
- triggersOfProject
- showProjectService
- removeProjectService
- addUserKey
- userKeys
- addUserKey
- users
- me
- showUser
- createUser
- session
- searchUsers

Thank
------------
[Dave Irvine](https://github.com/dave-irvine)

License
-------
MIT
