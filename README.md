# defexgen

DEFinitions EXam GENerator: programming language to easily create test-based exams from a set of definitions.

## Why

To generate test-based exams on the fly, easily.

## Install

`$ npm i -g defexgen`

## What is it?

`defexgen` is a program and a programming language.

The programming language defines the syntax you have to follow when you write your definitions.

The program is the responsible of getting that syntax and creating exams for you.

## Syntax

```
${NAME}:
  ${DEFINITION}

${NAME}:
  ${DEFINITION}

${NAME}:
  ${DEFINITION}
```

You have to leave 1 line of separation between definitions.

## Usage

You can use it from the CLI (passing files) or from the API (passing text).

### CLI usage

`$ defexgen definitions-1.txt definitions-2.txt definitions-3.txt --output exam.html`

This command will read files `definitions-1.txt`, `definitions-2.txt` and `definitions-3.txt`.

From them, it will parse the contents, and generate a `exam.html` file.

When you open this file with your browser, you will get the exam.

### API usage

```js
const htmlPage = require("defexgen").parse(`Name 1:
	Definition of the name 1.

Name 2:
	Definition of the name 2.

Name 3:
	Definition of the name 3.
`);
```

## License

This project is licensed under [WTFPL or What The Fuck Public License](https://es.wikipedia.org/wiki/WTFPL), so do what you want.

## Issues

Please, refer issues to [issues page](https://github.com/allnulled/defexgen/issues).

