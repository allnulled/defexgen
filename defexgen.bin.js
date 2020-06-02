#!/usr/bin/env node
const os = require("os");
const fs = require("fs");
const path = require("path");
const args = require("yargs").argv;
const Defexgen = require(__dirname + "/defexgen.js");

if(args._.length === 0) {
	throw new Error("You need to provide at least 1 definitions file.");
}

let allContents = "";

for(let index=0; index < args._.length; index++) {
	const file = args._[index];
	const filepath = path.resolve(file);
	const contents = fs.readFileSync(filepath).toString();
	allContents += contents.replace(/[\r\n]+$/g, "") + os.EOL;
}

const htmlContent = Defexgen.parse(allContents);

if(args.output) {
	const outputpath = path.resolve(args.output);
	fs.writeFileSync(outputpath, htmlContent, "utf8");
} else {
	console.log(htmlContent);
}

