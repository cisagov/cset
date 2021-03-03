import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-edm-relationship',
  templateUrl: './edm-relationship.component.html',
  styleUrls: ['./edm-relationship.component.scss', '../../../../reports/reports.scss']
})
export class EdmRelationshipComponent implements OnInit, OnChanges {
  @Input() section: string;
  scores: any[];
  constructor(public maturitySvc: MaturityService) { }

  ngOnInit(): void {
  }

  ngOnChanges(): void {
    this.getEdmScores();
  }

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

  getEdmScoreStyle(score) {
    switch (score.toLowerCase()) {
      case 'red': return 'red-score';
      case 'yellow': return 'yellow-score';
      case 'green': return 'green-score';
      default: return 'default-score';
    }
  }
}
