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
  modelList: number[];

  distrib: any[];
  domainDistrib: any[];

  stackedModel: any[];
  stackedHeight: number;
  stackedPadding: number;


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
    this.distrib = await this.buildAllDistrib(this.modelList);
    this.domainDistrib = await this.buildDomainDistrib(this.modelList);

    if (!!this.domainDistrib) {
      console.log(this.domainDistrib);
      //this.stackedModel = this.domainDistrib.subgroups;
      //this.calcStackedHeight();
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
  * 
  */
  // calcStackedHeight() {
  //   this.stackedHeight = Math.max(200, this.domainDistrib.subgroups.length * 50 + 100);
  //   this.stackedPadding = Math.max(10, 30 - this.domainDistrib.subgroups.length);
  // }

  fmt3 = (label) => {
    const slice = this.distrib.find(slice => slice.name === label);
    return `${label}: ${Math.round(slice.value)}%`;
  }

}
