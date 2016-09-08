program = require("commander")
packageInfo = require("./../package.json")
worker = require("./worker.js")
map = require("./map.js")

program.usage("[options]")
.version(packageInfo.version)
.option("-o, --option", "Get option", worker.getOption)

program.command("url [url]")
.description("Get or Set url of your gitlab website. Please make sure your settings are 'http' or 'https'.")
.action(worker.url)

program.command("token [token]")
.description("Get or Set token of gitlab")
.action(worker.token)

worker.createCommands(map, program)

program.parse process.argv

program.help()  if process.argv.length is 2