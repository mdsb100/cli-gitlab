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

Options Usage
=============
```
gitlab projectIssues --help

Usage: projectIssues [options] <projectId>

  Get retrive issue of a given project.

  Options:

    -h, --help                 output usage information
    -e, --per_page [per_page]  The limit of list.
    -p, --page [page]          The offset of list.


gitlab projectIssues 10 -e 100 -p 1

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

1.1.2(2015.1.14)
- Add a map file.
- Refactor: Useinig a map to create commands.
- Add feature: projects > --tags, --commits, --branches and --tree.
- Init. Basal feature.
