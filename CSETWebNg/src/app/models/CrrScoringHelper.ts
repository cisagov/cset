

export interface CrrScoringHelper {
    assessmentId: number;
    crrModelId: number;
    xDoc: string;
    xCsf: string;
    csfFunctionColors: { [key: string]: string; };
}
