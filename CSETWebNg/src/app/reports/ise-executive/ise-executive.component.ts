import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ACETService } from '../../services/acet.service';
import { MatDetailResponse, MaturityDomain, MaturityComponent, MaturityAssessment } from '../../models/mat-detail.model';
import { AcetDashboard } from '../../models/acet-dashboard.model';



@Component({
  selector: 'app-ise-executive',
  templateUrl: './ise-executive.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss', '../../assessment/results/acet-detail/acet-detail.component.scss']
})
export class IseExecutiveComponent implements OnInit {
  response: any = null;
  graphdata: any = [];
  maturityDetail: MaturityDomain[];
  domainDataList: any = [];
  sortDomainListKey: string[] = ["Information Security Program",
    "Cybersecurity Controls"]

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
    this.titleService.setTitle("Executive Report - ISE");

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

        // Information Security Program
        // Cybersecurity Controls

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
              "assessmentFactor": assignment.assessmentFactor,
              "domainMaturity": this.updateMaturity(assignment.assessmentFactorMaturity),
              "levelDisplay": this.acetSvc.translateMaturity(this.updateMaturity(assignment.assessmentFactorMaturity)),
              "sections": []
            }
            assignment.components.forEach((component: MaturityComponent) => {
              var sectionData = [
                { "name": "SCUEP", "value": component.scuep },
                { "name": "CORE", "value": component.core },
                { "name": "CORE+", "value": component.corePlus },
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
    this.acetSvc.getIseMatRange().subscribe(
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
    if (this.bottomExpected == "SCUEP" && mat == "Incomplete") {
      return "domain-gray";
    } else if (this.bottomExpected == "SCUEP" && mat == "Ad-hoc") {
      return "domain-red";
    }
    else if (this.bottomExpected == "CORE" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "SCUEP")) {
      return "domain-red";
    } else if (this.bottomExpected == "CORE+" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "SCUEP")) {
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
