import { Component, OnInit } from '@angular/core';
import { CpgService } from '../../../../services/cpg.service';

@Component({
  selector: 'app-cpg-score',
  standalone: false,
  templateUrl: './cpg-score.component.html',
  styleUrl: './cpg-score.component.scss'
})
export class CpgScoreComponent implements OnInit {

  score: number;

  /**
   * 
   */
  constructor(
    public cpgSvc: CpgService
  ) {  }

  /**
   * 
   */
  ngOnInit(): void {
    this.cpgSvc.getScore().subscribe((score: number) => {
      this.score = score;
    });
  }
}
