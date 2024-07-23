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
import { HttpClient, HttpHeaders, HttpParams, HttpEventType, HttpRequest, HttpResponseBase } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Subject, Observable } from 'rxjs';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams(),
};

@Injectable({
  providedIn: 'root'
})
export class ImportAssessmentService {

  apiAssessmentImport = this.configSvc.apiUrl + 'assessment/import';
  apiLegacyAssessmentImport = this.configSvc.apiUrl + 'assessment/legacy/import';

  hintMap = new Map();

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService) {
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
      let req = null;
      let tmpheader = new HttpHeaders({ 'Authorization': localStorage.getItem('userToken') });
      tmpheader.append('Authorization', localStorage.getItem('userToken'));
      tmpheader = tmpheader.append('pwd', password);

      if (isNormalLoad) {
        req = new HttpRequest('POST', this.apiAssessmentImport, formData,
          {
            headers: tmpheader,
            reportProgress: true
          }
        )

      } else {
        req = new HttpRequest('POST', this.apiLegacyAssessmentImport, formData,
          {
            headers: tmpheader,
            reportProgress: true,
          }
        );
      }

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
        } else if (event instanceof HttpResponseBase) {
          if (event.status == 404) {
            let errObj = {
              message: "File import failed. Custom module not found",
            };
            progress.error(errObj);
          }
          if (event.status == 423) {
            let errObj = {
              message: "File requires a password",
            };
            progress.error(errObj);
          } else if (event.status == 406) {
            let errObj = {
              message: "Invalid password.",
            };
            progress.error(errObj);
          } else if (event.status != 200 && event.status != 406 && event.status != 423) {
            let errObj = {
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
          this.hintMap.set(file.name, this.extractAssessmentHint(error.error));
        }
      );
    })

    // return the map of progress.observables
    return status;
  }

  /**
   * Parses the error string to display only the "hint" that a user might need
   */
  extractAssessmentHint(message: string) {
    let hint = "";

    // We could use regex here, but this works.
    let firstSplit = message.split("- ");
    let firstString = firstSplit[1];
    let secondSplit = firstString.split(".hint");
    hint = secondSplit[0];

    return hint;
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
