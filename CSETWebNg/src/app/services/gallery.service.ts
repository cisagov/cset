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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { AssessmentService } from './assessment.service';
import { NavigationService } from './navigation/navigation.service';
import { AuthenticationService } from './authentication.service';

const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()

@Injectable({
  providedIn: 'root'
})
export class GalleryService {

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService,
    private navSvc: NavigationService,
    private authSvc: AuthenticationService
  ) { }


  galleryData: any;
  rows: any;
  testRow: any;

  /**
   * Retrieves the list of frameworks.
   */
  getGalleryItems(layout_name: string) {
    return this.http.get(this.configSvc.apiUrl + 'gallery/getboard', {
      params: {
        Layout_Name: layout_name
      }
    });
  }

  refreshCards() {
    this.getGalleryItems(this.configSvc.galleryLayout).subscribe(
      (resp: any) => {
        this.galleryData = resp;
        this.rows = this.galleryData.rows;
        this.testRow = this.rows[1];

        ///NOTE THIS runs the default item if there is only one item automatically
        if (this.configSvc.installationMode == "CF") {
          if (this.authSvc.isFirstLogin()) {
            this.navSvc.clearNoMatterWhat();
            this.assessSvc.clearFirstTime();
            this.authSvc.setFirstLogin(false);
            this.navSvc.beginNewAssessmentGallery(this.rows[0].galleryItems[0]);
          }
        }
        // if (this.rows.length == 1 && this.rows[0].galleryItems.length == 1) {          
        //   this.navSvc.beginNewAssessmentGallery(this.rows[0].galleryItems[0]);
        // }

        // create a plainText property for the elipsis display in case a description has HTML markup
        const dom = document.createElement("div");
        this.rows.forEach(row => {
          row.galleryItems.forEach(item => {
            dom.innerHTML = item.description;
            item.plainText = dom.innerText;
          });
        });
      }
    );
  }

  /**
   * Posts the current selected tier to the server.
   */
  postSelections(galleryItemGuid: number) {
    return this.http.post(this.configSvc.apiUrl + 'gallery/setstate', galleryItemGuid, headers);
  }
}
