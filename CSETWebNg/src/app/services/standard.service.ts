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
import { Injectable } from "@angular/core";
import { HttpClient, HttpHeaders, HttpParams } from "@angular/common/http";
import { ConfigService } from "./config.service";
import { NavigationService } from "./navigation.service";

const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};

@Injectable()
export class StandardService {
  frameworkSelected = false;

  constructor(private http: HttpClient, private configSvc: ConfigService, private navSvc: NavigationService) {}

  /**
   * Retrieves the list of standards.
   */
  getStandardsList() {
    return this.http.get(this.configSvc.apiUrl + "standards");
  }

  /**
   * Posts the current selections to the server.
   */
  postSelections(selections: string[]) {
    return this.http.post(
      this.configSvc.apiUrl + "standard",
      selections,
      headers
    );
  }

  getFramework() {
    return this.http.get(this.configSvc.apiUrl + "standard/IsFramework");
  }

  setFrameworkSelected(framework: boolean) {
    const magic = this.navSvc.getMagic();
    this.frameworkSelected = framework;

    const tree = [
      {children: [], label: 'Assessment Information', value: 'info'},
      {children: [], label: 'Security Assurance Level (SAL)', value: 'sal'},
      {children: [], label: 'Cybersecurity Standards Selection', value: 'standards'}
    ];

    if (this.frameworkSelected) {
      tree.push({children: [], label: 'Cybersecurity Framework', value: 'framework'});
    }

    this.navSvc.setTree(tree, magic);
  }
}
