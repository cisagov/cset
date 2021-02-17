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
import { Role } from "../services/assessment.service";
import { User } from "./user.model";

/* a view model to implement the edit logic*/
export class EditableUser implements User {
  UserId?: number;
  AssessmentId?: number;
  AssessmentRoleId?: number;
  AssessmentContactId?: number;
  ContactId?: string;
  FirstName?: string = '';
  LastName?: string = '';
  Id?: string;
  Invited?: boolean;
  PrimaryEmail?: string;
  editOverride: boolean;
  saveFirstName: string;
  saveLastName: string;
  saveEmail: string;
  saveAssessmentRoleId: number;
  IsNew: boolean;
  IsFirst = false;
  roles: Role[];
  Title?: string;
  Phone?: string;

  constructor(user: User) {
    this.UserId = user.UserId;
    this.AssessmentId = user.AssessmentId;
    if (user.AssessmentRoleId) {
      this.AssessmentRoleId = user.AssessmentRoleId;
    } else {
      this.AssessmentRoleId = 1;
    }
    this.AssessmentContactId = user.AssessmentContactId;
    this.ContactId = user.ContactId;
    this.FirstName = user.FirstName;
    this.Id = user.Id;
    this.Invited = user.Invited;
    this.LastName = user.LastName;
    this.PrimaryEmail = user.PrimaryEmail;
    this.AssessmentRoleId = user.AssessmentRoleId;
    this.saveEmail = user.saveEmail;
    this.editOverride = false;
    this.Title = user.Title;
    this.Phone = user.Phone;

    if (this.AssessmentId > 0) {
      this.IsNew = false;
    } else {
      this.IsNew = true;
    }
  }

  /**
   * Returns a formatted name.
   */
  fullName() {
    if (this.FirstName === null && this.LastName === null) {
      return '';
    }

    if (this.FirstName.length > 0 && this.LastName.length > 0) {
      return this.FirstName + ' ' + this.LastName;
    }

    // local install stores the full domain-qualified userid in firstname
    if (this.FirstName.indexOf('\\') >= 0 && this.FirstName.indexOf(' ') < 0 && this.LastName.length === 0) {
      return this.FirstName.substr(this.FirstName.lastIndexOf('\\') + 1);
    }

    return (this.FirstName + ' ' + this.LastName).trim();
  }

  // tell edit mode to turn on
  startEdit() {
    if (this.IsNew) {
      return;
    }
    this.saveReset();
    this.editOverride = false;
    return this.evaluateCanEdit();
  }

  // tell edit mode to turn off
  endEdit() {
    if (this.IsNew) {
      return;
    }
    return this.evaluateCanEdit();
  }

  abandonEdit(): any {
    this.FirstName = this.saveFirstName;
    this.LastName = this.saveLastName;
    this.PrimaryEmail = this.saveEmail;
    this.AssessmentRoleId = this.saveAssessmentRoleId;
    this.editOverride = false;
  }
  saveReset(): any {
    this.saveFirstName = this.FirstName;
    this.saveLastName = this.LastName;
    this.saveEmail = this.PrimaryEmail;
    this.saveAssessmentRoleId = this.AssessmentRoleId;
  }

  get AssessmentRole(): string {
    return this.getRoleFromId(this.AssessmentRoleId);
  }

  getRoleFromId(AssessmentRoleId: number) {
    for (const r of this.roles) {
      if (r.AssessmentRoleId === AssessmentRoleId) {
        return r.AssessmentRole;
      }
    }
    return null;
  }

  /**
   * So the situations we need to worry about are
   * the user is super user (not doing it for now)
   * the user is new not created yet
   * the user is already there and can edit
   * the user it the admin of this and cannot edit themselves.
   */
  evaluateCanEdit() {
    if (this.editOverride) {
      return true;
    }
    // if ((this.AssessmentRoleId === 1) || this.AssessmentRoleId === 2) {
    if (!this.IsNew) {
      return true;
    } else {
      return false;
    }
  }
}
