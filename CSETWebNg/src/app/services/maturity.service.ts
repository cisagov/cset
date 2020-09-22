import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';

const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class MaturityService {

  /**
   * 
   */
  levels = [
    { name: "One", value: 1 },
    { name: "Two", value: 2 },
    { name: "Three", value: 3 },
    { name: "Four", value: 4 },
    { name: "Five", value: 5 }
  ];

  /**
   * 
   * @param http 
   * @param configSvc 
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
  ) { }


  /**
   * Posts the current selections to the server.
   */
  postSelections(selections: string[]) {
    return this.http.post(
      this.configSvc.apiUrl + "MaturityModels",
      selections,
      headers
    );
  }

  /**
   * Gets the saved maturity level from the API
   */
  getLevel() {
    return this.http.get(
      this.configSvc.apiUrl + "MaturityLevel",
      headers
    )
  }
  /**
   * Posts the selected maturity level to the API. 
   * @param level 
   */
  saveLevel(level: number) {
    return this.http.post(
      this.configSvc.apiUrl + "MaturityLevel",
      level,
      headers
    )
  }

}
