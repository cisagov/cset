import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-heatmap',
  standalone: false,
  templateUrl: './heatmap.component.html',
  styleUrls: ['../reports.scss', './heatmap.component.scss']
})
export class HeatmapComponent implements OnInit {

  @Input()
  scores: any[];

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
  applyScoreStyle(element) {
    if (!!element.parent) {
      this.applyScoreStyle(element.parent);
    }

    element.children?.forEach(child => {
      this.applyScoreStyle(child);
    });

    const color = element.color?.toLowerCase() || 'default';
    element.class = this.colorToClassMap[color] || this.colorToClassMap['default'];
  }
}
