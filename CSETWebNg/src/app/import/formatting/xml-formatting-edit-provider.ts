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
import { XmlFormatter } from "./xml-formatter";
import { XmlFormattingOptionsFactory } from "./xml-formatting-options";
import { editor, languages, Range, CancellationToken } from 'monaco-editor/esm/vs/editor/editor.api';

export class XmlFormattingEditProvider implements
  languages.DocumentFormattingEditProvider,
  languages.DocumentRangeFormattingEditProvider {

  provideDocumentRangeFormattingEdits(
    model: editor.ITextModel,
    range: Range,
    options: languages.FormattingOptions,
    token: CancellationToken
  ): languages.TextEdit[]
    | PromiseLike<languages.TextEdit[]> {
    let xml = model.getValueInRange(range);

    xml = this.xmlFormatter.formatXml(xml, XmlFormattingOptionsFactory.getXmlFormattingOptions(options, model));

    return [{ range: range, text: xml }];
  }
  provideDocumentFormattingEdits(model: editor.ITextModel,
    options: languages.FormattingOptions, token: CancellationToken
  ): languages.TextEdit[] | PromiseLike<languages.TextEdit[]> {
    const documentRange = model.getFullModelRange();
    return this.provideDocumentRangeFormattingEdits(model, documentRange, options, token);
  }
  constructor(
    public xmlFormatter: XmlFormatter
  ) { }

  // provideDocumentFormattingEdits(document: TextDocument,
  // options: FormattingOptions, token: CancellationToken): ProviderResult<TextEdit[]> {
  //     const lastLine = document.lineAt(document.lineCount - 1);
  //     const documentRange = new Range(document.positionAt(0), lastLine.range.end);

  //     return this.provideDocumentRangeFormattingEdits(document, documentRange, options, token);
  // }

  // provideDocumentRangeFormattingEdits(document: TextDocument, range: Range, options: FormattingOptions, token: CancellationToken):
  //  ProviderResult<TextEdit[]> {
  //     let xml = document.getText(range);

  //     xml = this.xmlFormatter.formatXml(xml, XmlFormattingOptionsFactory.getXmlFormattingOptions(options, document));

  //     return [ TextEdit.replace(range, xml) ];
  // }
}
