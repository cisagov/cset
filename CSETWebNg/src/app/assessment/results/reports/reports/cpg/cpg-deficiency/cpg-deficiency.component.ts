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
import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../../../../services/assessment.service';
import { ConfigService } from '../../../../../../services/config.service';
import { CpgService } from '../../../../../../services/cpg.service';
import { SsgService } from '../../../../../../services/ssg.service';
import { MaturityService } from '../../../../../../services/maturity.service';
import { QuestionsService } from '../../../../../../services/questions.service';
import { TranslocoService } from '@jsverse/transloco';
import { forkJoin, Observable, tap } from 'rxjs';

@Component({
  selector: 'app-cpg-deficiency',
  templateUrl: './cpg-deficiency.component.html',
  styleUrls: ['./cpg-deficiency.component.scss', '../../reports.scss'],
  standalone: false
})
export class CpgDeficiencyComponent implements OnInit {
  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;

  info: any;

  // deficient answers in the principal model (CPG)
  loadingCpg = false;
  cpgDeficiencyList: any[] = [];

  // deficient SSG answers
  loadingSsg = false;
  ssgBonusModels: number[];
  ssgModels: any[] = [];

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
    this.tSvc.selectTranslate('core.cpg.deficiency.cpg deficiency', {}, { scope: 'reports' })
      .subscribe(title => {
        this.titleSvc.setTitle(title + ' - ' + this.configSvc.behaviors.defaultTitle)
      });

    // make sure that the assessSvc has the assessment loaded so that we can determine any SSG model applicable
    this.loadingCpg = true;
    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {

      this.assessSvc.assessment = assessmentDetail;
      // get the deficient answers for the CPG model
      const assessment = this.assessSvc.assessment;
      const maturityModel = assessment?.maturityModel;


      if (maturityModel?.modelId) {
        this.getCpgModel(maturityModel.modelId);
      }

      // get any deficient answers for the SSG model
      this.getSsgModels();
    });
  }

  /**
   * 
   */
  getCpgModel(modelId: number) {
    this.loadingCpg = true;
    this.maturitySvc.getMaturityDeficiency(modelId).subscribe((response: any) => {
      const { information, deficienciesList } = response;

      this.info = information;
      this.assessmentName = information.assessment_Name;
      this.assessmentDate = information.assessment_Date;
      this.assessorName = information.assessor_Name;
      this.selfAssessment = information.selfAssessment;
      this.facilityName = information.facility_Name;
      this.cpgDeficiencyList = deficienciesList;

      this.loadingCpg = false;
    });
  }

  /**
   * 
   */
  getSsgModels() {
    this.loadingSsg = true;
    this.ssgBonusModels = this.ssgSvc.activeSsgModelIds;

    const obs: Observable<any>[] = [];
    this.ssgBonusModels.forEach(m => obs.push(this.maturitySvc.getMaturityDeficiency(m)));

    forkJoin(obs).subscribe((results: any) => {
      this.loadingSsg = false;
      this.ssgModels = results;
    });
  }
}