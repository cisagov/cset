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
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams, HttpEventType, HttpRequest, HttpResponseBase, HttpResponse } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Subject, Observable } from 'rxjs';
import { AssessmentService } from './assessment.service';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams(),
};

@Injectable({
  providedIn: 'root'
})
export class ImportDemographicService {

  apiAssessmentImport = this.configSvc.apiUrl + 'demographics/import';
  apiLegacyAssessmentImport = this.configSvc.apiUrl + 'demographics/import';

  hintMap = new Map();

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    public assessSvc: AssessmentService

  ) {
  }

  public upload(files: Set<File>, isNormalLoad: boolean, password): { [key: string]: Observable<number> } {
    // this will be the our resulting map
    const status = {};

    files.forEach(file => {
      // create a new multipart-form for every file
      const formData: FormData = new FormData();
      formData.append('file', file, file.name,);

      // create a http-post request and pass the form
      // tell it to report the upload progress

      let tmpheader = new HttpHeaders({ 'Authorization': localStorage.getItem('userToken') });
      tmpheader.append('Authorization', localStorage.getItem('userToken'));
      tmpheader = tmpheader.append('pwd', password);

      const assessmentID = this.assessSvc.id(); // Assuming assessmentID is an integer
      const urlWithParam = `${this.apiAssessmentImport}`;
      let req = new HttpRequest('POST', urlWithParam, formData, {
        headers: tmpheader,
        reportProgress: true
      });

      // create a new progress-subject for every file
      const progress = new Subject<number>();
      // Save every progress-observable in a map of all observables
      status[file.name] = {
        progress: progress.asObservable()
      };

      // Make sure our assessment hints are empty ahead of time

      this.hintMap.clear();

      // send the http-request and subscribe for progress-updates
      this.http.request(req).subscribe(event => {
        if (event.type === HttpEventType.UploadProgress) {

          // calculate the progress percentage
          const percentDone = Math.round(100 * event.loaded / event.total);

          // pass the percentage into the progress-stream
          progress.next(percentDone);
        } else if (event instanceof HttpResponse) {

          if (event.status == 423) {
            let errObj = {
              code: 80,
              message: "File requires a password",
            };
            progress.error(errObj);
          } else if (event.status == 406) {
            let errObj = {
              code: 90,
              message: "Invalid password",
            };
            progress.error(errObj);
          } else if ((event.body as any)?.code == 100) {
            let errObj = {
              code: 100,
              message: "The file content is not valid JSON"
            };
            progress.error(errObj);
          }  else if ((event.body as any)?.code == 101) {
            let errObj = {
              code: 101,
              message: "The file content is not recognizable as CSET demographics"
            };
            progress.error(errObj);
          } else if (event.status != 200 && event.status != 406 && event.status != 423) {
            let errObj = {
              code: 70,
              message: "File Import Failed",
            };
            progress.error(errObj);
          }


          // Close the progress-stream if we get an answer form the API
          // The upload is complete
          else progress.complete();
        }

      },
        (error) => {

        }
      );
    })

    // return the map of progress.observables
    return status;
  }
}
