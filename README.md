**JSDoc2Component** is a CLI tool that parses JSDoc annotation and generates ouput file based on [EJS](http://ejs.co/) template file.

Imagine you have an interface described with JSDoc annotation:
```typescript
/**
 * User.
 *
 * @prop {string} firstname First name.
 */
export interface IUser {
    firstname: string;
}
```
Now we need to build a component with form in it based on the interface above (common use case):

```javascript
import * as React from 'react';

// ... more imports, handlers, variables and so on...

/**
 * Props interface
 *
 * @prop {Function} onChange Event to change the IUser data.
 * @prop {IUser} value User.
 */
interface IProps {
    onChange: (data: IUser) => void;
    value: IUser;
}

/**
 * User profile form.
 */
export class UserForm extends React.Component<IProps, {}>
{
    /**
     * Handle first name change.
     *
     * @param {string} firstname First name
     */
    handleFirstnameChange = (firstname: string) => {
        // Some code to handle first name change...
    }
    
    /**
     * Handle form submit event.
     *
     * @param {React.SyntheticEvent} event Event object
     */
    handleSubmit = (event: React.SyntheticEvent) => {
        // Some code to handle form submit...
    }
    
    render() {
        const {value: {firstname}} = this.props;
        
        return (
            <form onSubmit={this.handleSubmit}>
                <label>
                    First name:
                    <input type="text" value={firstname} onChange={this.handleFirstnameChange} />
                </label>
                <input type="submit" value="Submit" />
            </form>
        );
    }
}
```
This example demonstrates that if you even have only one prop in your interface you need to write about 50 lines of *routine* code to create a form component based on the interface. The example is very simple but in real life we have tonns of interfaces with 10 or more props. So every time you need to create another component you copy existed file and change variable names, handlers and so on. It's routine, it's boring and it takes time.
With **JSDoc2Component** we can escape all this routine work. All you need is write an EJS template file like this:

```twig
import * as React from 'react';

// ... more imports, handlers, variables and so on...

/**
 * Props interface
 *
 * @prop {Function} onChange Event to change the IUser data.
 * @prop {IUser} value User.
 */
interface IProps {
    onChange: (data: IUser) => void;
    value: IUser;
}

/**
 * <%- description %>
 */
export class UserForm extends React.Component<IProps, {}>
{
    <% tags.forEach(tag => ( %>
        /**
         * Handle <%- tag.name %> change.
         *
         * @param {<%- tag.type %>} <%- tag.name %> <%- tag.description %>
         */
        handle<%- tag.capitalizedName %>Change = (<%- tag.name %>: <%- tag.type %>) => {
            // Some routine code to handle first name change...
        }
    <% )) %>
    
    /**
     * Handle form submit event.
     *
     * @param {React.SyntheticEvent} event Event object
     */
    handleSubmit = (event: React.SyntheticEvent) => {
        // Some code to handle form submit...
    }
    
    render() {
        const {value: {firstname}} = this.props;
        
        return (
            <form onSubmit={this.handleSubmit}>
                <% tags.forEach(tag => ( %>
                    <label>
                        <%- tag.description %>:
                        <input type="text" value={<%- tag.name %>} onChange={this.handle<%- tag.capitalizedName %>Change} />
                    </label>
                    <input type="submit" value="Submit" />
                <% )) %>
            </form>
        );
    }
}
```
Now every time you need a component you just run **JSDoc2Component**:
```sh
$ jsdoc2component --file jsdocfile.ts --interface IUser --destination UserComponent.tsx
```
And you get ready to use component... just like that. Specify any correct interface name in your modelWithJSDoc.ts file and get ready to use component.

## Options:
| Option | Description |
| --- | --- |
| --file | path to the file with JSDoc models |
| --interface | name of the interface to parse | 
| --destination | ouput file name | 
| --i18n | ouputs json i18n object | 
