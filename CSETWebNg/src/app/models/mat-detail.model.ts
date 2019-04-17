export class MatDetailResponse {
    domains: MaturityDomain[];

    constructor() {
        this.domains = [];
    }
}

export class MaturityDomain {
    DomainName: string;
    DomainMaturity: string;
    Assessments: MaturityAssessment[];
    Sequence: number;

    constructor() {
        this.Assessments = [];
    }
}

export class MaturityAssessment {
    AssessmentFactor: string;
    AssessmentFactorMaturity: string; 
    Components: MaturityComponent[];
    Sequence: number;

    constructor() {
        this.Components = [];
    }
}

export class MaturityComponent {
    ComponentName: string;
    Incomplete: boolean;
    AssessedMaturityLevel: string;
    Sequence: number;

    Baseline: number;
    Intermediate: number;
    Advanced: number;
    Innovative: number;
}