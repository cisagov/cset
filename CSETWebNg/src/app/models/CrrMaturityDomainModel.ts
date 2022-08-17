import { CrrMaturityLevelStats } from "./CrrMaturityLevelStats";

export interface CrrMaturityDomainModel {
    domainName: string;
    acheivedLevel: number;
    domainScore: number;
    widthValpx: number;
    statsByLevel: CrrMaturityLevelStats[];
}
