import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ACETService } from '../../services/acet.service';
import { MatDetailResponse, MaturityDomain, MaturityComponent, MaturityAssessment } from '../../models/mat-detail.model';
import { AcetDashboard } from '../../models/acet-dashboard.model';



@Component({
  selector: 'app-acet-executive',
  templateUrl: './acet-executive.component.html',
  styleUrls: ['../reports.scss']
})
export class AcetExecutiveComponent implements OnInit {
  response: any = null;
  mockDataAcetExecutive: any = {
    "information": {
      "Assessment_Name": "Manhattan Assessment",
      "Assessment_Date": "2020-09-19",
      "Assessor_Name": "Michael Jones",
      "Credit_Union": "Bank of Bill",
      "Facility_Name": "Bills Bank",
      "City_Or_Site_Name": "New New York City",
      "State_Prov_Region": "New York",
      "Charter": "NNYC",
      "Assets": "1234",
    }
  };
  donutData: any = [
    {"name": "Baseline", "value": 100},
    { "name": "Evolving", "value": 100 },
    { "name": "Intermediate", "value": 78 },
    { "name": "Advanced", "value": 17 },
    { "name": "Innovative", "value": 0 }
  ];

  donutGroup: any = [{
    "name": "Oversight",
    "data": this.donutData
  }];

  graphdata: any = [];

  // Maturity Rep Data
  matDetailResponse: MatDetailResponse;
  maturityDomain: MaturityDomain;
  maturityComponent: MaturityComponent;
  maturityAssessment: MaturityAssessment;
  acetDashboard: AcetDashboard;

  constructor(
    public reportSvc: ReportService,
    public acetSvc: ACETService,
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Executive Report - ACET");
    // Here get report data
    // ToDo: Uncomment this and connect backend for report data
    //this.reportSvc.getReport('<ACET Endpoint>').subscribe(
    //  (r: any) => {
    //    this.response = r;
    //  },
    //  error => console.log('Executive report load Error: ' + (<Error>error).message)
    //);
    this.response = this.mockDataAcetExecutive;

    this.acetSvc.getMatDetailList().subscribe(
      (data: any) => {
        console.log(data);
        // Format and connect donut data here
        data.forEach((domain: MaturityDomain) => {
          if (domain.DomainName == "Cyber Risk Management & Oversight"){
            domain.Assessments.forEach((assignment: MaturityAssessment) => {
              var assesmentData = {
                "asseessmentFactor": assignment.AssessmentFactor,
                "sections": []
              }
              assignment.Components.forEach((component: MaturityComponent) => {
                var sectionData = [
                { "name": "Baseline", "value": component.Baseline },
                { "name": "Evolving", "value": component.Evolving }, 
                { "name": "Intermediate", "value": component.Intermediate },
                { "name": "Advanced", "value": component.Advanced },
                { "name": "Innovative", "value": component.Innovative }
              ]
              var sectonInfo = {
                "name": component.ComponentName,
                "data": sectionData
              }
                assesmentData.sections.push(sectonInfo);
              })
              this.graphdata.push(assesmentData);
            })

          };
        })
          
    //      domain.Assessments.forEach((assignment: MaturityAssessment) => {
    //        assignment.Components.forEach((component: MaturityComponent) => {
    //          var sectionData = [
    //            { "name": "Baseline", "value": component.Baseline },
    //            { "name": "Evolving", "value": component.Evolving }, 
    //            { "name": "Intermediate", "value": component.Intermediate },
    //            { "name": "Advanced", "value": component.Advanced },
    //            { "name": "Innovative", "value": component.Innovative }
    //          ]
    //          var sectonInfo = {
    //            "name": component.ComponentName,
    //            "data": sectionData
    //          }
    //          this.donutGroup.push(sectonInfo);
    //        })
    //        
    //
        },
      error => {
        console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error getting all documents: ' + (<Error>error).stack);
      });

    console.log(this.graphdata)

    this.acetSvc.getAcetDashboard().subscribe(
      (data: AcetDashboard) => {
        this.acetDashboard = data;

        for (let i = 0; i < this.acetDashboard.IRPs.length; i++) {
          this.acetDashboard.IRPs[i].Comment = this.acetSvc.interpretRiskLevel(this.acetDashboard.IRPs[i].RiskLevel);
        }
      },
      error => {
        console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error getting all documents: ' + (<Error>error).stack);
      });

  }

}
