////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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

import { Settings } from "http2";

/**
 * A CIST critical service information organization demographic
 */
export interface CsiOrganizationDemographic {
  assessmentId?: number;
  motivationCrr?: boolean;
  motivationCrrDescription?: string;
  motivationRrap?: boolean;
  motivationRrapDescription?: string;
  motivationOrganizationRequest?: boolean;
  motivationOrganizationRequestDescription?: string;
  motivationLawEnforcementRequest?: boolean;
  motivationLawEnforcementRequestDescription?: string;
  motivationDirectThreats?: boolean;
  motivationDirectThreatsDescription?: string;
  motivationSpecialEvent?: boolean;
  motivationSpecialEventDescription?: string
  motivationOther?: boolean;
  motivationOtherDescription?: string;
  parentOrganization?: string;
  organizationName?: string;
  siteName?: string;
  streetAddress?: string;
  visitDate?: string;
  completedForSltt?: boolean;
  completedForFederal?: boolean;
  completedForNationalSpecialEvent?: boolean;
  cikrSector?: string;
  subSector?: string;
  itIcsStaffCount?: string;
  cybersecurityItIcsStaffCount?: string;
}

/**
 * A CIST critical service information service composition
 */
export interface CsiServiceComposition {
  assessmentId: number;
  networksDescription?: string;
  servicesDescription?: string;
  applicationsDescription?: string;
  connectionsDescription?: string;
  personnelDescription?: string;
  otherDefiningSystemDescription?: string;
  primaryDefiningSystem?: number;
}


/**
 * A CIST critical service information service demographic
 */
export interface CsiServiceDemographic {
  assessmentId: number;
  criticalServiceName?: string;
  criticalServiceDescription?: string;
  itIcsName?: string;
  multiSite: boolean;
  multiSiteDescription?: string;
  budgetBasis?: string;
  authorizedOrganizationalUserCount?: string;
  authorizedNonOrganizationUserCount?: string;
  customersCount?: string;
}

/**
 * A CIST staff count option
 */
export interface CsiStaffCount {
  staffCount: string;
  sequence: number;
}

/**
 * A CIST user count option
 */
export interface CsiUserCount {
  userCount: string;
  sequence: number;
}

/**
 * A CIST customer count option
 */
export interface CsiCustomerCount {
  userCount: string;
  sequence: number;
}

/**
 * A CIST budget basis option
 */
export interface CsiBudgetBasis {
  budgetBasis: string;
}

export interface CsiDefiningSystem {
  definingSystemId: number;
  definingSystem: string;
}
