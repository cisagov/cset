import { Component, OnInit } from '@angular/core';
import { firstValueFrom } from 'rxjs';
import { ConfigService } from '../../../services/config.service';
import { CreService } from '../../../services/cre.service';
import { TranslocoService } from '@jsverse/transloco';

@Component({
  selector: 'app-cre-mil-yes-no',
  standalone: false,
  templateUrl: './cre-mil-yes-no.component.html',
  styleUrls: ['../../reports.scss', './cre-mil-yes-no.component.scss']
})
export class CreMilYesNoComponent implements OnInit {

  modelDisplayName: string;

  domainList: any[];

  activeItemsExistForModel: boolean;

  /**
   * 
   */
  constructor(
    public creSvc: CreService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService
  ) { }

  /**
   * Gets the MIL model (24) and the Core model (22).  
   * Inserts the Core domain distributions into the MIL
   * model as "MIL1".
   */
  async ngOnInit(): Promise<void> {
    this.domainList = await this.creSvc.getMilIncludingMil1();

    // if the distribution percentages are NaN, we know we have no active domains/goals
    this.activeItemsExistForModel = !this.domainList.every(x => isNaN(x.value));
    if (!this.activeItemsExistForModel) {
      return;
    }
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
