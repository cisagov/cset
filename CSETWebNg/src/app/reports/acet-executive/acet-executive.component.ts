import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ACETService } from '../../services/acet.service';
import { MatDetailResponse, MaturityDomain, MaturityComponent, MaturityAssessment } from '../../models/mat-detail.model';
import { AcetDashboard } from '../../models/acet-dashboard.model';



@Component({
  selector: 'app-acet-executive',
  templateUrl: './acet-executive.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class AcetExecutiveComponent implements OnInit {
  response: any = null;
  graphdata: any = [];
  maturityDetail: MaturityDomain[];
  domainDataList: any = [];
  sortDomainListKey: string[] = ["Cyber Risk Management & Oversight", 
    "Threat Intelligence & Collaboration", 
    "Cybersecurity Controls", 
    "External Dependency Management", 
    "Cyber Incident Management and Resilience"]

  sortedDomainList: any = []

  // Maturity Rep Data
  matDetailResponse: MatDetailResponse;
  maturityDomain: MaturityDomain;
  maturityComponent: MaturityComponent;
  maturityAssessment: MaturityAssessment;
  acetDashboard: AcetDashboard;
  information: any;

  constructor(
    public reportSvc: ReportService,
    public acetSvc: ACETService,
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Executive Report - ACET");
    
    this.acetSvc.getAssessmentInformation().subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Assessment Information Error: ' + (<Error>error).message)
    );
  
    this.acetSvc.getMatDetailList().subscribe(
      (data: any) => {
        // Format and connect donut data here
        // Finall order:

        // Cyber Risk Management & OversightThreat 
        // Intelligence & Collaboration  
        // Cybersecurity Controls 
        // External Dependency Management 
        // Cyber Incident Management and Resilience

        console.log(data);
        data.forEach((domain: MaturityDomain) => {
          if (domain.DomainMaturity == "Sub-Baseline"){
            domain.DomainMaturity = "ad-hoc";
          }
          var domainData = { 
            domainName: domain.DomainName, 
            domainMaturity: domain.DomainMaturity, 
            targetPercentageAchieved: domain.TargetPercentageAchieved,
            graphdata: []}
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
            domainData.graphdata.push(assesmentData);
          })
          this.domainDataList.push(domainData);
        })
      
        // Domains do not currently come sorted from API, this will sort the domains into proper order.
        this.sortDomainListKey.forEach(domain => {
          this.domainDataList.filter(item => {
            if (item.domainName == domain) {
              this.sortedDomainList.push(item);
            }
          })
        })
        this.domainDataList = this.sortedDomainList;

        },
      error => {
        console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error getting all documents: ' + (<Error>error).stack);
      });

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

  isNaNValuevalue(value) {
    if (value == "NaN"){
      return 0
    } else {
      return value
    }
  }

}
