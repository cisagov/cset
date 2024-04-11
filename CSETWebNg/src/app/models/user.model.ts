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

/*adds a calculation to determine when and iff
the object should be editable*/
export interface User {
  userId?: number;
  assessmentId?: number;
  assessmentRoleId?: number;
  contactId?: string;
  firstName?: string;
  id?: string;
  invited?: boolean;
  lastName?: string;
  primaryEmail?: string;
  saveEmail?: string;
  assessmentContactId?: number;
  title?: string;
  phone?: string;
  isPrimaryPoc: boolean;
  siteName?: string;
  organizationName?: string;
  cellPhone?: string;
  reportsTo?: string;
  emergencyCommunicationsProtocol?: string;
  isSiteParticipant: boolean;
}

export interface CreateUser {
  userId?: number;
  firstName?: string;
  lastName?: string;
  primaryEmail?: string;
  confirmEmail?: string;
  securityQuestion1?: string;
  securityAnswer1?: string;
  securityQuestion2?: string;
  securityAnswer2?: string;
  appName?: string;
  title?: string;
  phone?: string;
  isFirstLogin?: boolean;
}

export interface PotentialQuestions {
  securityQuestionId?: string;
  securityQuestion?: string;
  answer?: string;
}

