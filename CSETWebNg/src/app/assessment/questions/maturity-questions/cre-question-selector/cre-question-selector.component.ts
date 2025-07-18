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

  @Input() cumulativeLevels = false;

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
   * Persists the selected/deselected state of a 
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
    this.selectableGroupingsSvc.save(groupsChanged).subscribe();
  }

  /**
   * Sets the clicked level and levels below it to true. 
   */
  changeMilSelection(id: number, evt: any) {
    const milsForGoal = this.selectableGroupingsSvc.findGroupingAndLesser(this.modelId, id);

    // persist the true group and the false group to the API
    this.selectableGroupingsSvc.save(milsForGoal).subscribe();

    this.selectableGroupingsSvc.emitSelectionChanged();
  }

  /**
   * Build a list of groups whose selected status is changed.
   * This will de-select all subgroups of a deselected parent.
   */
  buildList(g: QuestionGrouping): QuestionGrouping[] {
    let groupsChanged: QuestionGrouping[] = [];

    groupsChanged.push(g);

    if (!g.selected) {
      g.subGroupings.forEach(sg => {
        sg.selected = false;
        groupsChanged.push(sg);
      });
    }
    return groupsChanged;
  }
}
