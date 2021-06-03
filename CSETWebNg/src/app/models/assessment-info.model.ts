////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
    facilityName?: string;
    cityOrSiteName?: string;
    stateProvRegion?: string;
    executiveSummary?: string;
    assessmentDescription?: string;
    additionalNotesAndComments?: string;
    charter?: string;
    creditUnion?: string;
    assets?: string;

    useStandard?: boolean;
    useMaturity?: boolean;
    useDiagram?: boolean;
    isAcetOnly?: boolean;

    maturityModel?: MaturityModel;

    // A list of selected standards
    standards?: string[];
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
    pointOfContact?: number;
    isScoped?: boolean;
}

