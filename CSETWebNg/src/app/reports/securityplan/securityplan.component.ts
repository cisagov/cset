////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, OnInit } from '@angular/core';
import { Title, SafeHtml, DomSanitizer } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { AcetDashboard } from '../../models/acet-dashboard.model';
import { ACETService } from '../../services/acet.service';
import { AssessmentService } from '../../services/assessment.service';
import { TranslocoService } from '@ngneat/transloco';


@Component({
  selector: 'securityplan',
  templateUrl: './securityplan.component.html',
  styleUrls: ['../reports.scss']
})
export class SecurityplanComponent implements OnInit {
  translationSub: any;
  response: any;

  componentCount = 0;
  networkDiagramImage: SafeHtml;
  responseResultsByCategory: any;

  acetDashboard: AcetDashboard;

  /**
   * 
   */
  public constructor(
    private titleService: Title,
    public reportSvc: ReportService,
    public analysisSvc: ReportAnalysisService,
    public configSvc: ConfigService,
    public acetSvc: ACETService,
    private assessmentSvc: AssessmentService,
    private sanitizer: DomSanitizer,
    public tSvc: TranslocoService,
    private translocoService: TranslocoService
  ) { }

  /**
   *
   */
  ngOnInit() {
    
    this.translationSub = this.translocoService.selectTranslate('reports.core.security plan.report title')
      .subscribe(value =>
        this.titleService.setTitle(this.tSvc.translate('reports.core.security plan.report title') + ' - ' + this.configSvc.behaviors.defaultTitle));

    this.reportSvc.getReport('securityplan').subscribe(
      (r: any) => {
        this.response = r;
        // convert line breaks to HTML
        this.response.controlList.forEach(control => {
          control.controlDescription = control.controlDescription.replace(/\r/g, '<br/>');
        });
      },
      error => console.log('Security Plan report load Error: ' + (<Error>error).message)
    );

    // Component Types (stacked bar chart)
    this.analysisSvc.getComponentTypes().subscribe(x => {
      this.componentCount = x.labels.length;

      // Network Diagram
      this.reportSvc.getNetworkDiagramImage().subscribe(y => {
        this.networkDiagramImage = this.sanitizer.bypassSecurityTrustHtml(y.diagram);
      });
    });

    this.analysisSvc.getStandardsResultsByCategory().subscribe(x => {
      this.responseResultsByCategory = x;
    });

    if (['ACET', 'ISE'].includes(this.assessmentSvc.assessment?.maturityModel?.modelName)) {
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
  }

  usesRAC() {
    return !!this.responseResultsByCategory?.dataSets.find(e => e.label === 'RAC');
  }

  ngOnDestroy() {
    this.translationSub.unsubscribe()
  }
}
