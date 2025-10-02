////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { AfterViewChecked, Component, Input, OnInit, ChangeDetectorRef } from '@angular/core';
import { trigger, state, style, transition, animate } from '@angular/animations';
import { MaturityService } from '../../../../services/maturity.service';
import { SelectableGroupingsService } from '../../../../services/selectable-groupings.service';
import { QuestionGrouping } from '../../../../models/questions.model';
import { AssessmentService } from '../../../../services/assessment.service';

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
    public assessSvc: AssessmentService,
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
    // this.selectableGroupingsSvc.save(groupsChanged).subscribe();
    this.selectableGroupingsSvc.save(groupsChanged).subscribe((response: any) => {
      if (response?.completedCount !== undefined) {
        this.assessSvc.completionRefreshRequested$.next({
          completedCount: response.completedCount,
          totalCount: response.totalMaturityQuestionsCount || 0
        });
      }
    });
  }

  /**
   * Sets the clicked level and levels below it to true.
   */
  changeMilSelection(id: number, evt: any) {
    const milsForGoal = this.selectableGroupingsSvc.findGroupingAndLesser(this.modelId, id);
    this.selectableGroupingsSvc.save(milsForGoal).subscribe((response:any)=>{
      if (response?.completedCount !== undefined) {
        console.log(response)
        this.assessSvc.completionRefreshRequested$.next({
          completedCount: response.completedCount,
          totalCount: response.totalMaturityQuestionsCount || 0
        })
      }
    });

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
