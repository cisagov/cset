import { Component, OnInit } from '@angular/core';
import { firstValueFrom } from 'rxjs';
import { ConfigService } from '../../../services/config.service';
import { CreService } from '../../../services/cre.service';
import { TranslocoService } from '@jsverse/transloco';

@Component({
  selector: 'app-cre-mil-yes-no',
  standalone: false,
  templateUrl: './cre-mil-yes-no.component.html',
  styleUrl: './cre-mil-yes-no.component.scss'
})
export class CreMilYesNoComponent implements OnInit {

  modelDisplayName: string;

  domainList: any[];

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
    this.domainList = await this.getFullModel(24);
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
   * Format the text displayed for the achieved cell
   */
  valueCellLabel(score: number) {
    if (score == 100) {
      return this.tSvc.translate('answer-options.labels.yes');
    }
    return this.tSvc.translate('answer-options.labels.no');
  }

  /**
   * Format the achieved cell according to the specified score
   */
  valueCellClass(score: number) {
    if (score == 100) {
      return "mil-achieved";
    }
    return "mil-failed";
  }
}
