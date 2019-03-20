////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
  UserId?: number;
  AssessmentId?: number;
  AssessmentRoleId?: number;
  ContactId?: string;
  FirstName?: string;
  Id?: string;
  Invited?: boolean;
  LastName?: string;
  PrimaryEmail?: string;
  saveEmail?: string;
}

export interface CreateUser {
  UserId?: number;
  FirstName?: string;
  LastName?: string;
  PrimaryEmail?: string;
  ConfirmEmail?: string;
  SecurityQuestion1?: string;
  SecurityAnswer1?: string;
  SecurityQuestion2?: string;
  SecurityAnswer2?: string;
  AppCode?: string;
}

export interface PotentialQuestions {
  SecurityQuestionId?: string;
  SecurityQuestion?: string;
  Answer?: string;
}

