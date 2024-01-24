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
export class AdminSaveData {
    component: string;
    reviewType: string;
    hours: number;
    otherSpecifyValue: string;
}

export class AdminSaveResponse {
    documentationTotal: number;
    interviewTotal: number;
    grandTotal: number;
}

export class AttributePair {
    attributeName: string;
    attributeValue: string;
}

// this is the only class in this file that isn't copied from the back end
export class AdminTableData {
    assessmentId: number;
    statementsReviewed: number;
    component: string;
    reviewType: string;
    documentationHours: number;
    interviewHours: number;
    presentationOrder: number;
    hasSpecifyField: boolean;
    otherSpecifyValue: string;
}


export class AdminPageData {
    detailData: HoursOverride[];
    reviewTotals: ReviewTotal[];
    grandTotal: number;
    constructor() {
        this.detailData = [];
        this.reviewTotals = [];
    }
    attributes: AttributePair[];
}

export class HoursOverride {
    data: StatementReviewed;
    statementsReviewed: number;
}

export class ReviewTotal {
    reviewType: string;
    total: number;
}

export class StatementReviewed {
    assessment_Id: number;
    component: string;
    reviewType: string;
    hours: number;
    reviewedCountOverride: number;
    otherSpecifyValue: string;
    domainId: number;
    presentationOrder: number;
    acount: number; // typo copied from back-end
    percentComplete: number;
}