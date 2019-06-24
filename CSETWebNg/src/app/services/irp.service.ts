import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { IRP } from '../models/irp.model';

const headers = {
  headers: new HttpHeaders()
      .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class IRPService {

  constructor(private http: HttpClient, private configSvc: ConfigService) { }

  /**
   * Retrieves the list of frameworks.
   */
  getIRPList() {
    return this.http.get(this.configSvc.apiUrl + 'irps');
  }

  /**
   * Posts the current selected documents to the server.
   */
  postSelection(selected: IRP) {
    return this.http.post(this.configSvc.apiUrl + 'irp', selected, headers);
  }
}
