import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { MaturityService } from '../../../../services/maturity.service';
import { NavigationService } from '../../../../services/navigation.service';

@Component({
  selector: 'app-sprs-score',
  templateUrl: './sprs-score.component.html',
  styleUrls: ['./sprs-score.component.scss']
})
export class SprsScoreComponent implements OnInit {
  response: any;
  loading = true;
  dataError = false;

  constructor(
    public navSvc: NavigationService,
    public maturitySvc: MaturityService,
    private titleService: Title,
  ) { }

  ngOnInit(): void {
    this.maturitySvc.getSPRSScore().subscribe(result => {
      console.log(result);
      this.response = result;
      this.loading = false;
    },
      error => {
        this.dataError = true;
        this.loading = false;
        console.log('Site Summary report load Error: ' + (<Error>error).message);
      });
  }

}
