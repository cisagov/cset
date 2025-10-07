import { Component, Input, OnInit } from '@angular/core';
import { CpgService } from '../../../../services/cpg.service';

/**
 * Displays separate scores for the CPG2 IT and OT questions.
 * The scores are a percentage compliant, with each "Y"
 * answer receiving 1 point.  In-progress ("I") answers
 * receive half credit, 0.5 point.  All other answer
 * options receive 0 points.  All points are averaged
 * and a percentage score is rendered.
 */
@Component({
  selector: 'app-cpg-score',
  standalone: false,
  templateUrl: './cpg-score.component.html',
  styleUrl: './cpg-score.component.scss'
})
export class CpgScoreComponent implements OnInit {

  @Input()
  itScore?: number;

  @Input()
  otScore?: number;

  @Input()
  techDomain?: string;

  TECH_DOMAIN_OT = ['OT', 'OT+IT', null];
  TECH_DOMAIN_IT = ['IT', 'OT+IT', null];

  /**
   * 
   */
  constructor(
    public cpgSvc: CpgService
  ) { }

  /**
   * 
   */
  ngOnInit(): void { }
}
