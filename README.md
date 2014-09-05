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

id name    username
9  Cao Jun mdsb100

```

Config CLI output?
=====
```bash
# There are some types
gitlab table-head

type of table head: [ 'user', 'project', 'issue' ]

# To see table head
gitlab table-head get --type user

[ 'id', 'name', 'username' ]

# To see origin table head
gitlab table-head getOrigin --type user

[ 'id',
  'name',
  'username',
  'state',
  'avatar_url',
  'created_at',
  'is_admin',
  'bio',
  'skype',
  'linkedin',
  'twitter',
  'website_url',
  'email',
  'theme_id',
  'color_scheme_id',
  'extern_uid',
  'provider',
  'can_create_group',
  'can_create_project',
  'private_token' ]

# Add a head
gitlab table-head add state --type user
gitlab table-head get --type user

[ 'id', 'name', 'username', 'state' ]

gitlab users me

id name    username state
9  Cao Jun mdsb100  active

# See "gitlab table-head --help" to see more commands.
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

1.0.1(2014.9.3)

- Add feature: projects > --tags, --commits, --branches and --tree.
- Init. Basal feature.
