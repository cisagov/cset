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
import { editor, languages } from 'monaco-editor/esm/vs/editor/editor.api';
import { MAT_CHECKBOX_CONTROL_VALUE_ACCESSOR } from "@angular/material/checkbox";

export interface XmlFormattingOptions {
    editorOptions: languages.FormattingOptions;
    enforcePrettySelfClosingTagOnFormat: boolean;
    newLine: string;
    removeCommentsOnMinify: boolean;
    splitAttributesOnFormat: boolean;
    splitXmlnsOnFormat: boolean;
}

export class XmlFormattingOptionsFactory {
    static getXmlFormattingOptions(formattingOptions: languages.FormattingOptions, document: editor.ITextModel):
        XmlFormattingOptions {
        return {
            editorOptions: formattingOptions,
            enforcePrettySelfClosingTagOnFormat: true,
            newLine: (document.getEOL() === "\r\n") ? "\r\n" : "\n",
            removeCommentsOnMinify: false,
            splitAttributesOnFormat: true,
            splitXmlnsOnFormat: MAT_CHECKBOX_CONTROL_VALUE_ACCESSOR
        };
    }
}
