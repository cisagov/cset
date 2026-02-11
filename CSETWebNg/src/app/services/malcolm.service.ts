////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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

  findMalcolmAnswerForQuestion(questionId: number, list: any) {
    if (list != null && list.length > 0) {
      for (let i = 0; i < list.length; i++) {
        if (list[i].question_Or_Requirement_Id == questionId) {
          return list[i];
        }
      }
    }
  }

  findMalcolmOptionId(questionId: number, list: any, optionId: number) {
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

  uploadMalcolmFiles(files: File[]) {
    let formData: FormData = new FormData();

    for (let i = 0; i < files.length; i++) {
      formData.append('file', files[i]);
    }

    return this.http.post(this.configSvc.apiUrl + 'malcolm?', formData);
  }

}

