import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { RequiredDocument } from '../models/required-document.model';

const headers = {
  headers: new HttpHeaders()
      .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class RequiredDocumentService {

  constructor(private http: HttpClient, private configSvc: ConfigService) { }

  /**
   * Retrieves the list of frameworks.
   */
  getRequiredDocumentsList() {
    return this.http.get(this.configSvc.apiUrl + 'reqddocs');
  }

  /**
   * Posts the current selected documents to the server.
   */
  postSelections(selected: RequiredDocument) {
    return this.http.post(this.configSvc.apiUrl + 'required', selected, headers);
  }
}
