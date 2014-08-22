gitlab-cli
===========
Forked from [node-gitlab](https://github.com/moul/node-gitlab)

Usage
=====
```bash
# Install from npm for global
npm install gitlab -g
# You will see all command
gitlab --help
# For example
gitlab url "http://example.com"
gitlab token "abcdefghij123456"
gitlab users --current

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
gitlab table-head --get --type user

[ 'id', 'name', 'username' ]

# To see origin table head
gitlab table-head --origin --type user

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
gitlab table-head --add state --type user
gitlab table-head --get --type user

[ 'id', 'name', 'username', 'state' ]

gitlab users --current

id name    username state
9  Cao Jun mdsb100  active

# See "gitlab table-head --help" to see more commands.
```

Contributors
------------

- [Glavin Wiechert](https://github.com/Glavin001)
- [Florian Quiblier](https://github.com/fofoy)
- [Anthony Heber](https://github.com/aheber)
- [Evan Heidtmann](https://github.com/ezheidtmann)
- [luoqpolyvi](https://github.com/luoqpolyvi)
- [Brian Vanderbusch](https://github.com/LongLiveCHIEF)
- [daprahamian](https://github.com/daprahamian)
- [pgorecki](https://github.com/pgorecki)
- [mdsb100](https://github.com/mdsb100)

License
-------

MIT
