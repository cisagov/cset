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
import { XmlFormattingEditProvider } from "../xml-formatting-edit-provider";


export function formatAsXml(editor: editor.ICodeEditor, edit: editor.ISingleEditOperation): void {
    const xmlFormattingEditProvider = new XmlFormattingEditProvider(XmlFormatterFactory.getXmlFormatter());
    const formattingOptions = {
        insertSpaces: true,
        tabSize: 2
    };

    let edits;
    if (!editor.getSelection().isEmpty) {
        const selection = editor.getSelection();
        edits = xmlFormattingEditProvider.provideDocumentRangeFormattingEdits(
            editor.getModel(),
            new monaco.Range(selection.selectionStartLineNumber,
                selection.selectionStartColumn,
                selection.endLineNumber,
                selection.endColumn),
            formattingOptions,
            null);
    } else {
        edits = xmlFormattingEditProvider.provideDocumentFormattingEdits(
            editor.getModel(),
            formattingOptions,
            null);
    }
    editor.executeEdits(editor.getModel().getValue(), edits);
}
