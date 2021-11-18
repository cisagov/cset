import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AssessmentService } from './assessment.service';
import { MaturityDomainRemarks, QuestionGrouping } from '../models/questions.model';
import {
  AssessmentContactsResponse,
  AssessmentDetail,
  MaturityModel
} from '../models/assessment-info.model';
const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};


@Injectable({
  providedIn: 'root'
})

export class TsaService {
  public assessment: AssessmentDetail;

  // static currentMaturityModelName: string;
  static currentTSAModelName: string;
 // assessmentDetail is what i need
  domains: any[];

  // Array of Options for Consideration
  ofc: any[];


  cmmcData = null;

  /**
   * 
   * @param http 
   * @param configSvc 
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService
  ) { }
  /**
   * Posts the current selections to the server.
   */
   TSAtogglecrr(assessment: AssessmentDetail) {
    this.assessment = assessment;
    return this.http.post(
      this.configSvc.apiUrl + "api/tsa/togglecrr" + assessment,
      JSON.stringify(assessment),
      headers
    );
  }
  
  TSAtogglerra(assessment: AssessmentDetail) {
    this.assessment = assessment;
    return this.http.post(
      this.configSvc.apiUrl + "api/tsa/togglerra" + assessment,
      JSON.stringify(assessment),
      headers
    );
  }

   
  TSAtogglestandard(assessment: AssessmentDetail) {
    this.assessment = assessment;
    return this.http.post(
      this.configSvc.apiUrl + "api/tsa/togglestandard" + assessment,
      JSON.stringify(assessment),
      headers
    );
  }
}
