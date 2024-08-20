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
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { CpgService } from '../../../services/cpg.service';
import { SsgService } from '../../../services/ssg.service';
import { MaturityService } from '../../../services/maturity.service';
import { QuestionsService } from '../../../services/questions.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-cpg-deficiency',
  templateUrl: './cpg-deficiency.component.html',
  styleUrls: ['./cpg-deficiency.component.scss', '../../reports.scss']
})
export class CpgDeficiencyComponent implements OnInit {

  cpgModelId = 11;

  loading = false;

  /**
   * Sorry for hardcoding the cpgPracticeTag,
   * but the purpose is to get the hardcoded HTML out of the question text,
   * so look at this if wonky stuff is happening with question text stuff
  */
  cpgPracticeTag: string = '<p class="cpg-practice">';

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;

  info: any;

  // deficient answers in the principal model
  def: any;

  /**
   * 
   */
  constructor(
    public assessSvc: AssessmentService,
    public titleSvc: Title,
    public maturitySvc: MaturityService,
    public questionsSvc: QuestionsService,
    public cpgSvc: CpgService,
    public ssgSvc: SsgService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.loading = true;

    this.titleSvc.setTitle(this.tSvc.translate('reports.core.cpg.deficiency.cpg deficiency') + " - " + this.configSvc.behaviors.defaultTitle);

    // make sure that the assessSvc has the assessment loaded so that we can determine any SSG model applicable
    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessSvc.assessment = assessmentDetail;
    });

    // get the deficient answers for the CPG model
    this.maturitySvc.getMaturityDeficiency(this.cpgModelId).subscribe((resp: any) => {
      this.info = resp.information;
      this.assessmentName = this.info.assessment_Name;
      this.assessmentDate = this.info.assessment_Date;
      this.assessorName = this.info.assessor_Name;
      this.facilityName = this.info.facility_Name;
      
      this.def = resp.deficienciesList;

      this.loading = false;
    });
  }
}
