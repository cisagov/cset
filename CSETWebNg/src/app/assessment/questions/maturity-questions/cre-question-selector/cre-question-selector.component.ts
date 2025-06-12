import { AfterViewChecked, Component, Input, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';
import { SelectableGroupingsService } from '../../../../services/selectable-groupings.service';

@Component({
  selector: 'app-cre-question-selector',
  templateUrl: './cre-question-selector.component.html',
  styleUrl: './cre-question-selector.component.scss',
  standalone: false
})
export class CreQuestionSelectorComponent implements OnInit, AfterViewChecked {


  @Input() modelId: number;

  selectedGroupIds: number[] = [];

  /**
   * 
   */
  constructor(
    public maturitySvc: MaturityService,
    public selectableGroupingsSvc: SelectableGroupingsService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.selectableGroupingsSvc.getSelectedGroupIds().subscribe((x: number[]) => {
      console.log(x);
      this.selectedGroupIds = x;
    });
  }

  ngAfterViewChecked(): void {

  }


  /**
   * 
   */
  changeDomain(gi: number, evt: any) {
    const g = this.selectableGroupingsSvc.models.get(this.modelId)[gi];
    g.selected = evt.target.checked;
    this.selectableGroupingsSvc.emitSelectionChanged();

    if (g.selected) {
      this.selectedGroupIds.push(g.groupingID);
    } else {
      this.selectedGroupIds = this.selectedGroupIds.filter(x => x != g.groupingID);
    }

    this.selectableGroupingsSvc.save(g.groupingID, g.selected).subscribe();
  }

  /**
   * 
   */
  changeSubdomain(gi: number, sgi: number, evt: any) {
    const g = this.selectableGroupingsSvc.models.get(this.modelId)[gi].subGroupings[sgi];
    g.selected = evt.target.checked;
    this.selectableGroupingsSvc.emitSelectionChanged();

     if (g.selected) {
      this.selectedGroupIds.push(g.groupingID);
    } else {
      this.selectedGroupIds = this.selectedGroupIds.filter(x => x != g.groupingID);
    }

    this.selectableGroupingsSvc.save(g.groupingID, g.selected).subscribe();
  }
}
