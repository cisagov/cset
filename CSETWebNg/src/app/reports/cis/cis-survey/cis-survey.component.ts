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
  domains: any[] = [];

  loading = false;

  constructor(
    public cisSvc: CisService
  ) { }

  ngOnInit(): void {
    this.loading = true;
    this.cisSvc.getCisSection(0).subscribe((resp: any) => {
      this.domains.push(resp);
      this.loading = false;
    });
  }
}
