import { AfterViewChecked, Component, Input, OnInit, ChangeDetectorRef } from '@angular/core';
import { trigger, state, style, transition, animate } from '@angular/animations';
import { MaturityService } from '../../../../services/maturity.service';
import { SelectableGroupingsService } from '../../../../services/selectable-groupings.service';
import { QuestionGrouping } from '../../../../models/questions.model';

@Component({
  selector: 'app-cre-question-selector',
  templateUrl: './cre-question-selector.component.html',
  styleUrl: './cre-question-selector.component.scss',
  standalone: false,
  animations: [
    trigger('expandCollapse', [
      state('collapsed', style({ height: '0px', overflow: 'hidden', padding: '0px' })),
      state('expanded', style({ height: '*', padding: '*' })),
      transition('collapsed <=> expanded', animate('0.3s ease'))
    ])
  ]
})
export class CreQuestionSelectorComponent implements OnInit {

  @Input() modelId: number;

  model: any;

  expanded = false;


  /**
   * 
   */
  constructor(
    public maturitySvc: MaturityService,
    public selectableGroupingsSvc: SelectableGroupingsService,
    public cdr: ChangeDetectorRef
  ) { }

  /**
   * 
   */
  async ngOnInit(): Promise<void> {
    this.model = this.selectableGroupingsSvc.models.get(this.modelId);
  }

  /**
   * 
   */
  toggleExpansion() {
    this.expanded = !this.expanded;
  }

  /**
   * 
   */
  changeGroupSelection(id: number, evt: any) {
    const g = this.selectableGroupingsSvc.findGrouping(this.modelId, id);

    if (!g) {
      return;
    }

    g.selected = evt.target.checked;

    this.selectableGroupingsSvc.emitSelectionChanged();

    // persist the changed group(s)
    const groupsChanged = this.buildList(g);
    this.selectableGroupingsSvc.save(groupsChanged, g.selected).subscribe();
  }

  /**
   * Build a list of groups whose selected status is changed.
   * This will de-select all subgroups of a deselected parent.
   */
  buildList(g: QuestionGrouping): number[] {
    let groupsChanged: number[] = [];
    groupsChanged.push(g.groupingId);

    if (!g.selected) {
      g.subGroupings.forEach(x => {
        x.selected = false;
        groupsChanged.push(x.groupingId);
      });
    }

    return groupsChanged;
  }
}
