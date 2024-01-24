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
import { Role } from "../services/assessment.service";
import { User } from "./user.model";

/* a view model to implement the edit logic*/
export class EditableUser implements User {
  userId?: number;
  assessmentId?: number;
  assessmentRoleId?: number;
  assessmentContactId?: number;
  contactId?: string;
  firstName?: string = '';
  lastName?: string = '';
  id?: string;
  invited?: boolean;
  primaryEmail?: string;
  editOverride: boolean;
  saveFirstName: string;
  saveLastName: string;
  saveEmail: string;
  saveAssessmentRoleId: number;
  saveTitle: string;
  savePhone: string;
  isNew: boolean;
  isFirst = false;
  roles: Role[];
  title?: string;
  phone?: string;
  isPrimaryPoc: boolean;
  savePrimaryPoc: boolean;
  siteName?: string;
  organizationName?: string;
  saveSiteName: string;
  saveOrganizationName: string;
  cellPhone?: string;
  saveCellPhone: string;
  saveEmergencyCommunicationsProtocol: string;
  reportsTo?: string;
  saveReportsTo: string;
  emergencyCommunicationsProtocol?: string;
  isSiteParticipant: boolean;
  saveSiteParticipant: boolean;

  constructor(user: User) {
    this.userId = user.userId;
    this.assessmentId = user.assessmentId;
    if (user.assessmentRoleId) {
      this.assessmentRoleId = user.assessmentRoleId;
    } else {
      this.assessmentRoleId = 1;
    }
    this.assessmentContactId = user.assessmentContactId;
    this.contactId = user.contactId;
    this.firstName = user.firstName;
    this.id = user.id;
    this.invited = user.invited;
    this.lastName = user.lastName;
    this.primaryEmail = user.primaryEmail;
    this.assessmentRoleId = user.assessmentRoleId;
    this.saveEmail = user.saveEmail;
    this.editOverride = false;
    this.title = user.title;
    this.phone = user.phone;
    this.isPrimaryPoc = user.isPrimaryPoc;
    this.siteName = user.siteName;
    this.organizationName = user.organizationName;
    this.cellPhone = user.cellPhone;
    this.reportsTo = user.reportsTo;
    this.isSiteParticipant = user.isSiteParticipant;
    this.emergencyCommunicationsProtocol = user.emergencyCommunicationsProtocol;

    if (this.assessmentId > 0) {
      this.isNew = false;
    } else {
      this.isNew = true;
    }
  }

  /**
   * Returns a formatted name.
   */
  fullName() {
    if (this.firstName === null && this.lastName === null) {
      return '';
    }

    if (this.firstName.length > 0 && this.lastName.length > 0) {
      return this.firstName + ' ' + this.lastName;
    }

    // local install stores the full domain-qualified userid in firstname
    if (this.firstName.indexOf('\\') >= 0 && this.firstName.indexOf(' ') < 0 && this.lastName.length === 0) {
      return this.firstName.substr(this.firstName.lastIndexOf('\\') + 1);
    }

    return (this.firstName + ' ' + this.lastName).trim();
  }

  // tell edit mode to turn on
  startEdit() {
    if (this.isNew) {
      return;
    }
    this.saveReset();
    this.editOverride = false;
    return this.evaluateCanEdit();
  }

  // tell edit mode to turn off
  endEdit() {
    if (this.isNew) {
      return;
    }
    return this.evaluateCanEdit();
  }

  abandonEdit(): any {
    this.firstName = this.saveFirstName;
    this.lastName = this.saveLastName;
    this.primaryEmail = this.saveEmail;
    this.assessmentRoleId = this.saveAssessmentRoleId;
    this.editOverride = false;
    this.phone = this.savePhone;
    this.title = this.saveTitle;
    this.isPrimaryPoc = this.savePrimaryPoc;
    this.isSiteParticipant = this.saveSiteParticipant;
    this.cellPhone = this.saveCellPhone;
    this.organizationName = this.saveOrganizationName;
    this.siteName = this.saveSiteName;
    this.emergencyCommunicationsProtocol = this.saveEmergencyCommunicationsProtocol
    this.reportsTo = this.saveReportsTo;
  }
  saveReset(): any {
    this.saveFirstName = this.firstName;
    this.saveLastName = this.lastName;
    this.saveEmail = this.primaryEmail;
    this.saveAssessmentRoleId = this.assessmentRoleId;
    this.savePhone = this.phone;
    this.saveTitle = this.title;
    this.savePrimaryPoc = this.isPrimaryPoc;
    this.saveSiteParticipant = this.isSiteParticipant;
    this.saveCellPhone = this.cellPhone;
    this.saveOrganizationName = this.organizationName;
    this.saveSiteName = this.siteName;
    this.saveEmergencyCommunicationsProtocol = this.emergencyCommunicationsProtocol;
    this.saveReportsTo = this.reportsTo;

  }

  get AssessmentRole(): string {
    return this.getRoleFromId(this.assessmentRoleId);
  }

  getRoleFromId(assessmentRoleId: number) {
    for (const r of this.roles) {
      if (r.assessmentRoleId === assessmentRoleId) {
        return r.assessmentRole;
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
    // if ((this.assessmentRoleId === 1) || this.assessmentRoleId === 2) {
    if (!this.isNew) {
      return true;
    } else {
      return false;
    }
  }
}
