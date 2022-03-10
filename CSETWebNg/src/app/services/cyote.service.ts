// PLACEHOLDER
// TODO: Cleanup - put functionality here or delete it

import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AssessmentService } from './assessment.service';
import {
  AssessmentContactsResponse,
  AssessmentDetail,
  MaturityModel
} from '../models/assessment-info.model';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};


@Injectable({
  providedIn: 'root'
})

export class CyoteService {

  /**
   *
   * @param http
   * @param configSvc
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService
  ) { }


  public meetsCyberEventThreshold = false;
  public additionalComments: '';
  public anomalies: any[] = [
    {
      id: 1,
      // categories: ['ics'],
      title: 'Mouse Moving',
      description: 'Suspicious mouse activity noticed on workstation.  Opened PowerShell, but I intervened and shut the computer down before anything further could happen.',
      reporter: 'John Doe',
      isFirstTimeAooHasSeenObservable: false,
      categories: {
        physical: true,
        digital: false,
        network: false,
      },
      questions: {
        affectingOperations: false,
        affectingOperationsDescription: '',
        affectingProcesses: false,
        affectingProcessesDescription: '',
        multipleDevices: false,
        multipleDevicesDescription: '',
        multipleNetworkLayers: false,
        multipleNetworkLayersDescription: '',
            },
    },
    {
      id: 2,
      category: 'digital',
      title: 'Unexpected Code',
      description: 'Malware scanner detected XYZ trojan in system utility ABC and quarantined the affected program.',
      reporter: 'John Doe',
      isFirstTimeAooHasSeenObservable: false,
      categories: {
        physical: false,
        digital: true,
        network: false,
      },
      questions: {
        affectingOperations: false,
        affectingOperationsDescription: '',
        affectingProcesses: false,
        affectingProcessesDescription: '',
        multipleDevices: false,
        multipleDevicesDescription: '',
        multipleNetworkLayers: false,
        multipleNetworkLayersDescription: '',
      },
    },
    {
      id: 3,
      category: 'network',
      title: 'Increase Network Traffic',
      description: 'Notification from monitoring software that network traffic increased 30x over the last 2 days.  No known changes to infrastructure have been made that would account for the increase.',
      reporter: 'John Doe',
      isFirstTimeAooHasSeenObservable: false,
      categories: {
        physical: false,
        digital: false,
        network: true,
      },
      questions: {
        affectingOperations: false,
        affectingOperationsDescription: '',
        affectingProcesses: false,
        affectingProcessesDescription: '',
        multipleDevices: false,
        multipleDevicesDescription: '',
        multipleNetworkLayers: false,
        multipleNetworkLayersDescription: '',
      },
    },
  ];
  public nextAnomalyId: number = this.anomalies.length + 1;


  // /**
  //  * Posts the current selections to the server.
  //  */
  //  cyotetogglecrr(assessment: AssessmentDetail){
  //   this.assessment = assessment;
  //   return this.http
  //   .post<MaturityModel>(
  //     this.configSvc.apiUrl + "cyote/togglecrr",
  //     JSON.stringify(assessment),
  //     headers
  //   );
  // }

  // cyotetogglerra(assessment: AssessmentDetail){
  //   this.assessment = assessment;
  //   return this.http.post<MaturityModel>(
  //     this.configSvc.apiUrl + "cyote/togglerra",
  //     JSON.stringify(assessment),
  //     headers
  //   )
  // }


  // cyotetogglestandard(assessment: AssessmentDetail){
  //   this.assessment = assessment;
  //   this.selectedStandards=assessment.standards;
  //   return this.http.post(
  //     this.configSvc.apiUrl + "cyote/togglestandard",
  //     JSON.stringify(assessment),
  //     headers

  //   ).pipe(map(resp=>{

  //     for(const key in resp){
  //       this.selectedStandards.push(key);
  //     }
  //     return this.selectedStandards;
  //   }))
  // }
}
