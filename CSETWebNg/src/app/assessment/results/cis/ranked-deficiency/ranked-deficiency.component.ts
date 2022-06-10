import { Component, OnInit } from '@angular/core';
import { CisService } from '../../../../services/cis.service';

@Component({
  selector: 'app-ranked-deficiency',
  templateUrl: './ranked-deficiency.component.html',
  styleUrls: ['./ranked-deficiency.component.scss']
})
export class RankedDeficiencyComponent implements OnInit {

  hasBaseline:boolean = false;

  constructor(public cisSvc: CisService) { }

  ngOnInit(): void {
    this.hasBaseline = this.cisSvc.hasBaseline();
  }

}
