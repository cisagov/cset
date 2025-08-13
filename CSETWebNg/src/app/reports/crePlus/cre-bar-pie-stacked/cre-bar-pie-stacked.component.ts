import { Component, Input, OnInit } from '@angular/core';
import { firstValueFrom } from 'rxjs';
import { CreService } from '../../../services/cre.service';
import { ConfigService } from '../../../services/config.service';
import { TranslocoService } from '@jsverse/transloco';

@Component({
  selector: 'app-cre-bar-pie-stacked',
  templateUrl: './cre-bar-pie-stacked.component.html',
  styleUrls: ['../../reports.scss', './cre-bar-pie-stacked.component.scss'],
  standalone: false,
})
export class CreBarPieStackedComponent implements OnInit {

  @Input()
  modelIdList: number[];

  distrib: any[];
  domainDistrib: any[];

  stackedModel: any[];
  stackedHeight: number;
  stackedPadding: number;

  // a list of domains in the current model
  modelDisplayName: string;
  domainsForModel: any[];


  /**
   * 
   */
  constructor(
    public creSvc: CreService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  async ngOnInit(): Promise<void> {
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
    let resp = await firstValueFrom(this.creSvc.getDomainAnswerDistrib([...modelIds])) || [];

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

  /**
    * Get the full answer distribution response from the API.
    * This contains all active domains and goals (subgroupings) for the model.
    */
  async getFullModel(modelId: number): Promise<any[]> {
    let resp = await firstValueFrom(this.creSvc.getDistribForModel(modelId)) || [];

    // translate the answer labels
    var behavior = this.configSvc.getModuleBehavior(modelId);
    var opts = behavior.answerOptions;
    this.modelDisplayName = this.tSvc.translate(behavior.displayNameKey ?? '');

    resp.forEach(x => {
      x.subgroups.forEach(element => {
        element.series.forEach(element => {
          const key = opts?.find(x => x.code === element.name)?.buttonLabelKey.toLowerCase() ?? 'u';
          element.name = this.tSvc.translate('answer-options.labels.' + key);
        });
      });
    });

    return resp;
  }

  /**
   * Calculates a height for the chart based on how many bars are in it 
   * and how long the labels are.
   */
  calcStackedHeight(items) {
    let h = Math.max(120, items.length * 60 + 100);

    // determine the max label of the bunch so that we can justify more height
    let maxLabelLength = 0;
    for (let l of items) {
      if (l.name.length > maxLabelLength) {
        maxLabelLength = l.name.length;
      }
    }

    // increase the height of the chart to accommodate the longer labels
    if (maxLabelLength > 20) {
      h = h * 1.3;
    }

    return h;
  }

  /**
   * Calculates a padding value for the chart based on how many bars are in it
   */
  calcStackedPadding(goals) {
    return Math.max(10, 30 - goals.length);
  }

  /**
   * Rounds and formats percentages
   */
  fmt3 = (label) => {
    const slice = this.distrib.find(slice => slice.name === label);
    return `${label}: ${Math.round(slice.value)}%`;
  }
}
