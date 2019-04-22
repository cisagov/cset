export class RequiredDocumentsResponse {
    headerList: RequiredDocumentHeader[];
}

export class RequiredDocumentHeader {
    Header: string;
    documents: RequiredDocument[];
}

export class RequiredDocument {
    DocId: number;
    Number: string;
    Document_Description: string;
    Answer: string;
    Comment: string;

    constructor(docId: number, answer: string, comment: string = null, number: string = null, desc: string = null) {
        this.DocId = docId;
        this.Answer = answer;
        this.Number = number;
        this.Document_Description = desc;
        this.Comment = comment;
    }
}