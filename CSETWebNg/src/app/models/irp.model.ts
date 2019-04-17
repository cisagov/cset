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

    constructor(id: number, response: number, comment: string) {
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