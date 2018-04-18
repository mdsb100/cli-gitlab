var defaultMap, checkOptions, configFilePath, fs, getMe, getObjectByNameSpaces, gitlab, gitlabDircPath, nconf, path, requireOrGetGitlab, _, gitlabLib;

defaultMap = require("./map.js");

nconf = require("nconf");

fs = require("fs");

path = require("path");

_ = require("underscore");

gitlabLib = require("gitlab")

gitlabDircPath = path.join(process.env[(process.platform === "win32" ? "USERPROFILE" : "HOME")], ".gitlab");

var stringify, stringifyFormat;

stringify = require("json-stable-stringify");

stringifyFormat = function(data) {
  if (data != null) {
    return console.log(stringify(data, {
      space: 2
    }));
  }
};

if (!fs.existsSync(gitlabDircPath)) {
  fs.mkdirSync(gitlabDircPath);
}

configFilePath = path.join(gitlabDircPath, "config.json");

nconf.file({
  file: configFilePath
});

gitlab = null;

checkOptions = function() {
  if (!nconf.get("url")) {
    console.log("You should set url by 'gitlab url http://example.com' ");
    return false;
  }
  if (!nconf.get("token")) {
    console.log("You should set token by 'gitlab token abcdefghij123456' ");
    return false;
  }
  return true;
};

requireOrGetGitlab = function() {
  if (gitlab != null) {
    return gitlab;
  } else {
    if (checkOptions()) {
      gitlab = gitlabLib({
        url: nconf.get("url"),
        token: nconf.get("token")
      });
      return gitlab;
    }
  }
};

exports.url = function(url) {
  if (url != null) {
    nconf.set("url", url);
    nconf.save();
    return console.log("Save url. Please make sure your settings are 'http' or 'https'.");
  } else {
    return console.log(nconf.get("url"));
  }
};

exports.token = function(token) {
  if (token != null) {
    nconf.set("token", token);
    nconf.save();
    console.log("Save token");
    gitlab = requireOrGetGitlab();
    return gitlab.users.current(function(data) {
      nconf.set("me", JSON.stringify(data));
      return nconf.save();
    });
  } else {
    return console.log(nconf.get("token"));
  }
};

exports.map = function(mapPath) {
  if (mapPath != null) {
    var map = fs.readFileSync(mapPath, 'utf8');
    console.log(map)
    nconf.set("map", map);
    nconf.save();
    console.log("Save map");
  } else {
    return console.log(JSON.stringify(nconf.get("map")||'{}'));
  }
};

getMe = function(key) {
  var me, result;
  result = null;
  me = nconf.get("me");
  if (me != null) {
    result = JSON.parse(me)[key];
  }
  if (result == null) {
    console.log("Please save token again!");
  }
  return result;
};

getObjectByNameSpaces = function(currentObject, nameSpaces) {
  var name, object, _i, _len;
  object = currentObject;
  nameSpaces = nameSpaces.split(".");
  for (_i = 0, _len = nameSpaces.length; _i < _len; _i++) {
    name = nameSpaces[_i];
    if (object[name]) {
      object = object[name];
    } else {
      return null;
    }
  }
  return object;
};

exports.getOption = function() {
  var key, opitons, value, _results;
  opitons = nconf.get();
  _results = [];
  for (key in opitons) {
    value = opitons[key];
    _results.push(console.log("" + key + ":" + value));
  }
  return _results;
};

exports.createOptions = function(program, param) {
  var key, value, _results;
  _results = [];
  for (key in param) {
    value = param[key];
    _results.push(program.option((value.alias != null ? "-" + value.alias + "," : "") + (" --" + key + " " + (value.param != null ? value.param : '')), value.desc));
  }
  return _results;
};

exports.createParam = function(params) {
  var item, ret, _i, _len;
  if (params == null) {
    return "";
  }
  ret = [];
  for (_i = 0, _len = params.length; _i < _len; _i++) {
    item = params[_i];
    ret.push(item);
  }
  return ret.join(" ");
};

exports.createCommands = function(program) {
  var userMapString = nconf.get("map"), userMap = {};
  if (userMapString) {
    userMap = JSON.parse(userMapString);
  }
  defaultMap = _.extend(defaultMap, userMap);
  return _.forEach(defaultMap, function(cmd, key) {
    var command;
    command = program.command("" + key + " " + (exports.createParam(cmd.param)));
    command.description(cmd.desc);
    if (cmd.help != null) {
      command.on("--help", cmd.help);
    }
    if (cmd.options == null) {
      cmd.options = {};
    }
    if (cmd.assigned_to_me != null) {
      cmd.options.assigned_to_me = {
        type: true,
        desc: "(optional) - Filter result if assigned to me."
      };
    }
    if (cmd.created_by_me != null) {
      cmd.options.created_by_me = {
        type: true,
        desc: "(optional) - Filter result if created by me."
      };
    }
    if (cmd.size != null) {
      cmd.options.size = {
        type: true,
        desc: "(optional) - Output size of result."
      };
    }
    if (cmd.filter === true) {
      cmd.options.filter = {
        param: "<filter>",
        type: true,
        desc: "(optional) - Filter result. For example: --filter 'item.assignee.id == 9' "
      };
    }
    exports.createOptions(command, cmd.options);
    return command.action(function() {
      var arg, fn, i, name, nameSpaces, options, target, value, _i, _len, _ref;
      options = arguments[arguments.length - 1] || {};
      arg = [];
      if ((cmd.param != null) && typeof arguments[0] !== "object") {
        i = 0;
        while (typeof arguments[i] !== "object") {
          var paramHooks = cmd.paramHooks || {};
          var hook = paramHooks[i];
          var obj = arguments[i];
          if (hook && hook === "toNumber") {
            obj = Number(obj);
          }
          arg.push(obj);
          i++;
        }
      }
      _ref = cmd.options;
      for (key in _ref) {
        value = _ref[key];
        if (value.index == null) {
          continue;
        }
        if (value.type) {
          if (arg[value.index] == null) {
            arg[value.index] = {};
          }
          if (options[key] != null) {
            arg[value.index][key] = options[key];
          }
        } else {
          if (options[key] != null) {
            arg[value.index] = options[key];
          }
        }
      }
      target = requireOrGetGitlab();
      nameSpaces = cmd.nameSpaces.split(".");
      fn = nameSpaces.pop();

      arg.push(function(data) {
        var evalFn, evalFnString;
        if (cmd.filter === true && (options != null) && (options.filter != null)) {
          evalFnString = "(function(item){ return " + options.filter + "; });";
          evalFn = eval(evalFnString);
          data = _.filter(data, evalFn);
        }
        if ((cmd.assigned_to_me != null) && (options.assigned_to_me != null)) {
          data = _.filter(data, function(item) {
            return getObjectByNameSpaces(item, cmd.assigned_to_me) === getMe("id");
          });
        }
        if ((cmd.created_by_me != null) && (options.created_by_me != null)) {
          data = _.filter(data, function(item) {
            return getObjectByNameSpaces(item, cmd.created_by_me) === getMe("id");
          });
        }
        stringifyFormat(data);
        if ((cmd.size != null) && (options.size != null)) {
          return console.log(data.length);
        }
      });
      
      for (_i = 0, _len = nameSpaces.length; _i < _len; _i++) {
        name = nameSpaces[_i];
        target = target[name];
      }
      return target[fn].apply(target, arg);
    });
  });
};

exports.getOption = function() {
  var key, opitons, value, _results;
  opitons = nconf.get();
  _results = [];
  for (key in opitons) {
    value = opitons[key];
    _results.push(console.log("" + key + ":" + value));
  }
  return _results;
};
