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

  impactTranslator(impact: number) {
    if (impact == 1) {
      return 'High';
    }
    if (impact == 2) {
      return 'Medium';
    }
    if (impact == 3) {
      return 'Low';
    }
  }

  saveHydroComment(answer: any, answerId: number, progressId: number, comment: string) {
    let hpc = new HydroProgressComment();
    hpc.Answer = answer;
    hpc.Answer_Id = answerId;
    hpc.Progress_Id = progressId;
    hpc.Comment = comment;

    return this.http.post(this.configSvc.apiUrl + 'saveHydroComment', hpc, headers);
  }

  getProgressText() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/hydro/getProgressText', headers);
  }

  getHydroDonutData(): any {
    return this.http.get(this.configSvc.apiUrl + 'reports/getHydroDonutData');
  }

  getHydroActionItems(): any {
    return this.http.get(this.configSvc.apiUrl + 'reports/getHydroActionItems');
  }

  uploadMalcolmFiles(files: File[]) {
    let formData: FormData = new FormData();
    
    for (let i = 0; i < files.length; i++) {
      formData.append('file', files[i]);
    }

    return this.http.post(this.configSvc.apiUrl + 'malcolm?', formData);
  }
}

export class HydroProgressComment {
  Answer: any;
  Answer_Id: number;
  Progress_Id: number;
  Comment: string;
}
