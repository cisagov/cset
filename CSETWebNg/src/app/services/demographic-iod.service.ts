import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';

@Injectable({
  providedIn: 'root'
})
export class DemographicIodService {

  apiUrl: string;

  /**
   * 
   * @param http 
   * @param configSvc 
   */
  constructor(
    private http: HttpClient, 
    private configSvc: ConfigService
  ) {
    this.apiUrl = this.configSvc.apiUrl + 'demographics/ext2';
   }

   /**
    * 
    * @returns 
    */
  getDemographics() {
    return this.http.get(this.apiUrl);
  }
}
