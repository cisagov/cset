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
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};


@Injectable({
  providedIn: 'root'
})

export class TsaService {
  public assessment: AssessmentDetail;
  public selectedStandards: string[] = [];
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
   TSAtogglecrr(assessment: AssessmentDetail){
    this.assessment = assessment;
    return this.http
    .post<MaturityModel>(
      this.configSvc.apiUrl + "tsa/togglecrr",
      JSON.stringify(assessment),
      headers
    );
  }
  
  TSAtogglerra(assessment: AssessmentDetail){
    this.assessment = assessment;
    return this.http.post<MaturityModel>(
      this.configSvc.apiUrl + "tsa/togglerra",
      JSON.stringify(assessment),
      headers
    )
  }

   
  TSAtogglestandard(assessment: AssessmentDetail){
    this.assessment = assessment;
    this.selectedStandards=assessment.standards;
    return this.http.post(
      this.configSvc.apiUrl + "tsa/togglestandard",
      JSON.stringify(assessment),
      headers
      
    ).pipe(map(resp=>{
      
      for(const key in resp){
        this.selectedStandards.push(key);
      }
      return this.selectedStandards;
    }))
  }
}
