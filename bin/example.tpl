import * as React from 'react';
import {catchRenderErrors} from 'Business/Utils/catchRenderErrors';
import {Input, MaskedDatePicker, MaskedInput, Row} from 'Components';
import {IMixedProps} from 'Core/DependencyContainer';
import {<%= interfaceName %>} from '../../CreditFinancingModels';

const i18nModel = 'CreditFinancing:Components.<%= interfaceName.slice(3) %>';
const dataTestId = 'cf__<%= interfaceName.slice(3).toLowerCase() %>';
const rowClassName = 'col-xs-6';

/**
 * Свойства компонента
 *
 * @prop {Function} onChange Событие изменения формы.
 * @prop {<%= interfaceName %>} value <%= description %>
 */
interface IProps extends IMixedProps {
    onChange: (value: <%= interfaceName %>) => void;
    value: <%= interfaceName %>;
}

<% tags.forEach(function(tag) { %><% if (!tag.isEnum) return %>
/**
 * Получение опций для поля: <%= tag.description.toLowerCase() %>
 *
 * @param {I18nextStatic} i18n Интернационализация.
 */
const get<%= tag.capitalizedName %>Options = (i18n: I18nextStatic): ISelectOption<<%= tag.type %>>[] =>
    Object.keys(<%= tag.type %>).map(KEY => ({
        label: i18n.t(`${i18nModel}.<%= tag.name %>.select.${KEY}`),
        value: <%= tag.type %>[KEY]
    }));
<% }); %>

/**
 * <%= description %> Форма редактирования данных.
 */
export class <%= interfaceName.slice(1) %>Form extends React.Component<IProps, {}>
{
    /**
     * Обработчик изменения формы.
     *
     * @param {Partial<<%= interfaceName %>>} partial Данные паспорта.
     */
    updateForm = (partial: Partial<<%= interfaceName %>>) => {
        this.props.onChange({ ...this.props.value, ...partial });
    }

    <% tags.forEach(function(tag) { -%>
    <% if (tag.isArray) { %>
    /**
     * Обработчик добавления элемента в список поля: <%= tag.description.toLowerCase() %>
     *
     * @param {<%= tag.type %>} <%= tag.name %> <%= tag.description %>
     */
    handle<%= tag.capitalizedName %>Create = (<%= tag.name %>: <%= tag.type %>) => {
        this.updateForm({<%= tag.name %>: [...this.props.value.<%= tag.name %>, <%= tag.name %>]});
    };

    /**
     * Обработчик удаления элемента из списка поля: <%= tag.description.toLowerCase() %>
     *
     * @param {number} index Индекс удаляемого элемента.
     */
    handle<%= tag.capitalizedName %>Remove = (index: number) => {
        const <%= tag.name %> = this.props.value.<%= tag.name %>.splice(index, 1);
        this.updateForm({<%= tag.name %>});
    };
    <% } else { %>
    /**
     * Обработчик изменения поля: <%= tag.description.toLowerCase() %>
     *
     * @param {<%= tag.type === 'number' ? 'string' : tag.type %>} <%= tag.name %> <%= tag.description %>
     */
    handle<%= tag.capitalizedName %>Change = (<%= tag.name %>: <%= tag.type === 'number' ? 'string' : tag.type %>) => {
        <% if (tag.type === 'number') { %>
        this.updateForm({<%= tag.type === 'number' ? tag.name +': +'+ tag.name : tag.name %>})
        <%} else { %>
        this.updateForm({<%= tag.name %>});
        <% } %>
    };
    <% }}); -%>

    @catchRenderErrors()
    render() {
        const {i18n, value: {
            <%= tags.map(tag => tag.name).join(',\n\t\t\t') %>
        }} = this.props;

        return (
            <div className="row margin-left-0">
                <% tags.forEach(function(tag) { -%>
                <% if (tag.type.indexOf('E') === 0) { %>
                <Row label={i18n.t(`${i18nModel}.<%= tag.name %>.label`)} classNameElement={rowClassName}>
                    <SelectCustom
                        options={get<%= tag.capitalizedName %>Options(i18n)}
                        optionValue="value"
                        optionLabel="label"
                        placeholder={i18n.t(`${i18nModel}.<%= tag.name %>.placeholder`)}
                        value={<%= tag.name %>}
                        onChange={this.handle<%= tag.capitalizedName %>Change}
                        dataTestId={`${dataTestId}-<%= tag.name %>`}
                    />
                </Row>
                <% } else if(tag.type === 'boolean') { %>
                <Row classNameElement={rowClassName}>
                    <CheckBoxWrap
                        value={form.<%= tag.name %>}
                        onChange={this.handle<%= tag.capitalizedName %>Change}>
                        <span>{i18n.t(`${i18nModel}.<%= tag.name %>.label`)}</span>
                    </CheckBoxWrap>
                </Row>
                <% } else if(tag.isArray) { %>
                <% } else { %>
                <Input
                    classNameElement={rowClassName}
                    label={i18n.t(`${i18nModel}.<%= tag.name %>.label`)}
                    placeholder={i18n.t(`${i18nModel}.<%= tag.name %>.placeholder`)}
                    value={<%= tag.name %>}
                    onChange={this.handle<%= tag.capitalizedName %>Change}
                    dataTestId={`${dataTestId}-<%= tag.name %>`}
                    <%= tag.type === 'number' ? 'allowedSymbols="\d*"' : '' %>
                />
                <% }}); %>
            </div>
        );
    }
}
