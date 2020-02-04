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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import {
  AssessmentContactsResponse,
  AssessmentDetail
} from '../models/assessment-info.model';
import { User } from '../models/user.model';
import { ConfigService } from './config.service';
import { Router } from '@angular/router';
import { EmailService } from './email.service';

export interface Role {
  AssessmentRoleId: number;
  AssessmentRole: string;
}

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class AssessmentService {

  userRoleId: number;
  roles: Role[];
  currentTab: string;
  private apiUrl: string;
  private initialized = false;
  public applicationMode: string;

  constructor(
    private emailSvc: EmailService,
    private http: HttpClient,
    private configSvc: ConfigService,
    private router: Router
  ) {
    if (!this.initialized) {
      this.apiUrl = this.configSvc.apiUrl;
      this.http.get(this.apiUrl + 'contacts/allroles')
        .subscribe((response: Role[]) => (this.roles = response));
      this.initialized = true;
    }
  }

  dropAssessment() {
    this.userRoleId = undefined;
    this.currentTab = undefined;
    this.applicationMode = undefined;
    sessionStorage.removeItem('assessmentId');
  }

  refreshRoles() {
    return this.http.get(this.apiUrl + 'contacts/allroles');
  }

  createAssessment() {
    return this.http.get(this.apiUrl + 'createassessment');
  }

  getAssessments() {
    return this.http.get(this.apiUrl + 'assessmentsforuser');
  }

  getAssessmentToken(assessId: number) {
    return this.http
      .get(this.apiUrl + 'auth/token?assessmentId=' + assessId)
      .toPromise()
      .then((response: { Token: string }) => {
        sessionStorage.removeItem('userToken');
        sessionStorage.setItem('userToken', response.Token);
        if (assessId) {
          sessionStorage.removeItem('assessmentId');
          sessionStorage.setItem(
            'assessmentId',
            assessId ? assessId.toString() : ''
          );
        }
      });
  }

  getAssessmentDetail() {
    return this.http.get(this.apiUrl + 'assessmentdetail');
  }

  updateAssessmentDetails(assessment: AssessmentDetail) {
    return this.http
      .post(
        this.apiUrl + 'assessmentdetail',
        JSON.stringify(assessment),
        headers
      )
      .subscribe();
  }

  getAssessmentContacts() {
    return this.http
      .get(this.apiUrl + 'contacts')
      .toPromise()
      .then((response: AssessmentContactsResponse) => {
        this.userRoleId = response.CurrentUserRole;
        return response;
      });
  }

  searchContacts(term: User) {
    return this.http.post(
      this.apiUrl + 'contacts/search',
      JSON.stringify(term),
      headers
    );
  }

  createContact(contact: User) {
    const body = this.configSvc.config.defaultInviteTemplate;
    return this.http.post(
      this.apiUrl + 'contacts/addnew',
      {
        FirstName: contact.FirstName,
        Lastname: contact.LastName,
        PrimaryEmail: contact.PrimaryEmail,
        AssessmentRoleId: contact.AssessmentRoleId,
        Subject: this.configSvc.config.defaultInviteSubject,
        Body: body
      },
      headers
    );
  }

  updateContact(contact: User): any {
    return this.http.post(
      this.apiUrl + 'contacts/UpdateUser',
      contact,
      headers
    );
  }

  addContact(contact: User) {
    return this.http.post(
      this.apiUrl + 'contacts/add',
      {
        PrimaryEmail: contact.PrimaryEmail,
        AssessmentRoleId: contact.AssessmentRoleId
      },
      headers
    );
  }

  removeContact(userId: number, assessment_id: number) {
    return this.http.post(
      this.apiUrl + 'contacts/remove',
      { UserId: userId, Assessment_ID: assessment_id },
      headers
    );
  }

  /**
   * Checks to see if deleting the assessment would leave it without
   * an ADMIN contact
   */
  isDeletePermitted(assessmentId: number) {
    return this.http.post(
      this.apiUrl + 'contacts/validateremoval?assessmentId=' + assessmentId,
      null,
      headers
    );
  }

  id(): number {
    return +sessionStorage.getItem('assessmentId');
  }

  getMode() {
    this.http
      .get(this.apiUrl + 'GetMode')
      .subscribe((mode: string) => (this.applicationMode = mode));
  }

  newAssessment() {
    this.createAssessment()
      .toPromise()
      .then(
        (response: any) => this.loadAssessment(response.Id),
        error =>
          console.log(
            'Unable to create new assessment: ' + (<Error>error).message
          )
      );
  }

  loadAssessment(id: number) {
    this.getAssessmentToken(id).then(() => {
      const rpath = localStorage.getItem('returnPath');
      if (rpath != null) {
        localStorage.removeItem('returnPath');
        const returnPath = '/assessment/' + id + '/' + rpath;
        this.router.navigate([returnPath], { queryParamsHandling: 'preserve' });
      } else {
        this.router.navigate(['/assessment', id]);
      }
    });
  }

  getAssessmentDocuments() {
    return this.http.get(this.apiUrl + 'assessmentdocuments');
  }

  hasDiagram() {
    return this.http.get(this.apiUrl + 'diagram/has');
  }

  /**
   * Converts linebreak characters to HTML <br> tag.
   */
  formatLinebreaks(text: string) {
    if (!text) {
      return '';
    }
    return text.replace(/(?:\r\n|\r|\n)/g, '<br />');
  }
}
