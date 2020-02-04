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
export class AdminSaveData {
    Component: string;
    ReviewType: string;
    Hours: number;
    OtherSpecifyValue: string;
}

export class AdminSaveResponse {
    DocumentationTotal: number;
    InterviewTotal: number;
    GrandTotal: number;
}

export class AttributePair {
    AttributeName: string;
    AttributeValue: string;
}

// this is the only class in this file that isn't copied from the back end
export class AdminTableData {
    AssessmentId: number;
    StatementsReviewed: number;
    Component: string;
    ReviewType: string;
    DocumentationHours: number;
    InterviewHours: number;
    PresentationOrder: number;
    HasSpecifyField: boolean;
    OtherSpecifyValue: string;
}


export class AdminPageData {
    DetailData: HoursOverride[];
    ReviewTotals: ReviewTotal[];
    GrandTotal: number; 
    constructor() {
        this.DetailData = [];
        this.ReviewTotals = [];
    }
    Attributes: AttributePair[];
}

export class HoursOverride {
    Data: StatementReviewed;
    StatementsReviewed: number;
}

export class ReviewTotal {
    ReviewType: string;
    Total: number;
}

export class StatementReviewed {
    Assessment_Id: number;
    Component: string;
    ReviewType: string;
    Hours: number;
    ReviewedCountOverride: number;
    OtherSpecifyValue: string;
    DomainId: number;
    PresentationOrder: number;
    acount: number; // typo copied from back-end
    PercentComplete: number;
}