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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import {
  AssessmentContactsResponse,
  AssessmentDetail,
  MaturityModel
} from '../models/assessment-info.model';
import { User } from '../models/user.model';
import { ConfigService } from './config.service';
import { Router } from '@angular/router';


export interface Role {
  assessmentRoleId: number;
  assessmentRole: string;
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

  /**
   * This is private because we need a setter so that we can do things
   * when the assessment is loaded.
   */
  public assessment: AssessmentDetail;

  /**
   * Stores the active assessment 'features' that the user wishes to use,
   * e.g., diagram, standards, maturity model.
   */
  public assessmentFeatures: any[] = [];

  static allMaturityModels: MaturityModel[];


  /**
   * Indicates if a brand-new assessment is being created.
   * This will allow the assessment-detail page to do certain
   * things that should only be done on the very first load of an assessment.
   */
  public isBrandNew = false;

  /**
   *
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private router: Router
  ) {
    if (!this.initialized) {
      this.apiUrl = this.configSvc.apiUrl;

      this.http.get(this.apiUrl + 'contacts/allroles')
        .subscribe((response: Role[]) => (this.roles = response));

      this.http.get(this.apiUrl + "MaturityModels")
        .subscribe((data: MaturityModel[]) => {
          AssessmentService.allMaturityModels = data;
        });

      this.initialized = true;
    }
  }

  /**
   * 
   */
  dropAssessment() {
    this.userRoleId = undefined;
    this.currentTab = undefined;
    this.applicationMode = undefined;
    this.assessment = undefined;
    sessionStorage.removeItem('assessmentId');
  }

  /**
   * 
   */
  refreshRoles() {
    return this.http.get(this.apiUrl + 'contacts/allroles');
  }

  createAssessment(mode) {
    return this.http.get(this.apiUrl + 'createassessment?mode=' + mode);
  }

  /**
   * 
   */
  getAssessments() {
    return this.http.get(this.apiUrl + 'assessmentsforuser');
  }

  /**
   * 
   */
  getAssessmentToken(assessId: number) {
    return this.http
      .get(this.apiUrl + 'auth/token?assessmentId=' + assessId)
      .toPromise()
      .then((response: { token: string }) => {
        sessionStorage.removeItem('userToken');
        sessionStorage.setItem('userToken', response.token);
        if (assessId) {
          sessionStorage.removeItem('assessmentId');
          sessionStorage.setItem(
            'assessmentId',
            assessId ? assessId.toString() : ''
          );
        }
      });
  }

  /**
   * 
   */
  getAssessmentDetail() {
    return this.http.get(this.apiUrl + 'assessmentdetail');
  }

  /**
   * Returns an observable that calls the API to get the last modified date
   * for the assessment.
   * @returns 
   */
  getLastModified() {
    return this.http.get(this.apiUrl + 'lastmodified', { responseType: 'text' });
  }


  /**
   * 
   */
  updateAssessmentDetails(assessment: AssessmentDetail) {
    this.assessment = assessment;

    return this.http
      .post(
        this.apiUrl + 'assessmentdetail',
        JSON.stringify(assessment),
        headers
      )
      .subscribe();
  }

  /**
   * 
   */
  getAssessmentContacts() {
    return this.http
      .get(this.apiUrl + 'contacts')
      .toPromise()
      .then((response: AssessmentContactsResponse) => {
        this.userRoleId = response.currentUserRole;
        return response;
      });
  }

  /**
   * 
   */
  getOrganizationTypes() {
    return this.http.get(this.apiUrl + 'getOrganizationTypes');
  }

  /**
   * 
   */
  searchContacts(term: User) {
    return this.http.post(
      this.apiUrl + 'contacts/search',
      JSON.stringify(term),
      headers
    );
  }

  /**
   * 
   */
  createContact(contact: User) {
    const body = this.configSvc.config.defaultInviteTemplate;
    return this.http.post(
      this.apiUrl + 'contacts/addnew',
      {
        firstName: contact.firstName,
        lastname: contact.lastName,
        primaryEmail: contact.primaryEmail,
        assessmentRoleId: contact.assessmentRoleId,
        subject: this.configSvc.config.defaultInviteSubject,
        body: body
      },
      headers
    );
  }

  /**
   * 
   */
  updateContact(contact: User): any {
    return this.http.post(
      this.apiUrl + 'contacts/UpdateUser',
      contact,
      headers
    );
  }

  /**
   * 
   */
  addContact(contact: User) {
    return this.http.post(
      this.apiUrl + 'contacts/add',
      {
        primaryEmail: contact.primaryEmail,
        assessmentRoleId: contact.assessmentRoleId
      },
      headers
    );
  }

  /**
   * Disconnects the current user from an assessment.
   */
  removeMyContact(assessment_id: number) {
    return this.http.post(
      this.apiUrl + 'contacts/remove',
      { assessmentId: assessment_id },
      headers
    );
  }

  /**
   * Requests removing a user from an assessment.
   */
  removeContact(assessmentContactId: number) {
    return this.http.post(
      this.apiUrl + 'contacts/remove',
      { assessmentContactId: assessmentContactId },
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

  /**
   * 
   */
  id(): number {
    return +sessionStorage.getItem('assessmentId');
  }

  /**
   * 
   */
  getMode() {
    this.http
      .get(this.apiUrl + 'GetMode', { responseType: 'text' })
      .subscribe((mode: string) => (this.applicationMode = mode));
  }

  /**
   * Create a new assessment.
   */
  newAssessment() {
    let mode = this.configSvc.acetInstallation;
    this.createAssessment(mode)
      .toPromise()
      .then(
        (response: any) => {
          // set the brand new flag
          this.isBrandNew = true;

          this.loadAssessment(response.id);
        },
        error =>
          console.log(
            'Unable to create new assessment: ' + (<Error>error).message
          )
      );
  }

  /**
   * 
   */
  loadAssessment(id: number) {
    this.getAssessmentToken(id).then(() => {

      this.getAssessmentDetail().subscribe(data => {
        this.assessment = data;

        // make sure that the acet only switch is turned off when in standard CSET
        if (!this.configSvc.acetInstallation) {
          this.assessment.isAcetOnly = false;
        }

        const rpath = localStorage.getItem('returnPath');
        if (rpath != null) {
          localStorage.removeItem('returnPath');
          const returnPath = '/assessment/' + id + '/' + rpath;
          this.router.navigate([returnPath], { queryParamsHandling: 'preserve' });
        } else {
          this.router.navigate(['/assessment', id]);
        }
      });
    });
  }

  /**
   * Reset things to ACET defaults
   */
  setAcetDefaults() {
    if (!!this.assessment) {
      this.assessment.useMaturity = true;
      this.assessment.maturityModel = AssessmentService.allMaturityModels.find(m => m.modelName == 'ACET');
      this.assessment.isAcetOnly = true;

      this.assessment.useStandard = false;
      this.assessment.useDiagram = false;
    }
  }


  /**
   * 
   */
  getAssessmentDocuments() {
    return this.http.get(this.apiUrl + 'assessmentdocuments');
  }

  /**
   * 
   */
  hasDiagram() {
    return this.http.get(this.apiUrl + 'diagram/has');
  }

  /**
   * Returns a boolean indicating if the feature is active.
   * @param feature 
   */
  hasFeature(feature: string) {
    return this.assessmentFeatures.indexOf(feature.toLowerCase()) >= 0;
  }

  /**
   * Adds or removes an assessment feature from the list.
   */
  changeFeature(feature: string, state: boolean) {
    if (state) {
      if (this.assessmentFeatures.indexOf(feature) < 0) {
        this.assessmentFeatures.push(feature);
      }
    } else {
      this.assessmentFeatures = this.assessmentFeatures.filter(x => x !== feature);
    }
  }

  /**
   * Indicates if the assessment uses the specified maturity model.
   */
  usesMaturityModel(modelName: string) {
    if (!this.assessment) {
      return false;
    }

    if (!this.assessment.useMaturity) {
      return false;
    }

    if (!this.assessment.maturityModel) {
      return false;
    }

    if (!this.assessment.maturityModel.modelName) {
      return false;
    }

    if (modelName == '*' && !!this.assessment.maturityModel.modelName) {
      return true;
    }

    return this.assessment.maturityModel.modelName.toLowerCase() === modelName.toLowerCase();
  }

  /**
   * Sets the maturity model name on the assessment
   * @param modelName 
   */
  setModel(modelName: string) {
    this.assessment.maturityModel = AssessmentService.allMaturityModels.find(m => m.modelName == modelName);
  }

  /**
   * Indicates if the assessment contains the standard.
   */
  usesStandard(setName: string) {
    if (!this.assessment || !this.assessment.standards) {
      return false;
    }
    return this.assessment?.standards.some(s => s.toLowerCase() == setName.toLowerCase());
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
