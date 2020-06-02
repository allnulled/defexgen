{
  const formOptions = {
    NUMBER_OF_OPTIONS: 3
  };
  const getId = function() {
    let id = "";
    const chars = "abcdefghijklmnopqrstuvwxyz".split("");
    for(let i=0; i<20; i++) {
      id += getRandomItem(chars);
    }
    return id;
  };
  const getRandomItem = function(items) {
    return items[Math.floor(Math.random() * items.length)];
  };
  const shuffleItems = function(items) {
    const array = [].concat(items);
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
  };
  const wrapInPage = function(contents) {
    return "" +
      "<!DOCTYPE html>\n" +
      "<html>\n" +
      "<head>\n" +
      "  <meta charset='utf8' />\n" +
      "</head>\n" +
      "<body>\n" + contents +
      "</body>\n" +
      "</html>"
  }
  const createForm = function(defs) {
    let form = "";
    if(defs.length < 2) {
      throw new Error("The dictionary must have at least 2 definitions");
    }
    defs = shuffleItems(defs);
    form += '<button onclick="window.correctAll()">Finished</button>';
    form += '<div data-solutions-conclusion></div>\n';
    for(let i=0; i<defs.length; i++) {
      const def = defs[i];
      const inputsId = getId();
      const correctOption = def.def;
      form += "" +
        '<fieldset class="question">\n' +
        '  <div>\n' + 
        '    <b style="text-transform: uppercase">' + def.word + ':</b>\n' + 
        '    <button data-corrector-button style="float:right" onclick="window.correctQuestion(this)">?!</button>\n' + 
        '  </div>\n' +
        '  <div data-solution-message></div>\n' +
        "  <div>\n";
      let possibilities = [];
      const maxPossibilities = defs.length <= formOptions.NUMBER_OF_OPTIONS ? (defs.length - 1) : formOptions.NUMBER_OF_OPTIONS;
      while(possibilities.length < maxPossibilities) {
        const incorrectOption = getRandomItem(defs);
        if(incorrectOption.word !== def.word) {
          if(possibilities.indexOf(incorrectOption) === -1) {
            possibilities.push(incorrectOption);
          }
        }
      }
      possibilities.push(Object.assign({}, def, {solution: true}));
      possibilities = shuffleItems(possibilities);
      for(let indexPoss = 0; indexPoss < possibilities.length; indexPoss++) {
        const possibility = possibilities[indexPoss];
        form += '    <div>\n';
        form += '      <span>\n';
        form += '        <input type="radio" name="' + inputsId + '" value="' + possibility.word + '"';
        if(possibility.solution) {
          form += ' data-solution';
        }
        form += ' />\n';
        form += '        <span>' + possibility.def + '</span>\n';
        form += '      </span>\n';
        form += '    <div>\n';
      }
      form += "" + 
        "  </div>\n" +
        "</fieldset>\n";
    }
    form += '<script>\n' +
    'window.correctQuestion = function(button) {\n' +
    '  const questionElement = button.parentNode.parentNode;\n' +
    '  const solution = questionElement.getAttribute("data-solution");\n' +
    '  const solutionElement = questionElement.querySelector("[data-solution]");\n' +
    '  const solutionMessageElement = questionElement.querySelector("[data-solution-message]");\n' +
    '  if(solutionElement.checked) {\n' +
    '    solutionMessageElement.innerHTML = "The answer is correct.";\n' +
    '    solutionMessageElement.className = "correct";\n' +
    '  } else {\n' +
    '    solutionMessageElement.innerHTML = "The answer <b>IS NOT</b> correct.";\n' +
    '    solutionMessageElement.className = "incorrect";\n' +
    '  }\n' +
    '};\n' +
    'window.correctAll = function() {\n' +
    '  const correctors = document.querySelectorAll("[data-corrector-button]");\n' +
    '  for(let index=0; index < correctors.length; index++) {\n' +
    '    const corrector = correctors[index];\n' +
    '    window.correctQuestion(corrector);\n' +
    '  }\n' +
    '  const solutions = document.querySelectorAll("[data-solution-message]");\n' + 
    '  let failed = 0, right = 0;\n' + 
    '  for(let index=0; index < solutions.length; index++) {\n' + 
    '    const solution = solutions[index];\n' + 
    '    solution.className === "incorrect" ? failed++ : "";\n' + 
    '    solution.className === "correct" ? right++ : "";\n' + 
    '  }\n' + 
    '  const conclusions = document.querySelectorAll("[data-solutions-conclusion]");\n' + 
    '  for(let index=0; index < conclusions.length; index++) {\n' + 
    '    const conclusion = conclusions[index];\n' + 
    '    conclusion.innerHTML = "<div>\\n" +\n' + 
    '      "<div>Correct: " + right + "</div>\\n" + ' + 
    '      "<div>Incorrect: " + failed + "</div>\\n" + ' + 
    '      "</div>";' + 
    '  };\n' +
    '};\n' +
    '</script>';
    form += '<style>\n' +
    '.correct {\n' +
    '  color: green;\n' +
    '}\n' +
    '.incorrect {\n' +
    '  color: red;\n' +
    '}\n' +
    '</style>\n';
    form += '<button onclick="window.correctAll()">Finished</button>\n';
    form += '<div data-solutions-conclusion></div>\n';
    return wrapInPage(form);
  };
}
Language = (Space / EOL)* defs:Definition* {return createForm(defs)}
Definition = word:Name EOL Tabulation def:Contents (EOL2 / EOF) {return {word, def}}
Name = [^\n:]+ ":" {return text().substr(0,text().length-1)}
EOL = "\r\n" / "\n"
EOL2 = EOL Space* EOL
Space = (" " / "\t")+
Tabulation = ("\t" / (" "+))+
Contents = (!(EOL2/EOF).)+ {return text()}
EOF = !.