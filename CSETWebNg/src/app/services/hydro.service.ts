import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';

const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class HydroService {

  constructor(
    private http: HttpClient,
    public configSvc: ConfigService
  ) { }

  getBulkSubCats(subCatIds: string[]) {
    console.log(subCatIds)
    return this.http.get(this.configSvc.apiUrl + 'maturity/hydro/getBulkSubCatIds?subCatIds=' + subCatIds, headers);
  }

  isHydroLevel(levelName: string) {
    if (levelName == 'HYDRO') {
      return true;
    }
    return false;
  }
}
