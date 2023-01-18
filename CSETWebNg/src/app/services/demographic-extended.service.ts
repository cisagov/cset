////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { ExtendedDemographics, Geographics } from '../models/demographics-extended.model';


const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class DemographicExtendedService {
  apiUrl: string;
  id: number;

  constructor(private http: HttpClient, private configSvc: ConfigService) {
    this.apiUrl = this.configSvc.apiUrl + 'demographics/ext';
  }

 

  getDemographics() {
    return this.http.get(this.apiUrl);
  }

  getGeographics() {
    return this.http.get(this.apiUrl + '/geographics');
  }

  getDemoAnswered() {
    return this.http.get(this.apiUrl + '/demoanswered');
  }

  getAllSectors() {
    return this.http.get(this.apiUrl + '/sectors');
  }

  getSubsector(sectorId: number) {
    return this.http.get(this.apiUrl + '/subsector/' + sectorId);
  }

  getRegions(state: string) {
    return this.http.get(this.apiUrl + '/regions/' + state)
  }

  getCounties(state: string) {
    return this.http.get(this.apiUrl + '/counties/' + state);
  }

  getMetros(state: string) {
    return this.http.get(this.apiUrl + '/metros/' + state);
  }

  getEmployeeRanges() {
    return this.http.get(this.apiUrl + '/employees');
  }

  getCustomerRanges() {
    return this.http.get(this.apiUrl + '/customers');
  }

  getGeoScope() {
    return this.http.get(this.apiUrl + '/geoscope');
  }

  getCio() {
    return this.http.get(this.apiUrl + '/cio');
  }

  getCiso() {
    return this.http.get(this.apiUrl + '/ciso');
  }

  getTraining() {
    return this.http.get(this.apiUrl + '/training');
  }

  /**
   * Persist the model to the API.
   */
  updateExtendedDemographics(demographic: ExtendedDemographics) {
    this.http.post(this.apiUrl, JSON.stringify(demographic), headers)
    .subscribe();
  }

  /**
   * 
   */
  persistGeographicSelections(x: Geographics) {
    this.http.post(this.apiUrl + '/geographics', JSON.stringify(x), headers)
    .subscribe();
  }
}
