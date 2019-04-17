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