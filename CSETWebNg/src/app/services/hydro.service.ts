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

  saveHydroComment(answerId: number, progressId: number, comment: string) {
    let hpc = new HydroProgressComment();
    hpc.Answer_Id = answerId;
    hpc.Progress_Id = progressId;
    hpc.Comment = comment;

    console.log(hpc)
    
    return this.http.post(this.configSvc.apiUrl + 'saveHydroComment', hpc, headers);
  }

  getProgressText() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/hydro/getProgressText', headers);
  }
}

export class HydroProgressComment {
  Answer_Id: number;
  Progress_Id: number;
  Comment: string;
}
