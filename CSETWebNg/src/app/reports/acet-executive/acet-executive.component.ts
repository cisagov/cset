import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ACETService } from '../../services/acet.service';
import { MatDetailResponse, MaturityDomain, MaturityComponent, MaturityAssessment } from '../../models/mat-detail.model';
import { AcetDashboard } from '../../models/acet-dashboard.model';



@Component({
  selector: 'app-acet-executive',
  templateUrl: './acet-executive.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss', '../../assessment/results/mat-detail/mat-detail.component.scss']
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
  matRange: string[];
  bottomExpected: string;



  constructor(
    public reportSvc: ReportService,
    public acetSvc: ACETService,
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Executive Report - ACET");

    this.getMatRange();

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

        data.forEach((domain: MaturityDomain) => {
          if (domain.domainMaturity == "Sub-Baseline") {
            domain.domainMaturity = "Ad-hoc";
          }
          var domainData = {
            domainName: domain.domainName,
            domainMaturity: this.updateMaturity(domain.domainMaturity),
            levelDisplay: this.acetSvc.translateMaturity(this.updateMaturity(domain.domainMaturity)),
            targetPercentageAchieved: domain.targetPercentageAchieved,
            graphdata: []
          }
          domain.assessments.forEach((assignment: MaturityAssessment) => {
            var assesmentData = {
              "asseessmentFactor": assignment.assessmentFactor,
              "domainMaturity": this.updateMaturity(assignment.assessmentFactorMaturity),
              "levelDisplay": this.acetSvc.translateMaturity(this.updateMaturity(assignment.assessmentFactorMaturity)),
              "sections": []
            }
            assignment.components.forEach((component: MaturityComponent) => {
              var sectionData = [
                { "name": "Baseline", "value": component.baseline },
                { "name": "Evolving", "value": component.evolving },
                { "name": "Intermediate", "value": component.intermediate },
                { "name": "Advanced", "value": component.advanced },
                { "name": "Innovative", "value": component.innovative }
              ]

              var sectonInfo = {
                "name": component.componentName,
                "data": sectionData,
                "assessedMaturityLevel": this.updateMaturity(component.assessedMaturityLevel),
                "levelDisplay": this.acetSvc.translateMaturity(this.updateMaturity(component.assessedMaturityLevel)), 
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

        for (let i = 0; i < this.acetDashboard.irps.length; i++) {
          this.acetDashboard.irps[i].comment = this.acetSvc.interpretRiskLevel(this.acetDashboard.irps[i].riskLevel);
        }
      },
      error => {
        console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error getting all documents: ' + (<Error>error).stack);
      });

  }

  getMatRange() {
    this.acetSvc.getMatRange().subscribe(
      (data) => {
        var dataArray = data as string[];
        this.matRange = dataArray;
        if (dataArray.length > 1) {
          this.bottomExpected = dataArray[0];
        }
      },
      error => {
        console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error getting all documents: ' + (<Error>error).stack);
      });
  }

  isNaNValuevalue(value) {
    if (value == "NaN") {
      return 0
    } else {
      return value
    }
  }

  checkMaturity(mat: string) {
    if (this.bottomExpected == "Baseline" && mat == "Incomplete") {
      return "domain-gray";
    }
    else if (this.bottomExpected == "Baseline" && mat == "Ad-hoc") {
      return "domain-red";
    } else if (this.bottomExpected == "Evolving" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "Baseline")) {
      return "domain-red";
    } else if (this.bottomExpected == "Intermediate" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "Baseline" || mat == "Evolving")) {
      return "domain-red";
    } else if (this.bottomExpected == "Advanced" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "Baseline" || mat == "Evolving" || mat == "Intermediate")) {
      return "domain-red";
    } else {
      return "domain-green";
    }

  }

  updateMaturity(domainMaturity: string) {
    if (domainMaturity == "Sub-Baseline") {
      domainMaturity = "Ad-hoc";
    }
    return domainMaturity
  }

}
