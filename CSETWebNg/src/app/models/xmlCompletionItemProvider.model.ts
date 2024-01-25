////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { editor, languages, CancellationToken } from 'monaco-editor/esm/vs/editor/editor.api';


export class XmlCompletionItemProvider implements languages.CompletionItemProvider {
    constructor(monaco, schemaNodeString: string) {
        this.monaco = monaco;
        this.schemaNode = this.stringToXml(schemaNodeString);

    }
    private monaco: any;
    private schemaNode: any;
    public triggerCharacters: Array<string> = ['<'];
    private getLastOpenedTag(text) {
        // get all tags inside of the content
        const tags = text.match(/<\/*(?=\S*)([a-zA-Z-]+)/g);
        if (!tags) {
            return undefined;
        }
        // we need to know which tags are closed
        const closingTags = [];
        for (let i = tags.length - 1; i >= 0; i--) {
            if (tags[i].indexOf('</') === 0) {
                closingTags.push(tags[i].substring('</'.length));
            } else {
                // get the last position of the tag
                const tagPosition = text.lastIndexOf(tags[i]);
                const tag = tags[i].substring('<'.length);
                const closingBracketIdx = text.indexOf('/>', tagPosition);
                // if the tag wasn't closed
                if (closingBracketIdx === -1) {
                    // if there are no closing tags or the current tag wasn't closed
                    if (!closingTags.length || closingTags[closingTags.length - 1] !== tag) {
                        // we found our tag, but let's get the information if we are looking for
                        // a child element or an attribute
                        text = text.substring(tagPosition);
                        return {
                            tagName: tag,
                            isAttributeSearch: text.indexOf('<') > text.indexOf('>')
                        };
                    }
                    // remove the last closed tag
                    closingTags.splice(closingTags.length - 1, 1);
                }
                // remove the last checked tag and continue processing the rest of the content
                text = text.substring(0, tagPosition);
            }
        }
    }

    private getAreaInfo(text) {
        // opening for strings, comments and CDATA
        const items = ['"', '\'', '<!--', '<![CDATA['];
        let isCompletionAvailable = true;
        // remove all comments, strings and CDATA
        text = text.replace(/"([^"\\]*(\\.[^"\\]*)*)"|\'([^\'\\]*(\\.[^\'\\]*)*)\'|<!--([\s\S])*?-->|<!\[CDATA\[(.*?)\]\]>/g, '');
        for (let i = 0; i < items.length; i++) {
            const itemIdx = text.indexOf(items[i]);
            if (itemIdx > -1) {
                // we are inside one of unavailable areas, so we remote that area
                // from our clear text
                text = text.substring(0, itemIdx);
                // and the completion is not available
                isCompletionAvailable = false;
            }
        }
        return {
            isCompletionAvailable: isCompletionAvailable,
            clearedText: text
        };
    }

    private shouldSkipLevel(tagName: string) {
        // if we look at the XSD schema, these nodes are containers for elements,
        // so we can skip that level
        tagName = tagName.substr(tagName.indexOf(':') + 1);
        return tagName === 'complexType' || tagName === 'all' || tagName === 'sequence' || tagName === 'schema';
    }

    private findElements(elements, elementName) {
        for (let i = 0; i < elements.length; i++) {
            // we are looking for elements, so we don't need to process annotations and attributes
            if (elements[i].tagName !== 'annotation' && elements[i].tagName !== 'attribute') {
                // if it is one of the nodes that do not have the info we need, skip it
                // and process that node's child items
                if (this.shouldSkipLevel(elements[i].tagName)) {
                    const child = this.findElements(elements[i].children, elementName);
                    // if child exists, return it
                    if (child) {
                        return child;
                    }
                } else if (!elementName) {
                    return elements;
                } else if (this.getElementAttributes(elements[i]).name === elementName) {
                    return elements[i];
                }
            }
        }
    }

    private findAttributes(elements) {
        const attrs = [];
        for (let i = 0; i < elements.length; i++) {
            // skip level if it is a 'complexType' tag
            if (elements[i].tagName === 'complexType') {
                const child = this.findAttributes(elements[i].children);
                if (child) {
                    return child;
                }
            } else if (elements[i].tagName === 'attribute') {
                attrs.push(elements[i]);
            }
        }
        return attrs;
    }

    private getElementAttributes(element): any {
        const attrs = {};
        for (let i = 0; i < element.attributes.length; i++) {
            attrs[element.attributes[i].name] = element.attributes[i].value;
        }
        // return all attributes as an object
        return attrs;
    }

    private getItemDocumentation(element) {
        for (let i = 0; i < element.children.length; i++) {
            // annotaion contains documentation, so calculate the
            // documentation from it's child elements
            if (element.children[i].tagName === 'annotation') {
                return this.getItemDocumentation(element.children[0]);
            } else if (element.children[i].tagName === 'documentation') {
                return element.children[i].textContent;
            }
        }
    }

    private isItemAvailable(itemName, maxOccurs, items) {
        // the default for 'maxOccurs' is 1
        maxOccurs = maxOccurs || '1';
        // the element can appere infinite times, so it is availabel
        if (maxOccurs && maxOccurs === 'unbounded') {
            return true;
        }
        // count how many times the element appered
        let count = 0;
        for (let i = 0; i < items.length; i++) {
            if (items[i] === itemName) {
                count++;
            }
        }
        // if it didn't appear yet, or it can appear again, then it
        // is available, otherwise it't not
        return count === 0 || parseInt(maxOccurs, 10) > count;
    }

    private getAvailableElements(monaco, elements, usedItems) {
        const availableItems = [];
        let children;
        for (let i = 0; i < elements.length; i++) {
            // annotation element only contains documentation,
            // so no need to process it here
            if (elements[i].tagName !== 'annotation') {
                // get all child elements that have 'element' tag
                children = this.findElements([elements[i]], null);
            }
        }
        // if there are no such elements, then there are no suggestions
        if (!children) {
            return [];
        }
        for (let i = 0; i < children.length; i++) {
            // get all element attributes
            const elementAttrs = this.getElementAttributes(children[i]);
            // the element is a suggestion if it's available
            if (this.isItemAvailable(elementAttrs.name, elementAttrs.maxOccurs, usedItems)) {
                // mark it as a 'field', and get the documentation
                availableItems.push({
                    label: elementAttrs.name,
                    kind: languages.CompletionItemKind.Field,
                    detail: elementAttrs.type,
                    documentation: this.getItemDocumentation(children[i])
                });
            }
        }
        if (!availableItems) {

        }
        // return the suggestions we found
        return availableItems;
    }

    private getAvailableAttribute(monaco, elements, usedChildTags) {
        const availableItems = [];
        let children;
        for (let i = 0; i < elements.length; i++) {
            // annotation element only contains documentation,
            // so no need to process it here
            if (elements[i].tagName !== 'annotation') {
                // get all child elements that have 'attribute' tag
                children = this.findAttributes([elements[i]]);
            }
        }
        // if there are no attributes, then there are no
        // suggestions available
        if (!children) {
            return [];
        }
        for (let i = 0; i < children.length; i++) {
            // get all attributes for the element
            const attrs = this.getElementAttributes(children[i]);
            // accept it in a suggestion list only if it is available
            if (this.isItemAvailable(attrs.name, attrs.maxOccurs, usedChildTags)) {
                // mark it as a 'property', and get it's documentation
                availableItems.push({
                    label: attrs.name,
                    kind: languages.CompletionItemKind.Property,
                    detail: attrs.type,
                    documentation: this.getItemDocumentation(children[i])
                });
            }
        }
        // return the elements we found
        return availableItems;
    }
    public stringToXml(text: string) {
        let xmlDoc;
        const parser = new DOMParser();
        xmlDoc = parser.parseFromString(text, 'text/xml');
        return xmlDoc;
    }
    public provideCompletionItems(model: editor.ITextModel, position, context: languages.CompletionContext, token: CancellationToken)
        : any {
        //public provideCompletionItems(model, position) {
        // get editor content before the pointer
        const textUntilPosition = model.getValueInRange({
            startLineNumber: 1,
            startColumn: 1,
            endLineNumber: position.lineNumber,
            endColumn: position.column
        });
        // get content info - are we inside of the area where we don't want suggestions, what is the content without those areas
        const areaUntilPositionInfo = this.getAreaInfo(textUntilPosition); // isCompletionAvailable, clearedText
        // if we don't want any suggestions, return empty array
        if (!areaUntilPositionInfo.isCompletionAvailable) {
            return null;
        }
        // if we want suggestions, inside of which tag are we?
        const lastOpenedTag = this.getLastOpenedTag(areaUntilPositionInfo.clearedText);
        // get opened tags to see what tag we should look for in the XSD schema
        const openedTags = [];
        // get the elements/attributes that are already mentioned in the element we're in
        const usedItems = [];
        const isAttributeSearch = lastOpenedTag && lastOpenedTag.isAttributeSearch;
        // no need to calculate the position in the XSD schema if we are in the root element
        if (lastOpenedTag) {
            // parse the content (not cleared text) into an xml document
            const xmlDoc = this.stringToXml(textUntilPosition);
            let lastChild = xmlDoc.lastElementChild;
            while (lastChild) {
                openedTags.push(lastChild.tagName);
                // if we found our last opened tag
                if (lastChild.tagName === lastOpenedTag.tagName) {
                    // if we are looking for attributes, then used items should
                    // be the attributes we already used
                    if (lastOpenedTag.isAttributeSearch) {
                        const attrs = lastChild.attributes;
                        for (let i = 0; i < attrs.length; i++) {
                            usedItems.push(attrs[i].nodeName);
                        }
                    } else {
                        // if we are looking for child elements, then used items
                        // should be the elements that were already used
                        const children = lastChild.children;
                        for (let i = 0; i < children.length; i++) {
                            usedItems.push(children[i].tagName);
                        }
                    }
                    break;
                }
                // we haven't found the last opened tag yet, so we move to
                // the next element
                lastChild = lastChild.lastElementChild;
            }
        }
        // find the last opened tag in the schema to see what elements/attributes it can have
        let currentItem = this.schemaNode;
        for (let i = 0; i < openedTags.length; i++) {
            if (currentItem) {
                currentItem = this.findElements(currentItem.children, openedTags[i]);
            }
        }

        // return available elements/attributes if the tag exists in the schema, or an empty
        // array if it doesn't
        if (isAttributeSearch) {
            // get attributes completions
            return currentItem ? this.getAvailableAttribute(this.monaco, currentItem.children, usedItems) : [];
        } else {
            // get elements completions
            return currentItem ? this.getAvailableElements(this.monaco, currentItem.children, usedItems) : [];
        }
    }

}
