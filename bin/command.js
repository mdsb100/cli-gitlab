var packageInfo, program, worker;

program = require("commander");

packageInfo = require("./../package.json");

worker = require("./worker.js");

program.usage("[options]").version(packageInfo.version).option("-o, --option", "Get option", worker.getOption);

program.command("url [url]").description("Get or Set url of your gitlab website. Please make sure your settings are 'http' or 'https'.").action(worker.url);

program.command("token [token]").description("Get or Set token of gitlab").action(worker.token);

program.command("map [map]").description("Get or Set map.json of gitlab").action(worker.map);

worker.createCommands(program);

program.parse(process.argv);

if (process.argv.length === 2) {
  program.help();
}
