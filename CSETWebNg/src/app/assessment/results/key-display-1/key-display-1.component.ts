import { Component } from '@angular/core';

@Component({
  selector: 'app-key-display-1',
  standalone: false,
  templateUrl: './key-display-1.component.html',
  styleUrls: ['../../../reports/reports.scss', './key-display-1.component.scss']
})
export class KeyDisplay1Component {

  goalLegend = [
    { scoreColor: 'green', scoreLabel: 'performed' },
    { scoreColor: 'yellow', scoreLabel: 'incompletely performed' },
    { scoreColor: 'red', scoreLabel: 'not performed' }
  ];

  questionLegend = [
    { scoreColor: 'green', scoreLabel: 'Implemented' },
    { scoreColor: 'blue', scoreLabel: 'In Progress' },
    { scoreColor: 'gold', scoreLabel: 'Scoped' },
    { scoreColor: 'red', scoreLabel: 'Not Implemented' },
  ];
}
