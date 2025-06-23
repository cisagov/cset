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
  countsCore: any[];
  viewCore2: [number, number] = [700, 800];

  distribOpt: any[];
  countsOpt: any[];
  viewOpt2: [number, number] = [700, 800];

  distribMil: any[];
  countsMil: any[];
  viewMil2: [number, number] = [700, 800];


  colorScheme = {
    domain: ['#5AA454', '#367190', '#b17300', '#DC3545']
  }


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

  async ngOnInit(): Promise<void> {
    this.titleService.setTitle(this.title);

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;
    });

    this.distribCore = await this.buildDistrib(22);
    this.countsCore = await this.buildDomainCounts(22);
    this.viewCore2 = this.updateViewSize(this.countsCore?.length);

    this.distribOpt = await this.buildDistrib(23);
    this.countsOpt = await this.buildDomainCounts(23);
    this.viewOpt2 = this.updateViewSize(this.countsOpt?.length);

    this.distribMil = await this.buildDistrib(24);
    this.countsMil = await this.buildDomainCounts(24);
    this.viewMil2 = this.updateViewSize(this.countsMil?.length);
  }

  /**
   * 
   */
  formatIntegerXAxis(val: number): string {
    return Number.isInteger(val) ? val.toFixed(0) : '';
  }

  /**
   * Determine the height based on the number of entries
   * plus 80px for the X-axis
   */
  updateViewSize(count: number): [number, number] {
    const height = (count * 80) + 80;
    return [700, Math.max(100, height)]; 
  }

  /**
   * 
   */
  async buildDistrib(modelId: number): Promise < any[] > {
      const resp = await this.creSvc.getNormalizedAnswerDistrib(modelId).toPromise() || [];

      // translate the answer labels
      var opts = this.configSvc.getModuleBehavior(modelId).answerOptions;

      resp.forEach(element => {
        const key = opts?.find(x => x.code === element.name)?.buttonLabelKey.toLowerCase();
        element.name = this.tSvc.translate('answer-options.labels.' + key);
      });

      return resp;
    }


  /**
   * 
   */
  async buildDomainCounts(modelId: number): Promise < any[] > {
      const resp = await this.creSvc.getDomainAnswerCounts(modelId).toPromise() || [];

      // translate the answer labels
      var opts = this.configSvc.getModuleBehavior(modelId).answerOptions;

      resp.forEach(element => {
        element.series.forEach(series => {
          const key = opts?.find(x => x.code === series.name)?.buttonLabelKey.toLowerCase();
          series.name = this.tSvc.translate('answer-options.labels.' + key);
        });
      });

      return resp;
    }
  }
