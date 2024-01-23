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
export class IRPResponse {
    headerList: IRPHeader[];
}

export class IRPHeader {
    header: string;
    irpList: IRP[];
}

export class IRP {
    irP_Id: number;
    item_Number: number;
    description: string;
    risk_1_Description: string;
    risk_2_Description: string;
    risk_3_Description: string;
    risk_4_Description: string;
    risk_5_Description: string;
    validation_Approach: string;
    response: number;
    comment: string;
    risk_Type: string;

    constructor(id: number, response: number, comment:
        string) {
        this.irP_Id = id;
        this.response = response;
        this.comment = comment;
    }
}

export class IRPSummary {
    headerText: string;
    riskCount: number[];
    riskSum: number;
    riskLevel: number;
    comment: string;
}