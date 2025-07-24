////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { AfterViewInit, Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { CpgService } from '../../../services/cpg.service';
import { SsgService } from '../../../services/ssg.service';
import { TranslocoService } from '@jsverse/transloco';
import { HtmlReaderService } from '../../../services/htmlReader.service'; 
import { HtmlToDocxService } from '../../../services/htmlToDocx.service';

@Component({
    selector: 'app-cpg-report',
    templateUrl: './cpg-report.component.html',
    styleUrls: ['./cpg-report.component.scss', '../../reports.scss'],
    standalone: false
})
export class CpgReportComponent implements OnInit {
  loading = false;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;
  htmlString: string="";

  answerDistribByDomain: any;

  isSsgApplicable = false;
  ssgBonusModel: number = null;


  /**
   * 
   */
  constructor(
    public titleSvc: Title,
    private assessSvc: AssessmentService,
    public cpgSvc: CpgService,
    public ssgSvc: SsgService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService, 
    public readerSvc: HtmlReaderService,
    public docxSvc: HtmlToDocxService
  ) { }



  /**
   * 
   */
  ngOnInit(): void {
    this.tSvc.selectTranslate('core.cpg.report.cpg report', {}, { scope: 'reports' })
      .subscribe(title =>
        this.titleSvc.setTitle(title + ' - ' + this.configSvc.behaviors.defaultTitle));

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;

      this.assessSvc.assessment = assessmentDetail;
      this.isSsgApplicable = this.ssgSvc.doesSsgApply();
      this.ssgBonusModel = this.ssgSvc.ssgBonusModel();
    });

    this.cpgSvc.getAnswerDistrib().subscribe((resp: any) => {
      const cpgAnswerOptions = this.configSvc.getModuleBehavior('CPG').answerOptions;

      resp.forEach(r => {
        r.series.forEach(element => {
          if (element.name == 'U') {
            element.name = this.tSvc.translate('answer-options.labels.u');
          } else {
            const key = cpgAnswerOptions?.find(x => x.code == element.name).buttonLabelKey;
            element.name = this.tSvc.translate('answer-options.labels.' + key.toLowerCase());
          }
        });
      });

      this.answerDistribByDomain = resp;
    });

    
  }
  
  extractContent(){
    this.htmlString = this.readerSvc.readHtmlByClassName("word-conversion");
     this.docxSvc.convertHtmlToDocx(this.htmlString);       
  }
}
