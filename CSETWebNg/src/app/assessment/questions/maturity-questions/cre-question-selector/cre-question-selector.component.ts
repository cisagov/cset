import { AfterViewChecked, Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';
import { SelectableGroupingsService } from '../../../../services/selectable-groupings.service';
import { QuestionGrouping } from '../../../../models/questions.model';

@Component({
  selector: 'app-cre-question-selector',
  templateUrl: './cre-question-selector.component.html',
  styleUrl: './cre-question-selector.component.scss',
  standalone: false
})
export class CreQuestionSelectorComponent implements OnInit, AfterViewChecked {


  @Input() modelId: number;


  currentModelGroupings: QuestionGrouping[];

  // selectedDomains: number[] = [];
  // selectedSubdomains: number[] = [];

  domainSelected = true;
  milSelected = true;

  /**
   * 
   * @param maturitySvc 
   */
  constructor(
    public maturitySvc: MaturityService,
    public selectableGroupingsSvc: SelectableGroupingsService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {  }

  ngAfterViewChecked(): void {  }


  changeDomain(gi: number, evt: any) {
    this.selectableGroupingsSvc.models.get(this.modelId)[gi].selected = evt.target.checked;
    this.selectableGroupingsSvc.emitEvent();
  }
  
  changeSubdomain(gi: number, sgi: number, evt: any) {
    this.selectableGroupingsSvc.models.get(this.modelId)[gi].subGroupings[sgi].selected = evt.target.checked;
    this.selectableGroupingsSvc.emitEvent();
  }
}
