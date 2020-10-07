////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
export class IRPResponse {
    headerList: IRPHeader[];
}

export class IRPHeader {
    header: string;
    irpList: IRP[];
}

export class IRP {
    IRP_Id: number;
    Item_Number: number;
    Description: string;
    Risk_1_Description: string;
    Risk_2_Description: string;
    Risk_3_Description: string;
    Risk_4_Description: string;
    Risk_5_Description: string;
    Validation_Approach: string;
    Response: number;
    Comment: string;

    constructor(id: number, response: number, comment: 
        string) {
        this.IRP_Id = id;
        this.Response = response;
        this.Comment = comment;
    }
}

export class IRPSummary {
    HeaderText: string;
    RiskCount: number[];
    RiskSum: number;
    RiskLevel: number;
    Comment: string;
}