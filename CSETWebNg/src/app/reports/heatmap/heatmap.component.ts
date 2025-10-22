import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-heatmap',
  standalone: false,
  templateUrl: './heatmap.component.html',
  styleUrls: ['../reports.scss', './heatmap.component.scss']
})
export class HeatmapComponent implements OnInit {

  /**
   * An array of groupings, typically the goals within a domain.
  */
  @Input()
  scores!: any[];

  /**
   * Optional - host page can suppress goal labels
   */
  @Input()
  showGoalLabels = true;

  /**
   * Optional - host page can suppress question labels
   */
  @Input()
  showQuestionLabels = true;


  colorToClassMap: Record<string, string> = {
    'red': 'red-score',
    'yellow': 'yellow-score',
    'gold': 'gold-score',
    'blue': 'blue-score',
    'green': 'green-score',
    'lightgray': 'light-gray-score',
    'default': 'default-score'
  };


  constructor() { }

  /**
   * 
   */
  ngOnInit(): void {
    this.scores.forEach(element => this.applyScoreStyle(element));
  }

  /**
   * 
   * @param score 
   * @returns 
   */
  applyScoreStyle(element: any) {
    element.children?.forEach((child: any) => {
      this.applyScoreStyle(child);
    });

    const color = element.color?.toLowerCase() || 'lightgray';
    element.scoreClass = this.colorToClassMap[color];

    // suppress goal label
    if (!this.showGoalLabels && !element.questionId) {
      element.title = '';
    }
    // suppress question label
    if (!this.showQuestionLabels && element.questionId && element.questionId !== 0) {
      element.title = '';
    }
  }
}
