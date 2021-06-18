import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { CmmcStyleService } from './cmmc-style.service';
import { ConfigService } from './config.service';


const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class RraDataService {
  apiUrl: string;
  constructor(public cmmcSvc:CmmcStyleService,private http: HttpClient, private configSvc: ConfigService) {
    this.apiUrl = this.configSvc.apiUrl + 'reports';
    
  }

  response: any;
  pageInitialized = false;
  referenceTable: any;

  cmmcModel: any;
  statsByLevel: any;
  statsByDomain: any;
  statsByDomainAtUnderTarget: any;
  stackBarChartData: any;
  complianceLevelAcheivedData: any;
  gridColumnCount = 10
  gridColumns = new Array(this.gridColumnCount);

  public getRRADetail(){
    return this.http.get(this.apiUrl + '/rradetail')
  }

  public getData(){
   this.http.get(this.apiUrl + '/RRASummary').subscribe(
      (r: any) => {
        this.response = r;   
        console.log(r);     
      },
      error => console.log('Main RRA report load Error: ' + (<Error>error).message)
    );    
      
    //       if (model.MaturityModelName === 'RRA') {
    //         this.statsByLevel = this.cmmcSvc.generateStatsByLevel(model.StatsByLevel);
    //         this.statsByDomain = model.StatsByDomain;
    //         this.statsByDomainAtUnderTarget = model.StatsByDomainAtUnderTarget;
    //         this.stackBarChartData = this.cmmcSvc.generateStackedBarChartData(model.StatsByLevel);
    //         //this.complianceLevelAcheivedData = this.cmmcSvc.getComplianceLevelAcheivedData();
    //         this.referenceTable = this.cmmcSvc.generateReferenceList(model.MaturityQuestions, 9);
    //         console.log(this.referenceTable);
    //       }
    //     });
        
    window.dispatchEvent(new Event('resize'));
  }  
}
