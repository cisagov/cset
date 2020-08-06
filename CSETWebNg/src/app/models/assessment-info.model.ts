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
import { User } from './user.model';

export interface AssessmentDetail {
    Id?: number;
    AssessmentName?: string;
    CreatedDate?: string;
    CreatorId?: number;
    AssessmentDate?: string;
    FacilityName?: string;
    CityOrSiteName?: string;
    StateProvRegion?: string;
    ExecutiveSummary?: string;
    AssessmentDescription?: string;
    AdditionalNotesAndComments?: string;
    Charter?: string;
    CreditUnion?: string;
    Assets?: string;

    UseStandard: boolean;
    UseMaturity: boolean;
    UseDiagram: boolean;
}

export interface AssessmentContactsResponse {
    ContactList: User[];
    CurrentUserRole: number;
}

export interface Demographic {
    Assessment_Id?: number;
    SectorId?: number;
    IndustryId?: number;
    Size?: number;
    AssetValue?: number;
    NeedsPrivacy?: boolean;
    NeedsSupplyChain?: boolean;
    NeedsICS?: boolean;
}

