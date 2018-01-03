**JSDoc2Component** is a CLI tool that parses JSDoc file and generates ouput file based on a [EJS](http://ejs.co/) template file.

Very often we have to write routine code. It begins with JSDoc annotations:
```js
/**
 * Some description of the model.
 *
 * @prop {string} firstName First name.
 * @prop {string} lastName Last name.
 * ... +10 more props
 */
export interface IUser {
    firstName: string;
    lastName: string;
    // ... +10 more props
}
```
After we described a model we need to write a component for the model:
```js
import * as React from 'react';
...

/**
 * Some prop interface
 *
 * @prop {Function} onChange Event to change the IUser data.
 * @prop {IUser} value User.
 */
interface IProps {
    onChange: (data: IUser) => void;
    value: IUser;
}

/**
 * Some description of the component
 */
export class UserForm extends React.Component<IProps, {}>
{
    /**
     * Handle firstName change
     *
     * @param {string} firstName First name
     */
    handleFirstNameChange = (firstName: string) => {
        this.updateForm({firstName})
    }
    
    /**
     * Handle lastName change
     *
     * @param {string} lastName First name
     */
    handleFirstNameChange = (lastName: string) => {
        this.updateForm({lastName})
    }
    
    // ... +10 more handlers
    
    render() {
        const {value: {
            firstName,
            lastName,
            // ... +10 more props
        }} = this.props;
        
        return (
            <form onSubmit={this.handleSubmit}>
                <label>
                    First name:
                    <input type="text" value={firstName} onChange={this.handleFirstNameChange} />
                </label>
                <label>
                    Last name:
                    <input type="text" value={lastName} onChange={this.handleLastNameChange} />
                </label>
                // ... +10 more fields
                <input type="submit" value="Submit" />
            </form>
        );
    }
}

```
And if you use i18n you need to write something like this:
```json
"PersonalForm": {
    "firstName": {
        "label": "First name",
        "placeholder": "Enter your first name please"
    },
    "lastName": {
        "label": "Last name",
        "placeholder": "Enter your last name please"
    }
    
    ... +10 more fields
    
}
```

JSDoc2Component helps you to generate component, json file or anything other file type based on JSDoc annotation and EJS template file. All you need is write an EJS template file and specify the name of an interface name in the JSDoc file.

### Installation

JSDoc2Component requires [Node.js](https://nodejs.org/) v4+ to run.
```sh
$ npm install jsdoc2component -g
```

#### How to use
CLI Usage:
```sh
$ jsdoc2component --file-name fileWithJSDoc.js --interface-name IUser
```

Options:
| Option | Description |
| ----------- | ----------- |
| --jsdoc-file | path to the JSDoc model file |
| --interface | name of the interface to use | 
| --template | path to the template (ejs) file | 
