cli-gitlab
===========
Forked from [node-gitlab](https://github.com/moul/node-gitlab)

Usage
=====
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
  "is_admin": false,
  "linkedin": "",
  "name": "Cao Jun",
  "private_token": "6Xvkd6jicJwTq3rYWKsq",
  "provider": null,
  "skype": "",
  "state": "active",
  "theme_id": 2,
  "twitter": "",
  "username": "mdsb100",
  "website_url": ""
}

```

[List of commands](https://github.com/mdsb100/cli-gitlab/blob/master/bin/map.coffee)
----------------
- groups
- showGroup
- showGroupProjects
- showGroupMembers
- issues
- createIssue
- editIssue
- showIssue
- keys
- getKey
- hooks
- showHook
- addHook
- updateHook
- removeHook
- projectIssues
- members
- showMember
- addMember
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
- listBranches
- showBranch
- listTags
- listCommits
- showCommit
- diffCommit
- projects
- users
- me
- showUser
- session

Filter Usage
=============
```
gitlab issues --help
--filter [filter]         (optional) - Filter result. For example: --filter 'item.assignee.id == 9'

# "item" means current object, so aways use "item.xx"
gitlab issues --filter "item.author.id==9" -s closed
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

Issues Usage
=============
## Refernce [issues](http://doc.gitlab.com/ce/api/issues.html)
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

Contributors
------------

- [mdsb100](https://github.com/mdsb100)

Thank
------------

[Dave Irvine](https://github.com/dave-irvine)

License
-------

MIT

Changelog
------------
1.1.5(2015.2.11)
- Add function "filter".

1.1.4(2015.2.10)
- Fix editIssue, change "title" to optional.

1.1.3(2015.2.10)
- Modify command of issues.

1.1.2(2015.1.14)
- Add a map file.
- Refactor: Useinig a map to create commands.
- Add feature: projects > --tags, --commits, --branches and --tree.
- Init. Basal feature.
