import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';
import { ConfigService } from '../../../services/config.service';
import { Title } from '@angular/platform-browser';
import { CreService } from '../../../services/cre.service';
import { TranslocoScope, TranslocoService } from '@jsverse/transloco';


@Component({
  selector: 'app-cre-chart-report',
  standalone: false,
  templateUrl: './cre-chart-report.component.html',
  styleUrls: ['../../reports.scss'],
})
export class CreChartReportComponent implements OnInit {

  title = 'CISA Cyber Resilience Essentials (CRE+) Chart Report';
  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;

  distribCore: any[];
  domainDistrib: any[];

  


  colorScheme = {
    domain: ['#5AA454', '#367190', '#b17300', '#DC3545', '#eeeeee']
  }

  /**
   * CTOR
   */
  constructor(
    public assessSvc: AssessmentService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    public creSvc: CreService,
    public titleService: Title,
    public tSvc: TranslocoService
  ) {

  }

  /**
   * OnInit
   */
  async ngOnInit(): Promise<void> {
    this.titleService.setTitle(this.title);

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;
    });

    this.distribCore = await this.buildDistrib([22, 23, 24]);
    this.domainDistrib = await this.buildDomainDistrib([22,23,24]);
  }

  /**
   * 
   */
  async buildDistrib(modelIds: number[]): Promise<any[]> {
    const resp = await this.creSvc.getNormalizedAnswerDistrib([...modelIds]).toPromise() || [];

    // translate the answer labels
    var opts = this.configSvc.getModuleBehavior(modelIds[0]).answerOptions;

    resp.forEach(element => {
      const key = opts?.find(x => x.code === element.name)?.buttonLabelKey.toLowerCase() ?? 'u';
      element.name = this.tSvc.translate('answer-options.labels.' + key);
    });

    return resp;
  }


  /**
   * 
   */
  async buildDomainDistrib(modelIds: number[]): Promise<any[]> {
    const resp = await this.creSvc.getDomainAnswerCounts([...modelIds]).toPromise() || [];

    // translate the answer labels
    var opts = this.configSvc.getModuleBehavior(modelIds[0]).answerOptions;

    resp.forEach(element => {
      element.series.forEach(series => {
        const key = opts?.find(x => x.code === series.name)?.buttonLabelKey.toLowerCase() ?? 'u';
        series.name = this.tSvc.translate('answer-options.labels.' + key);
      });
    });

    return resp;
  }


  /*************
  Label and tooltip formatting functions 
  ***************/

  fmt1 = (value) => {
    return `${Math.round(value)}%`;
  };

  fmt2 = (label) => {
    const slice = this.distribCore.find(slice => slice.name === label);
    return `${label}: ${Math.round(slice.value)}%`;
  }

  fmt3 = (obj) => {
    return `${obj.data.name}<br>${Math.round(obj.data.value)}%`;
  }
}
