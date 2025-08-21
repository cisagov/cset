import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { firstValueFrom } from 'rxjs';
import { CreService } from '../../../services/cre.service';
import { ConfigService } from '../../../services/config.service';
import { TranslocoService } from '@jsverse/transloco';
import { Utilities } from '../../../services/utilities.service';

@Component({
  selector: 'app-cre-bar-pie-stacked',
  templateUrl: './cre-bar-pie-stacked.component.html',
  styleUrls: ['../../reports.scss', './cre-bar-pie-stacked.component.scss'],
  standalone: false,
})
export class CreBarPieStackedComponent implements OnInit {

  /**
   * The list of models represented by the charts in this section.  
   * Some sections have mulitple models combined into the charts.
   */
  @Input()
  modelIdList: number[];

  distrib: any[];
  domainDistrib: any[];

  stackedModel: any[];
  stackedHeight: number;
  stackedPadding: number;

  // a list of domains in the current model
  modelDisplayName: string;
  modelDisplayNameShort: string;
  domainsForModel: any[];

  // context-sensitive titles
  chartTitle: string;
  chartFooter1: string;
  chartFooter2: string;

  @Output() visibiltyChange = new EventEmitter<boolean>();

  /**
   * 
   */
  constructor(
    public creSvc: CreService,
    public configSvc: ConfigService,
    public utilSvc: Utilities,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  async ngOnInit(): Promise<void> {
    this.determineTitles(this.modelIdList);

    this.distrib = await this.buildAllDistrib(this.modelIdList);
    this.domainDistrib = await this.buildDomainDistrib(this.modelIdList);

    if (this.modelIdList.length == 1) {
      this.domainsForModel = await this.getFullModel(this.modelIdList[0]);
    }
  }

  /**
   * 
   */
  async buildAllDistrib(modelIds: number[]): Promise<any[]> {
    const resp = await firstValueFrom(this.creSvc.getAllAnswerDistrib([...modelIds])) || [];
    this.creSvc.translateAnswerOptions(modelIds[0], resp);
    return resp;
  }

  /**
   * 
   */
  async buildDomainDistrib(modelIds: number[]): Promise<any[]> {
    let resp = await firstValueFrom(this.creSvc.getDomainAnswerDistrib([...modelIds])) || [];

    resp.forEach(element => {
      this.creSvc.translateAnswerOptions(modelIds[0], element.series);
    });

    return resp;
  }

  /**
    * Get the full answer distribution response from the API.
    * This contains all active domains and goals (subgroupings) for the model.
    */
  async getFullModel(modelId: number): Promise<any[]> {
    let resp = await firstValueFrom(this.creSvc.getDistribForModel(modelId)) || [];

    // translate the answer labels
    var behavior = this.configSvc.getModuleBehavior(modelId);
    this.modelDisplayName = this.tSvc.translate(behavior.displayNameKey ?? '');

    resp.forEach(domain => {
      this.creSvc.translateAnswerOptions(modelId, domain.series);
      domain.subgroups.forEach(goal => {
        this.creSvc.translateAnswerOptions(modelId, goal.series);
      });
    });

    return resp;
  }

  /**
   * Calculates a height for the chart based on how many bars are in it 
   * and how long the labels are.
   */
  calcStackedHeight(items) {
    if (items == null) {
      return 300;
    }

    let h = Math.max(180, items.length * 100);

    // determine the max label of the bunch so that we can justify more height
    const maxLabelLength = Math.max(...items.map(d => d.name.length));

    // increase the height of the chart to accommodate the longer labels
    if (maxLabelLength > 50) {
      h = h * 1.3;
    }

    return h;
  }

  /**
   * Calculates a padding value for the chart based on how many bars are in it
   */
  calcStackedPadding(items) {
    return Math.max(10, 30 - items.length);
  }

  /**
   * Rounds and formats percentages
   */
  fmt3 = (label) => {
    const slice = this.distrib.find(slice => slice.name === label);
    return `${label}: ${Math.round(slice.value)}%`;
  }

  /**
   * Figures out the titles for the various charts based on the
   * models that are included in the charts.
   */
  determineTitles(modelIdList: number[]) {
    const sortedList = modelIdList.sort((a, b) => a - b);
    const ss = sortedList.join('+');

    this.chartTitle = this.tSvc.translate(`reports.core.cre.charts.${ss}.title`);
    this.chartFooter1 = this.tSvc.translate(`reports.core.cre.charts.${ss}.chart footer1`);
    this.chartFooter2 = this.tSvc.translate(`reports.core.cre.charts.${ss}.chart footer2`);

    this.modelDisplayNameShort = this.tSvc.translate(`reports.core.cre.charts.${ss}.displayNameShort`);
  }
}
