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
import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { CpgService } from '../../../../services/cpg.service';
import { SsgService } from '../../../../services/ssg.service';
import { TranslocoService } from '@jsverse/transloco';
import { firstValueFrom } from 'rxjs';
import { DemographicService } from '../../../../services/demographic.service';
import { Demographic } from '../../../../models/assessment-info.model';

@Component({
  selector: 'app-cpg-summary',
  templateUrl: './cpg-summary.component.html',
  styleUrls: ['./cpg-summary.component.scss'],
  standalone: false
})
export class CpgSummaryComponent implements OnInit {

  modelId: number = 21;
  techDomain: string | undefined;

  answerDistribByDomainOt: any[];
  answerDistribByDomainIt: any[];

  isSsgApplicable = false;

  constructor(
    public assessSvc: AssessmentService,
    public demoSvc: DemographicService,
    public cpgSvc: CpgService,
    public ssgSvc: SsgService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  async ngOnInit(): Promise<void> {

    var xxx: Demographic = await firstValueFrom(this.demoSvc.getDemographic());
    this.techDomain = xxx.techDomain;

    console.log('1', this.techDomain);

    this.answerDistribByDomainOt = await this.getDistribForTechDomain(this.modelId, 'OT');
    console.log(2, this.answerDistribByDomainOt);
    this.answerDistribByDomainIt = await this.getDistribForTechDomain(this.modelId, 'IT');
    console.log(3, this.answerDistribByDomainIt);

    this.isSsgApplicable = this.ssgSvc.doesSsgApply();
  }

  /**
   * 
   */
  async getDistribForTechDomain(modelId: number, techDomain: string): Promise<any> {
    const resp = await firstValueFrom(this.cpgSvc.getAnswerDistrib(modelId, techDomain));
    const cpgAnswerOptions = this.configSvc.getModuleBehavior('CPG').answerOptions;

      resp.forEach(r => {
        r.series.forEach(element => {
          if (element.name == 'U') {
            element.name = this.tSvc.translate('answer-options.labels.u');
          } else {
            const key = cpgAnswerOptions?.find(x => x.code == element.name)?.buttonLabelKey;
            element.name = this.tSvc.translate('answer-options.labels.' + key?.toLowerCase());
          }
        });
      });

      return resp;    
  }
}
