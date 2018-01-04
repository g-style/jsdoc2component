import * as React from 'react';

/**
 * Props interface
 *
 * @prop {Function} onChange Event to change the IUser data.
 * @prop {IUser} value User.
 */
interface IProps {
    onChange: (data: <%- interfaceName %>) => void;
    value: <%- interfaceName %>;
}

/**
 * <%- description %>
 */
export class UserForm extends React.Component<IProps, {}>
{
    <% props.forEach(prop => { %>
        /**
         * Handle <%- prop.name %> change.
         *
         * @param {<%- prop.type %>} <%- prop.name %> <%- prop.description %>
         */
        handle<%- prop.capitalizedName %>Change = (<%- prop.name %>: <%- prop.type %>) => {
            this.props.onChange({<%- prop.name %>})
        }
    <% }) %>
    
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
                <% props.forEach(prop => { %>
                    <label>
                        <%- prop.description %>:
                        <input type="text" value={<%- prop.name %>} onChange={this.handle<%- prop.capitalizedName %>Change} />
                    </label>
                <% }) %>
                <input type="submit" value="Submit" />
            </form>
        );
    }
}