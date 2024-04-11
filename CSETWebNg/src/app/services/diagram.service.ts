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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { Vendor } from '../models/diagram-vulnerabilities.model';

const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class DiagramService {
  apiUrl: string;
  id: number;
  csafVendors: Vendor[] = [];

  constructor(private http: HttpClient, private configSvc: ConfigService) {
    this.apiUrl = this.configSvc.apiUrl + 'diagram/';
  }

  // calls to retrieve static data
  getSymbols() {
    return this.http.get(this.apiUrl + 'symbols/get');
  }

  saveComponent(component) {
    return this.http.post(this.apiUrl + 'saveComponent', component, headers)
  }

  getAllSymbols() {
    return this.http.get(this.apiUrl + 'symbols/getAll');
  }

  // get diagram components
  getDiagramComponents() {
    return this.http.get(this.apiUrl + 'getComponents');
  }

  getDiagramZones() {
    return this.http.get(this.apiUrl + 'getZones');
  }

  getDiagramShapes() {
    return this.http.get(this.apiUrl + 'getShapes');
  }

  getDiagramText() {
    return this.http.get(this.apiUrl + 'getTexts');
  }

  getDiagramLinks() {
    return this.http.get(this.apiUrl + 'getLinks');
  }

  getDiagramWarnings() {
    return this.http.get(this.configSvc.apiUrl + 'analysis/NetworkWarnings');
  }

  getExport(): any {
    return this.http.get(this.apiUrl + 'exportExcel', { responseType: 'blob' });
  }

  getVulnerabilities() {
    return this.http.get(this.apiUrl + 'vulnerabilities');
  }

  saveCsafVendor(vendor: Vendor) {
    return this.http.post(this.apiUrl + 'vulnerabilities/saveVendor', vendor, headers);
  }

  deleteCsafVendor(vendorName: string) {
    return this.http.post(this.apiUrl + 'vulnerabilities/deleteVendor?vendorName=' + vendorName, '');
  }

  deleteCsafProduct(vendorName: string, productName: string) {
    return this.http.post(this.apiUrl + 'vulnerabilities/deleteProduct?vendorName=' + vendorName + '&productName=' + productName, '');
  }

  /**
   * 
   */
  updateAssetType(guid: string, componentType: string, label: string) {
    return this.http.post(this.apiUrl + 'assetType?guid=' + guid + '&type=' + componentType + '&label=' + label, '');
  }
  /**
   * 
   */
  changeShapeToComponent(componentType: string, id: string, label: string) {
    return this.http.post(this.apiUrl + 'changeShapeToComponent?type=' + componentType + '&id=' + id + '&label=' + label, '');
  }

  /**
   * finds and appends the '-#' suffix a component label needs (e.g. CLK-1, FW-4, etc.)
   */
  applyComponentSuffix(type: string, diagramComponentList: any) {
    let suffix = 1; // tracking the new number after the hyphen (CLK-1, CON-13, etc.)
    let similarCompLabels = diagramComponentList.filter(c => c.label.substring(0, type.length) == type);

    for (let i = 0; i < similarCompLabels.length; i++) {
      let compLabel = similarCompLabels[i].label;

      // if (compLabel == type) {
      //   suffix = 1;
      // }
      if (compLabel.charAt(type.length) == '-' && +compLabel.substring(type.length + 1) >= suffix) {
        suffix = (+compLabel.substring(type.length + 1)) + 1; //gets the number after the hyphen, then increments
      }
    }

    return type + '-' + suffix; // append the suffix to the type name, and add a hyphen in between
  }
}
