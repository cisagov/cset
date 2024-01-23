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
import { editor } from 'monaco-editor/esm/vs/editor/editor.api';

import { XmlFormatterFactory } from "../xml-formatter";
import { XmlFormattingOptionsFactory } from "../xml-formatting-options";

export function minifyXml(editor: editor.ICodeEditor, edit: editor.ISingleEditOperation): void {
    const xmlFormatter = XmlFormatterFactory.getXmlFormatter();
    const xmlFormattingOptions = XmlFormattingOptionsFactory.getXmlFormattingOptions({
        insertSpaces: true,
        tabSize: 2
    }, editor.getModel());

    const range = editor.getModel().getFullModelRange();//lgtm [js/unused-local-variable]

    edit.text = xmlFormatter.minifyXml(editor.getModel().getValue(), xmlFormattingOptions);
}
