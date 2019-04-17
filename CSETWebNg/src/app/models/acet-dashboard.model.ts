import { IRPSummary } from './irp.model';

export class AcetDashboard {
    // Exam Preparation Section
    CreditUnionName: string;
    Charter: string;
    Assets: string;
    Hours: number;

    // IRP Secion
    IRPs: IRPSummary[];
    SumRisk: number[];
    SumRiskTotal: number;
    SumRiskLevel: number;
    Override: number;
    OverrideReason: string;

    // CyberSecurity Maturity Section
    Domains: DashboardDomain[];
}

export class DashboardDomain {
    Name: string;
    Maturity: string;
}
