#!/usr/bin/env node

const chalk = require('chalk')
const doctrine = require('doctrine')
const fs = require('fs')
const ejs = require('ejs')
const options = require('minimist')(process.argv.slice(2))

try {
    const interfaceName = options['interface']

    if (interfaceName === undefined) {
        throw new Error('Specify an interface name')
    }

    const fileName = options['file']
    const filePath = `./${fileName}`

    if (fileName === undefined) {
        throw new Error('Specify the model file')
    }

    if (!fs.existsSync(filePath)) {
        throw Error(`File ${fileName} not found`)
    }

    const model = fs.readFileSync(filePath, 'utf8').split('\n')
    const line = model.findIndex(line => line.indexOf(`export interface ${interfaceName} {`) === 0)

    if (line === -1) {
        throw Error(`Interface ${interfaceName} not found`)
    }
    
    const lines = [];
    let index = line - 1;

    while (index) {
        lines.unshift(model[index])

        if (model[index].indexOf('/**') >= 0) {
            break;
        }
        
        index -= 1;
    }

    const jsdoc = lines.join('\n');
    const data = doctrine.parse(jsdoc, {unwrap: true})
    
    if (data.tags.length === 0) {
        throw Error(`Interface ${interfaceName} has no props`)
    }
    
    function getType(tag) {
        if (tag.type.type === 'TypeApplication' && tag.type.expression.name === 'Array') {
            return { type: tag.type.applications[0].name, isArray: true }
        }

        return { type: tag.type.name, isArray: false }
    }
    
    const tags = data.tags.map(tag => {
        const { type, isArray } = getType(tag)
        return {
            name: tag.name,
            capitalizedName: tag.name.charAt(0).toUpperCase() + tag.name.slice(1),
            description: tag.description,
            type,
            isArray,
            isEnum: type.indexOf('E') === 0
        }
    })

    const templatePath = options['template'] || __dirname + '/bin/example.tpl'
    const template = fs.readFileSync(templatePath, 'utf8')
    const content = ejs.render(template, { ...data, tags, interfaceName })
    
    const ouputFilePath = `./${interfaceName.slice(1)}Form.tsx`
    
    fs.writeFileSync(ouputFilePath, content)

    let i18n = tags.reduce((acc, tag) => {
        acc += `
            "${tag.name}": {
                "label": "${tag.description.slice(0, -1)}",
                "placeholder": "${tag.isEnum ? 'Укажите' : 'Введите'} ${tag.description.slice(0, -1).toLowerCase()}"
            },
        `
        return acc
    }, '')

    console.log(chalk`{green {bold Completed.} File} {gray ${ouputFilePath}} {green created}`)
    console.log(chalk`{blue
        "${interfaceName.slice(3)}Form": \{
        ${i18n}
        \}
    }`)
} catch (e) {
    console.log(chalk`{redBright ♻ ${e.message}.} {gray Type --help to get help.}`)
}