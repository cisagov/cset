////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { HttpClient, HttpHeaders, HttpParams, HttpResponse, HttpEventType, HttpRequest } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Subject, Observable } from 'rxjs';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class ImportAssessmentService {

  apiAssessmentImport = this.configSvc.apiUrl + 'assessment/import';
  apiLegacyAssessmentImport = this.configSvc.apiUrl + 'assessment/legacy/import';

  constructor(private http: HttpClient, private configSvc: ConfigService) {
  }

  public upload(files: Set<File>, isNormalLoad: boolean): { [key: string]: Observable<number> } {

    // this will be the our resulting map
    const status = {};

    files.forEach(file => {
      // create a new multipart-form for every file
      const formData: FormData = new FormData();
      formData.append('file', file, file.name);

      // create a http-post request and pass the form
      // tell it to report the upload progress
      let req = null;
      const tmpheader = new HttpHeaders({'Authorization': sessionStorage.getItem('userToken')});
      tmpheader.append('Authorization', sessionStorage.getItem('userToken'));
      if (isNormalLoad) {
        req = new HttpRequest('POST', this.apiAssessmentImport, formData,
          { headers: tmpheader,
            reportProgress: true }
        );
      } else {
        req = new HttpRequest('POST', this.apiLegacyAssessmentImport, formData,
          { headers: tmpheader,
            reportProgress: true },
        );
      }

      // create a new progress-subject for every file
      const progress = new Subject<number>();

      // send the http-request and subscribe for progress-updates
      this.http.request(req).subscribe(event => {
        if (event.type === HttpEventType.UploadProgress) {

          // calculate the progress percentage
          const percentDone = Math.round(100 * event.loaded / event.total);

          // pass the percentage into the progress-stream
          progress.next(percentDone);
        } else if (event instanceof HttpResponse) {

          // Close the progress-stream if we get an answer form the API
          // The upload is complete
          progress.complete();
        }
      });

      // Save every progress-observable in a map of all observables
      status[file.name] = {
        progress: progress.asObservable()
      };
    });

    // return the map of progress.observables
    return status;
  }

  /**
   * Retrieves the list of frameworks.
   */
  postAssessmentImport(assessmentModel: any) {
    return this.http.post(this.configSvc.apiUrl + 'assessment/import', assessmentModel, headers);
  }

  legacyAssessmentImport(importFilepath: string) {
    return this.http.post(this.configSvc.apiUrl + 'assessment/legacy/import', importFilepath, headers);
  }

}
