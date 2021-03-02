import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-edm-blocks-compact',
  templateUrl: './edm-blocks-compact.component.html',
  styleUrls: ['./edm-blocks-compact.component.scss', '../../../../reports/reports.scss']
})
export class EdmBlocksCompactComponent implements OnInit, OnChanges {

  @Input() section: string;

  scores: any[];
  
  /**
   * Constructor
   */
  constructor(public maturitySvc: MaturityService) { }

  /**
   * 
   */
  ngOnInit(): void {
  }

  /**
   * 
   */
  ngOnChanges(): void {
    this.getEdmScores();
  }

  /**
   * 
   */
  getEdmScores() {
    if (!!this.section) {
      this.maturitySvc.getEdmScores(this.section).subscribe(
        (r: any) => {
          this.scores = r;
        },
        error => console.log('RF Error: ' + (<Error>error).message)
      );
    }
  }

  /**
   * 
   * @param score 
   */
  getEdmScoreStyle(score) {
    switch (score.toLowerCase()) {
      case 'red': return 'red-score';
      case 'yellow': return 'yellow-score';
      case 'green': return 'green-score';
      default: return 'default-score';
    }
  }

  /**
   * Tries to replace "Goal" with "G" for brevity
   * @param title 
   */
  shorten(title: string): string {
    if (title.startsWith('Goal ')) {
      const s = title.split(' ');
      return 'G' + s[1];
    }
    return title;
  }

}
