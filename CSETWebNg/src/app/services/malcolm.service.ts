import { Injectable, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';

const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class MalcolmService {

  constructor(
    private http: HttpClient,
    public configSvc: ConfigService
  ) { }

  getMalcolmAnswers() {
    return this.http.get(this.configSvc.apiUrl + 'getMalcolmAnswers');    
  }

  findMalcolmAnswerForQuestion (questionId: number, list: any) {
    if (list != null && list.length > 0) {
      for (let i = 0; i < list.length; i++) {
        if (list[i].question_Or_Requirement_Id == questionId) {
          return list[i];
        }
      }
    }
  }

  findMalcolmOptionId (questionId: number, list: any, optionId: number) {
    if (list != null && list.length > 0) {
      for (let i = 0; i < list.length; i++) {
        if (list[i].question_Or_Requirement_Id == questionId && list[i].mat_Option_Id == optionId) {
          return true;
        }
      }
    }
  }

  attemptToImportFromMalcolm(ipAddress: string) {
    return this.http.get(this.configSvc.apiUrl + 'malcolm?IPAddress=' + ipAddress);
  }

}

