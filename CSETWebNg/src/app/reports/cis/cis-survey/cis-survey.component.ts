import { Component, OnInit } from '@angular/core';
import { CisService } from '../../../services/cis.service';

@Component({
  selector: 'app-cis-survey',
  templateUrl: './cis-survey.component.html',
  styleUrls: ['./cis-survey.component.scss']
})
export class CisSurveyComponent implements OnInit {

  /**
   * The "top 5" sections, nicknamed the "domains"
   */
  domains: any[];

  constructor(
    public cisSvc: CisService
  ) { }

  ngOnInit(): void {
    this.cisSvc.getCisSection(2301).subscribe((resp: any) => {
      console.log(resp);

      this.domains = resp.groupings;
    });
  }



}
