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
import { User } from './user.model';

export interface AssessmentDetail {
    id?: number;
    assessmentName?: string;
    createdDate?: string;
    creatorId?: number;
    assessmentDate?: string;
    assessmentEffectiveDate?: string;
    baselineAssessmentId?: number;
    facilityName?: string;
    cityOrSiteName?: string;
    stateProvRegion?: string;
    postalCode?: string;
    executiveSummary?: string;
    assessmentDescription?: string;
    additionalNotesAndComments?: string;
    charter?: string;
    creditUnion?: string;
    assets?: string;

    // a few demographics to track
    sectorId?: number;
    industryId?: number;

    useStandard?: boolean;
    useMaturity?: boolean;
    useDiagram?: boolean;
    isE_StateLed?: boolean;
    regionCode?: number;
    charterType?: number;

    isAcetOnly?: boolean;
    workflow?: string;
    origin?: string;
    hiddenScreens?: string[];

    maturityModel?: MaturityModel;

    // A list of selected standards
    standards?: string[];

    applicationMode?: string;

    typeTitle?: string;
    typeDescription?: string;
    pciiNumber?: string;
    is_PCII?: boolean;
}

export interface MaturityModel {
    modelId: number;
    modelName: string;
    maturityTargetLevel: number;

    // supported levels in this model
    levels: MaturityLevel[];

    questionsAlias: string;

    // the options for answering questions in this model
    answerOptions: string[];
    modelTitle: string;
    modelDescription: string;
    iconId: number;
}

/**
 * Defines a single maturity level.
 */
export interface MaturityLevel {
    label: string;
    level: number;
    applicable: boolean;
}

/**
 *
 */
export interface AssessmentContactsResponse {
    contactList: User[];
    currentUserRole: number;
}

export interface Demographic {
    assessment_Id?: number;
    sectorId?: number;
    industryId?: number;
    size?: number;
    assetValue?: number;
    needsPrivacy?: boolean;
    needsSupplyChain?: boolean;
    needsICS?: boolean;
    organizationName?: string;
    agency?: string;
    organizationType?: string;
    facilitator?: number;

    // Organiztion POC
    orgPointOfContact?: number;

    // Critical Service description
    criticalService?: string;

    // Critical Service POC
    pointOfContact?: number;

    // An EDM-only field
    isScoped?: boolean;
}

export interface AssessmentConfig{
    additionalNotesAndComments?: any; 
    applicationMode?: string; 
    assessmentDate?: string;
    assessmentDescription?: any; 
    assessmentEffectiveDate?: string; 
    assessmentName?: string; 
    assets?: number; 
    baselineAssessmentId?: any; 
    baselineAssessmentName?: any; 
    charter?: string; 
    cityOrSiteName?: string; 
    createdDate?: string; 
    creatorId?: number; 
    creatorName?: string; 
    creditUnion?: any; 
    diagramImage?: any; 
    diagramMarkup?: any; 
    executiveSummary?: string; 
    facilityName?: string; 
    galleryItemGuid?: string; 
    hiddenScreens?: any; 
    id?: number; 
    isAcetOnly?: boolean;
    isE_StateLed?: boolean; 
    is_PCII?: boolean; 
    iseSubmitted?: boolean;
    lastModifiedDate?: string; 
    maturityModel?: {
        modelId?: string; 
        modelName?: string; 
        maturityTargetLevel?: number; 
        levels?: any; 
        questionAlias?: string;
        iconId?: any; 
    }; 
    origin?: any; 
    pciiNumber?: any; 
    postalCode?: any; 
    questionRequirementCounts?: any; 
    regionCode?: any;
    standards?: any;
    stateProvRegion?: string;
    typeDescription?: string;
    typeTitle?: string;
    useDiagram?: boolean; 
    useMaturity?: boolean
    useStandard?: boolean
    workflow?: string; 
}

export interface ServiceComposition{
    applicationsDescription?: string;
    assessmentId?: number; 
    connectionsDescription?: string; 
    networksDescription?: string; 
    otherDefiningSystemDescription?: any; 
    personnelDescription?: string; 
    primaryDefiningSystem?: number;
    secondaryDefiningSystems?: any; 
    servicesDescription?: string;

}

export interface ServiceDemographic {
    assessmentId?: number;
    authorizedNonOrganizationalUserCount?: string;
    authorizedOrganizationalUserCount?: string;
    budgetBasis?: string;
    criticalServiceDescription?: string;
    customersCount?: string;
    cybersecurityItIcsStaffCount?: string;
    itIcsName?: string;
    itIcsStaffCount?: string;
    multiSite?: boolean;
    multiSiteDescription?: boolean;
}

export interface CriticalServiceInfo {
    agency?: any; 
    assessmentId?: number; 
    assetValue?: any; 
    cisaRegion?: number; 
    criticalService?: string; 
    facilitator?: null; 
    id?: number; 
    industryId?: any; 
    isScoped?: boolean; 
    orgPointOfContact?: any; 
    organizationName?: any; 
    organizationType?: any; 
    pointOfContact?: number; 
    sectorId?: any; 
    size?: any; 
}