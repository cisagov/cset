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
import { XmlFormatter } from "../xml-formatter";
import { XmlFormattingOptions } from "../xml-formatting-options";

const MagicalStringOfWonders = "~::~MAAAGIC~::~";

export class V2XmlFormatter implements XmlFormatter {
    formatXml(xml: string, options: XmlFormattingOptions): string {
        // this replaces all "<" brackets inside of comments to a magical string
        // so the following minification steps don't mess with comment formatting
        xml = this._sanitizeComments(xml);

        // remove whitespace from between tags, except for line breaks
        xml = xml.replace(/>\s{0,}</g, (match: string) => {
            return match.replace(/[^\S\r\n]/g, "");
        });

        // do some light minification to get rid of insignificant whitespace
        xml = xml.replace(/"\s+(?=[^\s]+=)/g, "\" "); // spaces between attributes
        xml = xml.replace(/"\s+(?=>)/g, "\""); // spaces between the last attribute and tag close (>)
        xml = xml.replace(/"\s+(?=\/>)/g, "\" "); // spaces between the last attribute and tag close (/>)
        xml = xml.replace(/[^ <>="]\s+[^ <>="]+=/g, (match: string) => { // spaces between the node name and the first attribute
            return match.replace(/\s+/g, " ");
        });

        // the coast is clear - we can drop those "<" brackets back in
        xml = this._unsanitizeComments(xml);

        let output = "";

        let indentLevel = 0;
        let attributeQuote = "";
        let lineBreakSpree = false;
        let lastWordCharacter: string | undefined;
        let inMixedContent = false;

        const locationHistory: Location[] = [Location.Text];

        function isLastNonTextLocation(loc: Location): boolean {
            for (let i = (locationHistory.length - 1); i >= 0; i--) {
                if (locationHistory[i] !== Location.Text) {
                    return (loc === locationHistory[i]);
                }
            }

            return false;
        }

        function isLocation(loc: Location): boolean {
            return loc === locationHistory[locationHistory.length - 1];
        }

        function refreshMixedContentFlag(): void {
            inMixedContent =
                (isLastNonTextLocation(Location.StartTag)
                    || isLastNonTextLocation(Location.EndTag))
                && lastWordCharacter !== undefined;
        }

        function setLocation(loc: Location): void {
            if (loc === Location.Text) {
                lastWordCharacter = undefined;
            }

            locationHistory.push(loc);
        }

        // NOTE: all "exiting" checks should appear after their associated "entering" checks
        for (let i = 0; i < xml.length; i++) {
            const cc = xml[i];
            const nc = xml.charAt(i + 1);
            const nnc = xml.charAt(i + 2);
            const pc = xml.charAt(i - 1);
            const ppc = xml.charAt(i - 2);

            // entering CData
            if (isLocation(Location.Text) && cc === "<" && nc === "!" && nnc === "[") {
                if (pc === ">" && ppc !== "/") {
                    output += "<";
                } else {
                    output += `${this._getIndent(options, indentLevel)}<`;
                }

                setLocation(Location.CData);
            } else if (isLocation(Location.CData) && cc === "]" && nc === "]" && nnc === ">") {
                output += "]]>";

                i += 2;

                setLocation(Location.Text);
            } else if (isLocation(Location.Text) && cc === "<" && nc === "!" && nnc === "-") {
                output += `${this._getIndent(options, indentLevel)}<`;

                setLocation(Location.Comment);
            } else if (isLocation(Location.Comment) && cc === "-" && nc === "-" && nnc === ">") {
                output += "-->";

                i += 2;

                setLocation(Location.Text);
            } else if (isLocation(Location.Text) && cc === "<" && (nc === "!" || nc === "?")) {
                output += `${this._getIndent(options, indentLevel)}<`;

                setLocation(Location.SpecialTag);
            } else if (isLocation(Location.SpecialTag) && cc === ">") {
                output += `>`;

                setLocation(Location.Text);
            } else if (isLocation(Location.Text) && cc === "<" && ["/", "!"].indexOf(nc) === -1) {
                refreshMixedContentFlag();

                // if this occurs after another tag, prepend a line break
                // but do not add one if the previous tag was self-closing (it already adds its own)
                if (pc === ">" && ppc !== "/" && !inMixedContent) {
                    output += `${options.newLine}${this._getIndent(options, indentLevel)}<`;
                } else if (!inMixedContent) {
                    // removing trailing non-breaking whitespace here prevents endless indentations (issue #193)
                    output = this._removeTrailingNonBreakingWhitespace(output);
                    output += `${this._getIndent(options, indentLevel)}<`;
                } else {
                    output += "<";

                    indentLevel--;
                }

                indentLevel++;

                setLocation(Location.StartTagName);
            } else if (isLocation(Location.StartTagName) && cc === " ") {
                output += " ";

                setLocation(Location.StartTag);
            } else if (isLocation(Location.StartTag) && [" ", "/", ">"].indexOf(cc) === -1) {
                if (locationHistory[locationHistory.length - 2] === Location.AttributeValue
                    && ((options.splitXmlnsOnFormat
                        && xml.substr(i, 5).toLowerCase() === "xmlns")
                        || options.splitAttributesOnFormat)) {
                    output += `${options.newLine}${this._getIndent(options, indentLevel)}`;
                }

                output += cc;

                setLocation(Location.Attribute);
            } else if (isLocation(Location.Attribute) && (cc === "\"" || cc === "'")) {
                output += cc;

                setLocation(Location.AttributeValue);

                attributeQuote = cc;
            } else if (isLocation(Location.AttributeValue) && cc === attributeQuote) {
                output += cc;

                setLocation(Location.StartTag);

                attributeQuote = undefined;
            } else if ((isLocation(Location.StartTag) || isLocation(Location.StartTagName))
                && cc === "/"
                && pc !== " "
                && options.enforcePrettySelfClosingTagOnFormat) {
                output += " /";
            } else if ((isLocation(Location.StartTag) || isLocation(Location.StartTagName)) && cc === ">") {
                // if this was a self-closing tag, we need to decrement the indent level and add a newLine
                if (pc === "/") {
                    indentLevel--;
                    output += ">";

                    // only add a newline here if one doesn't already exist (issue #147)
                    if (nc !== "\r" && nc !== "\n") {
                        output += options.newLine;
                    }
                } else {
                    output += ">";
                }

                // don't go directly from StartTagName to Text; go through StartTag first
                if (isLocation(Location.StartTagName)) {
                    setLocation(Location.StartTag);
                }

                setLocation(Location.Text);
            } else if (isLocation(Location.Text) && cc === "<" && nc === "/") {
                indentLevel--;

                refreshMixedContentFlag();

                // if the end tag immediately follows a line break, just add an indentation
                // if the end tag immediately follows another end tag or a self-closing tag (issue #185), add a line break and indent
                // otherwise, this should be treated as a same-line end tag(ex. <element>text</element>)
                if ((pc === "\n" || lineBreakSpree) && !inMixedContent) {
                    // removing trailing non-breaking whitespace here prevents endless indentations (issue #193)
                    output = this._removeTrailingNonBreakingWhitespace(output);
                    output += `${this._getIndent(options, indentLevel)}<`;
                    lineBreakSpree = false;
                } else if (isLastNonTextLocation(Location.EndTag) && !inMixedContent) {
                    output += `${options.newLine}${this._getIndent(options, indentLevel)}<`;
                } else if (pc === ">" && ppc === "/" && !inMixedContent) {
                    output += `${this._getIndent(options, indentLevel)}<`;
                } else {
                    output += "<";
                }

                setLocation(Location.EndTag);
            } else if (isLocation(Location.EndTag) && cc === ">") {
                output += ">";

                setLocation(Location.Text);

                inMixedContent = false;
            } else {
                if (cc === "\n") {
                    lineBreakSpree = true;
                    lastWordCharacter = undefined;
                } else if (lineBreakSpree && /\S/.test(cc)) {
                    lineBreakSpree = false;
                }

                if (/[\w\d]/.test(cc)) {
                    lastWordCharacter = cc;
                }

                output += cc;
            }
        }

        return output;
    }
    private _stripLineBreaks(options: XmlFormattingOptions, xml: string): string {
        let output = "";
        let inCdata = false;

        for (let i = 0; i < xml.length; i++) {
            const char: string = xml.charAt(i);
            const prev: string = xml.charAt(i - 1);
            const next: string = xml.charAt(i + 1);

            if (char === "!" && (xml.substr(i, 8) === "![CDATA[" || xml.substr(i, 3) === "!--")) {
                inCdata = true;
            } else if (char === "]" && (xml.substr(i, 3) === "]]>")) {
                inCdata = false;
            } else if (char === "-" && (xml.substr(i, 3) === "-->")) {
                inCdata = false;
            } else if (char.search(/[\r\n]/g) > -1 && !inCdata) {
                if (/\r/.test(char) && /\S|\r|\n/.test(prev) && /\S|\r|\n/.test(xml.charAt(i + options.newLine.length))) {
                    output += char;
                } else if (/\n/.test(char) && /\S|\r|\n/.test(xml.charAt(i - options.newLine.length)) && /\S|\r|\n/.test(next)) {
                    output += char;
                }

                continue;
            }

            output += char;
        }

        return output;
    }

    minifyXml(xml: string, options: XmlFormattingOptions): string {
        xml = this._stripLineBreaks(options, xml); // all line breaks outside of CDATA elements
        xml = (options.removeCommentsOnMinify) ? xml.replace(/\<![ \r\n\t]*(--([^\-]|[\r\n]|-[^\-])*--[ \r\n\t]*)\>/g, "") : xml;
        xml = xml.replace(/>\s{0,}</g, "><"); // insignificant whitespace between tags
        xml = xml.replace(/"\s+(?=[^\s]+=)/g, "\" "); // spaces between attributes
        xml = xml.replace(/"\s+(?=>)/g, "\""); // spaces between the last attribute and tag close (>)
        xml = xml.replace(/"\s+(?=\/>)/g, "\" "); // spaces between the last attribute and tag close (/>)
        xml = xml.replace(/[^ <>="]\s+[^ <>="]+=/g, (match: string) => { // spaces between the node name and the first attribute
            return match.replace(/\s+/g, " ");
        });

        return xml;
    }

    private _getIndent(options: XmlFormattingOptions, indentLevel: number): string {
        return ((options.editorOptions.insertSpaces) ? " ".repeat(options.editorOptions.tabSize) : "\t").repeat(indentLevel);
    }

    private _removeTrailingNonBreakingWhitespace(text: string): string {
        return text.replace(/[^\r\n\S]+$/, "");
    }

    private _sanitizeComments(xml: string): string {
        let output = "";
        let inComment = false;

        for (let i = 0; i < xml.length; i++) {
            const cc = xml[i];
            const nc = xml.charAt(i + 1);
            const nnc = xml.charAt(i + 2);
            const pc = xml.charAt(i - 1);//lgtm [js/unused-local-variable]

            if (!inComment && cc === "<" && nc === "!" && nnc === "-") {
                inComment = true;
                output += "<!--";

                i += 3;
            } else if (inComment && cc === "<") {
                output += MagicalStringOfWonders;
            } else if (inComment && cc === "-" && nc === "-" && nnc === ">") {
                inComment = false;
                output += "-->";

                i += 2;
            } else {
                output += cc;
            }
        }

        return output;
    }

    private _unsanitizeComments(xml: string): string {
        return xml.replace(new RegExp(MagicalStringOfWonders, "g"), "<");
    }
}

enum Location {
    Attribute,
    AttributeValue,
    CData,
    Comment,
    EndTag,
    SpecialTag,
    StartTag,
    StartTagName,
    Text
}
