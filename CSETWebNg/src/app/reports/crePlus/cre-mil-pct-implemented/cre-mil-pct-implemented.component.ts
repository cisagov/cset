import { Component, OnInit } from '@angular/core';
import { CreService } from '../../../services/cre.service';
import { ConfigService } from '../../../services/config.service';
import { TranslocoService } from '@jsverse/transloco';
import { firstValueFrom } from 'rxjs';

@Component({
  selector: 'app-cre-mil-pct-implemented',
  standalone: false,
  templateUrl: './cre-mil-pct-implemented.component.html',
  styleUrl: './cre-mil-pct-implemented.component.scss'
})
export class CreMilPctImplementedComponent implements OnInit {

  newList: any[];


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
    const origList = await this.getFullModel(24);
    this.newList = this.convertData(origList);
  }


  /**
   * Builds an object that the chart can use to display the MIL values
   */
  convertData(data: any[]): any[] {
    const top: any[] = [];

    for (let domain of data) {
      const newD = { name: domain.name, series: [] as { name: string; value: number }[] };

      // add in a MIL1 placeholder
      newD.series.push({ name: 'MIL1', value: 50 });

      for (let mil of domain.subgroups) {
        newD.series.push({ name: mil.name, value: mil.series[0].value });
      }

      top.push(newD);
    }

    return top;
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


    resp.forEach(domain => {
      domain.subgroups.forEach(mil => {
        // shorten the label
        let i = mil.name.indexOf('-');
        mil.name = i !== -1 ? mil.name.substring(0, i).trim() : mil.name;

        // translate the answer option labels
        mil.series.forEach(ansCount => {
          const key = opts?.find(x => x.code === ansCount.name)?.buttonLabelKey.toLowerCase() ?? 'u';
          ansCount.name = this.tSvc.translate('answer-options.labels.' + key);
        });
      });
    });

    return resp;
  }

  /**
   * 
   */
  calcHeight(s) {
    return Math.max(200, s * 100);
  }
}
